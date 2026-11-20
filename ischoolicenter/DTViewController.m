//
//  DTViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 5/11/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "DTViewController.h"
#import "MainMenuViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "DTAddEditViewController.h"
#import "StudentInformationViewController.h"
#import "MyClass.h"
#import "StudentDetailsNavController.h"
#import "MyTableViewCell.h"
#import "MainViewController.h"
#import "SceneDelegate.h"

@interface DTViewController ()
{
    BOOL sideWindowAdjusting;
    NSMutableDictionary *edgeConstants;
    CGFloat laidOutDTWidth;
}
@end

@implementation DTViewController
@synthesize JSONArray,DTArray,DTObject;
@synthesize scStatus,sctype;
@synthesize selectedmonth;
@synthesize myPopoverController,selecteddtkey;
@synthesize myStudentPopoverController;


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
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    //sctype.frame=CGRectMake(3, 112, self.view.frame.size.width-280, 29);
    title_Status.frame=CGRectMake(self.view.frame.size.width-143, 0, 103, 21);
    title_Attendance.frame=CGRectMake(self.view.frame.size.width-303, 0, 127, 21);
    

    
    statusarray=[[NSArray alloc]initWithObjects:@"All",@"Open",@"Closed", nil];
    typearray=[[NSArray alloc]initWithObjects:@"All",@"Student",@"Lead", nil];
    
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
    

    
    [self createView];
    [self loadtitle];
    

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
    
}


-(void) checktoreloadapp
{
    
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {
        if ([myPopoverController presentingViewController].isBeingPresented) {
            [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([myStudentPopoverController presentingViewController].isBeingPresented){
            [[myStudentPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==switchcenterviewcontroller) {
            [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
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
                }else if ([myStudentPopoverController presentingViewController].isBeingPresented){
                    [[myStudentPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
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
    
    headercentername.text=[MyClass returnWindowTitle];
    headertitlename.text=[MyClass returntitlewithtitle:@"Assessment and Trial"];
    dtsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    [self updateheadercentertitle];
    
}

- (CGFloat)visibleDTWidth
{
    CGFloat width = self.view.bounds.size.width;
    UIWindow *window = self.view.window;
    if (!window || width < 1) return width;
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGFloat leftShift = MAX(CGRectGetMinX(frameInWindow) - CGRectGetMinX(window.bounds), 0);
    CGFloat rightOverflow = MAX(CGRectGetMaxX(frameInWindow) - CGRectGetMaxX(window.bounds), 0);
    CGFloat menuSlide = MIN(leftShift, rightOverflow);
    return MAX(width - (rightOverflow - menuSlide), 0);
}

- (CGFloat)visibleDTHeight
{
    CGFloat height = self.view.bounds.size.height;
    UIWindow *window = self.view.window;
    if (!window || height < 1) return height;
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    return MAX(MIN(MIN(CGRectGetMaxY(frameInWindow), CGRectGetMaxY(window.bounds)) - CGRectGetMinY(frameInWindow), height), 0);
}

- (CGRect)visibleWindowFrame
{
    UIWindow *window = self.view.window ? self.view.window : mainWindow;
    if (!window) return CGRectZero;
    if (!self.isViewLoaded || !self.view.window) return window.bounds;
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGRect visible = CGRectIntersection(frameInWindow, window.bounds);
    if (CGRectIsNull(visible) || visible.size.width < 1 || visible.size.height < 1) return window.bounds;
    return visible;
}

- (void)layoutDTForCurrentSize
{
    CGFloat width = [self visibleDTWidth];
    CGFloat height = [self visibleDTHeight];
    if (width < 1 || height < 1) return;
    if (!edgeConstants) {
        edgeConstants = [NSMutableDictionary dictionary];
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            BOOL horizontal = constraint.firstItem == self.view && (constraint.firstAttribute == NSLayoutAttributeTrailing || constraint.firstAttribute == NSLayoutAttributeTrailingMargin) && constraint.secondAttribute == NSLayoutAttributeTrailing;
            BOOL vertical = constraint.firstItem == self.view && (constraint.firstAttribute == NSLayoutAttributeBottom || constraint.firstAttribute == NSLayoutAttributeBottomMargin) && constraint.secondAttribute == NSLayoutAttributeBottom;
            if (horizontal || vertical) {
                edgeConstants[[NSValue valueWithNonretainedObject:constraint]] = @(constraint.constant);
            }
        }
    }
    CGFloat overflow = MAX(self.view.bounds.size.width - width, 0);
    CGFloat verticalOverflow = MAX(self.view.bounds.size.height - height, 0);
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        NSNumber *original = edgeConstants[[NSValue valueWithNonretainedObject:constraint]];
        if (!original) continue;
        BOOL vertical = constraint.firstAttribute == NSLayoutAttributeBottom || constraint.firstAttribute == NSLayoutAttributeBottomMargin;
        CGFloat target = original.doubleValue + (vertical ? verticalOverflow : overflow);
        if (fabs(constraint.constant - target) > 0.5) constraint.constant = target;
    }
    CGFloat titleWidth = MAX(width - 140.0, 0);
    headertitleview.frame = CGRectMake(70, 0, titleWidth, 68);
    headertitlename.frame = CGRectMake(0, 25, titleWidth, 20);
    switchcenterbutton.frame = CGRectMake(0, 0, titleWidth, 68);
    [self updateheadercentertitle];
    UIView *statusHeader = title_Status.superview;
    if (statusHeader && statusHeader != self.view) {
        CGRect headerFrame = statusHeader.frame;
        headerFrame.size.width = width;
        statusHeader.frame = headerFrame;
    }
    if (title_Status) title_Status.frame = CGRectMake(width - 143, title_Status.frame.origin.y, 103, 21);
    if (title_Attendance) title_Attendance.frame = CGRectMake(width - 303, title_Attendance.frame.origin.y, 127, 21);
    if (reloadbutton) reloadbutton.frame = CGRectMake(width - 45, 34, 28, 28);
    if (datebartable && fabs(width - laidOutDTWidth) > 0.5) {
        laidOutDTWidth = width;
        CGPoint offset = datebartable.contentOffset;
        datebartable.transform = CGAffineTransformIdentity;
        CGFloat barWidth = MAX(width - 101.0, 0);
        datebartable.frame = CGRectMake(101, 69, barWidth, 40);
        CGPoint center = datebartable.center;
        datebartable.frame = CGRectMake(69, 101, 40, barWidth);
        datebartable.transform = CGAffineTransformMakeRotation(-M_PI_2);
        datebartable.center = center;
        datebartable.contentOffset = offset;
    }
}

- (void)pinOpenSideWindowToVisibleEdge
{
    if (sideWindowAdjusting || !sidewindowview || sidewindowview.hidden || sidewindowview.frame.size.width < 1.0) return;
    CGRect visible = [self visibleWindowFrame];
    if (visible.size.width < 1.0 || visible.size.height < 1.0) return;
    CGFloat panelWidth = MIN(sidewindowview.frame.size.width, visible.size.width);
    sidewindowview.frame = CGRectMake(CGRectGetMaxX(visible) - panelWidth, visible.origin.y, panelWidth, visible.size.height);
    if (sidewindowviewclosebutton && !sidewindowviewclosebutton.hidden) sidewindowviewclosebutton.frame = visible;
    for (UIView *child in sidewindowview.subviews) {
        if ([child isKindOfClass:[UIActivityIndicatorView class]]) continue;
        child.frame = sidewindowview.bounds;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutDTForCurrentSize];
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


-(void) refreshdttable
{
    [MyClass getLatestDataSetv2withParameters:@"lead,student" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    [self retrieveDTRecordWithDTstatus:[statusarray objectAtIndex:[scStatusBar selectedSegmentIndex]] month:selectedmonth type:[typearray objectAtIndex:[sctype selectedSegmentIndex]]];
    for (id object in [DTTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
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
            DTTable.scrollEnabled=TRUE;
            [DTTable deselectRowAtIndexPath:[DTTable indexPathForSelectedRow] animated: YES];
        }
    }
}

-(void) attendanceringreleasedwithtouchpoint:(CGPoint)touchpoint
{
    //check if inside ring
    if ([MyClass returntouchpointwithinattendanceringwithtouchpoint:touchpoint size:@"large"]) {
        NSIndexPath *selectedIndexPath = [DTTable indexPathForSelectedRow];
        [self updateattendancewithindexpath:selectedIndexPath value:((AttendanceButtonObject *)[attendancebuttonarray objectAtIndex:lasttouchedsector]).buttonname];
    }
}

-(void)updateattendancewithindexpath:(NSIndexPath *)indexpath value:(NSString *)value
{
    
    //update class information
    DTObject=[[AssessmentTrialRecord alloc]init];
    DTObject=[filteredDTArray objectAtIndex:indexpath.row];
    
    if (![value isEqualToString:DTObject.attendance]) {
        NSString *strURL;
        
        
        strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatedt&dtkey=%@&attendance=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DTObject.DTkey,value];
        
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
                result = TRUE;
            }
            dispatch_semaphore_signal(semaphore);
        }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
        if (result) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self retrieveDTRecordWithDTstatus:[statusarray objectAtIndex:[scStatusBar selectedSegmentIndex]] month:selectedmonth type:[typearray objectAtIndex:[sctype selectedSegmentIndex]]];
            });
        }/*else{
            [MyClass showconnectionlostdialogbox];
        }*/
    }
}

-(void) attendancebuttontouchupinside:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{attendanceringview.alpha = 0.0;} completion:^(BOOL finished){ [attendanceringview removeFromSuperview]; }];
    attendanceringview=nil;
    [self.mainSlideMenu enableSlidePanGestureForLeftMenu];
    DTTable.scrollEnabled=TRUE;
    [DTTable deselectRowAtIndexPath:[DTTable indexPathForSelectedRow] animated: YES];
}

-(void) attendancebuttontouchdown:(UIButton *)sender
{
    //in case if there is any freeze ring remain previously
    if (attendanceringview) {
        [attendanceringview removeFromSuperview];
        attendanceringview=nil;
    }else{
        DTTable.scrollEnabled=FALSE;
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:DTTable];
        NSIndexPath *indexpath =[DTTable indexPathForRowAtPoint:point];
        [DTTable selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        [self.mainSlideMenu disableSlidePanGestureForLeftMenu];
        
        DTObject=[filteredDTArray objectAtIndex:indexpath.row];
        
        attendancebuttonarray=[[NSMutableArray alloc]initWithArray:makeupdtattendancebuttonarray];
        attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:DTObject.attendance highlightbutton:DTObject.attendance attendancebuttonarray:attendancebuttonarray inview:self.view size:@"large"];
        
        [self.view addSubview:attendanceringview];
        lasttouchedsector=0;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.mainSlideMenu disableSlidePanGestureForRightMenu];
    globalvariables.lastviewcontroller=(NSString *)self;
    
    
            if (sidewindowview.hidden || sidewindowview.frame.size.width < 1) {
    [self reloadPageWithFirstLoad:YES];
            }

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

-(BOOL) retrieveDTRecordWithDTstatus:(NSString *)dtstatus month:(NSString *)calendarmonth type:(NSString *)type
{
    
    __block int selecteddtkeyindex=-1;
    //create string contains url address for php file
    
    
    NSString *month;
    NSString *year;
    if ([calendarmonth isEqualToString:@"All"]) {
        month=@"All";
        year=@"All";
    }else{
        [df setDateFormat:@"MMMM yyyy"];
        NSDate *date=[df dateFromString:calendarmonth];
        [df setDateFormat:@"M"];
        month=[df stringFromDate:date];
        year=[calendarmonth substringFromIndex:([calendarmonth length]-4)];
    }

    
    
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectassessmenttrialclass&status=%@&month=%@&year=%@&type=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewassessment"],dtstatus,month,year,type];

    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            //NSDateFormatter *df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            DTArray=[[NSMutableArray alloc] init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                NSString * sdtkey=[[JSONArray objectAtIndex:i] objectForKey:@"dtkey"];
                if ([sdtkey isEqualToString:selecteddtkey]) {
                    selecteddtkeyindex=i;
                }
                
                NSString * stype=[[JSONArray objectAtIndex:i] objectForKey:@"type"];
                NSString * sleadkey=[[JSONArray objectAtIndex:i] objectForKey:@"leadkey"];
                NSString * sstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                
                NSString * sstudentfullname;
                if ([stype isEqualToString:@"student"]) {
                    sstudentfullname=[MyClass returnStudentnameWithStudentkey:sstudentkey option:@"full"];
                }else{
                    sstudentfullname=[MyClass returnLeadnameWithLeadkey:sleadkey option:@"full"];
                }
                
                
                NSString * sfirstname=[[JSONArray objectAtIndex:i] objectForKey:@"firstname"];
                NSString * slastname=[[JSONArray objectAtIndex:i] objectForKey:@"lastname"];
                NSString * sothername=[[JSONArray objectAtIndex:i] objectForKey:@"othername"];
                NSString * sgrade=[[JSONArray objectAtIndex:i] objectForKey:@"grade"];
                NSString * sgender=[[JSONArray objectAtIndex:i] objectForKey:@"gender"];
                
                NSString *sdateofbirth;
                if (![[[JSONArray objectAtIndex:i] objectForKey:@"dateofbirth"] isEqualToString:@""]) {
                    [df setDateFormat:@"yyyy-MM-dd"];
                    NSDate *date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"dateofbirth"]];
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    sdateofbirth = [df stringFromDate:date];
                }else{
                    sdateofbirth=@"";
                }

                NSString * sage=[[JSONArray objectAtIndex:i] objectForKey:@"age"];
                NSString * sschool=[[JSONArray objectAtIndex:i] objectForKey:@"school"];
                NSString * sprofileremarks=[[JSONArray objectAtIndex:i] objectForKey:@"profileremarks"];
                NSString * sparentname=[[JSONArray objectAtIndex:i] objectForKey:@"parentname"];
                NSString * sparentcontact=[[JSONArray objectAtIndex:i] objectForKey:@"parentcontact"];
                NSString * sparentemail=[[JSONArray objectAtIndex:i] objectForKey:@"parentemail"];
                NSString * sparentaddress=[[JSONArray objectAtIndex:i] objectForKey:@"parentaddress"];
                NSString * spreferredlanguage=[[JSONArray objectAtIndex:i] objectForKey:@"preferredlanguage"];
                NSString * simage=[[JSONArray objectAtIndex:i] objectForKey:@"image"];
                NSString * sclasstype=[[JSONArray objectAtIndex:i] objectForKey:@"classtype"];
                NSString * sdtstatus=[[JSONArray objectAtIndex:i] objectForKey:@"dtstatus"];
                
                NSString *sdtdate;
                if (![[[JSONArray objectAtIndex:i] objectForKey:@"dtdate"] isEqualToString:@""]) {
                    sdtdate=[[JSONArray objectAtIndex:i] objectForKey:@"dtdate"];
                }else{
                    sdtdate=@"";
                }
                
                NSString * sdttime=[[JSONArray objectAtIndex:i] objectForKey:@"dttime"];
                NSString * sclassduration=[[JSONArray objectAtIndex:i] objectForKey:@"classduration"];
                NSString * ssubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString * slevelmain=[[JSONArray objectAtIndex:i] objectForKey:@"levelmain"];
                NSString * slevelctm=[[JSONArray objectAtIndex:i] objectForKey:@"levelctm"];
                NSString * sinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
                NSString * sremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                NSString * smedia=[[JSONArray objectAtIndex:i] objectForKey:@"media"];
                NSString * ssource=[[JSONArray objectAtIndex:i] objectForKey:@"source"];
                NSString * sclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
                NSString * sattendance=[[JSONArray objectAtIndex:i] objectForKey:@"attendance"];
                NSString * sinstructorfullname=[MyClass returninstructornamewithusername:sinstructor firstorfullname:@"full"];
                NSString * ssubjectfullname=[MyClass returnsubjectnamewithsubject_shortname:ssubject centerkey:globalvariables.centerrecord.centerkey];
                NSString * siso_code=[[JSONArray objectAtIndex:i] objectForKey:@"iso_code"];
                BOOL clocked=[[[JSONArray objectAtIndex:i] objectForKey:@"locked"] isEqualToString:@"Yes"];
                
                //Add the instructor object to our instructor array
                [DTArray addObject:[[AssessmentTrialRecord alloc]initAssessmentTrialRecordWithDTkey:sdtkey type:stype leadkey:sleadkey studentkey:sstudentkey firstname:sfirstname lastname:slastname othername:sothername grade:sgrade gender:sgender dateofbirth:sdateofbirth age:sage school:sschool parentname:sparentname parentcontact:sparentcontact parentemail:sparentemail parentaddress:sparentaddress preferredlanguage:spreferredlanguage profileremarks:sprofileremarks image:simage classtype:sclasstype dtstatus:sdtstatus dtdate:sdtdate dttime:sdttime classduration:sclassduration subject:ssubject levelmain:slevelmain levelctm:slevelctm instructor:sinstructor remarks:sremarks media:smedia source:ssource classroom:sclassroom attendance:sattendance studentfullname:sstudentfullname instructorfullname:sinstructorfullname subjectfullname:ssubjectfullname iso_code:siso_code locked:clocked]];
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
        //NSDateFormatter *df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
        
        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
        JSONArray = jsonreturned[@"content"];
        
        //Set up our class array
        DTArray=[[NSMutableArray alloc] init];
        
        //loop through our jsonArray
        for (int i=0; i<JSONArray.count; i++) {
            
            NSString * sdtkey=[[JSONArray objectAtIndex:i] objectForKey:@"dtkey"];
            if ([sdtkey isEqualToString:selecteddtkey]) {
                selecteddtkeyindex=i;
            }
            
            NSString * stype=[[JSONArray objectAtIndex:i] objectForKey:@"type"];
            NSString * sleadkey=[[JSONArray objectAtIndex:i] objectForKey:@"leadkey"];
            NSString * sstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
            
            NSString * sstudentfullname;
            if ([stype isEqualToString:@"student"]) {
                sstudentfullname=[MyClass returnStudentnameWithStudentkey:sstudentkey option:@"full"];
            }else{
                sstudentfullname=[MyClass returnLeadnameWithLeadkey:sleadkey option:@"full"];
            }
            
            
            NSString * sfirstname=[[JSONArray objectAtIndex:i] objectForKey:@"firstname"];
            NSString * slastname=[[JSONArray objectAtIndex:i] objectForKey:@"lastname"];
            NSString * sothername=[[JSONArray objectAtIndex:i] objectForKey:@"othername"];
            NSString * sgrade=[[JSONArray objectAtIndex:i] objectForKey:@"grade"];
            NSString * sgender=[[JSONArray objectAtIndex:i] objectForKey:@"gender"];
            
            NSString *sdateofbirth;
            if (![[[JSONArray objectAtIndex:i] objectForKey:@"dateofbirth"] isEqualToString:@""]) {
                [df setDateFormat:@"yyyy-MM-dd"];
                NSDate *date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"dateofbirth"]];
                [df setDateFormat:@"dd-MMM-yyyy"];
                sdateofbirth = [df stringFromDate:date];
            }else{
                sdateofbirth=@"";
            }

            NSString * sage=[[JSONArray objectAtIndex:i] objectForKey:@"age"];
            NSString * sschool=[[JSONArray objectAtIndex:i] objectForKey:@"school"];
            NSString * sprofileremarks=[[JSONArray objectAtIndex:i] objectForKey:@"profileremarks"];
            NSString * sparentname=[[JSONArray objectAtIndex:i] objectForKey:@"parentname"];
            NSString * sparentcontact=[[JSONArray objectAtIndex:i] objectForKey:@"parentcontact"];
            NSString * sparentemail=[[JSONArray objectAtIndex:i] objectForKey:@"parentemail"];
            NSString * sparentaddress=[[JSONArray objectAtIndex:i] objectForKey:@"parentaddress"];
            NSString * spreferredlanguage=[[JSONArray objectAtIndex:i] objectForKey:@"preferredlanguage"];
            NSString * simage=[[JSONArray objectAtIndex:i] objectForKey:@"image"];
            NSString * sclasstype=[[JSONArray objectAtIndex:i] objectForKey:@"classtype"];
            NSString * sdtstatus=[[JSONArray objectAtIndex:i] objectForKey:@"dtstatus"];
            
            NSString *sdtdate;
            if (![[[JSONArray objectAtIndex:i] objectForKey:@"dtdate"] isEqualToString:@""]) {
                sdtdate=[[JSONArray objectAtIndex:i] objectForKey:@"dtdate"];
            }else{
                sdtdate=@"";
            }
            
            NSString * sdttime=[[JSONArray objectAtIndex:i] objectForKey:@"dttime"];
            NSString * sclassduration=[[JSONArray objectAtIndex:i] objectForKey:@"classduration"];
            NSString * ssubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
            NSString * slevelmain=[[JSONArray objectAtIndex:i] objectForKey:@"levelmain"];
            NSString * slevelctm=[[JSONArray objectAtIndex:i] objectForKey:@"levelctm"];
            NSString * sinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
            NSString * sremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
            NSString * smedia=[[JSONArray objectAtIndex:i] objectForKey:@"media"];
            NSString * ssource=[[JSONArray objectAtIndex:i] objectForKey:@"source"];
            NSString * sclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
            NSString * sattendance=[[JSONArray objectAtIndex:i] objectForKey:@"attendance"];
            NSString * sinstructorfullname=[MyClass returninstructornamewithusername:sinstructor firstorfullname:@"full"];
            NSString * ssubjectfullname=[MyClass returnsubjectnamewithsubject_shortname:ssubject centerkey:globalvariables.centerrecord.centerkey];
            NSString * siso_code=[[JSONArray objectAtIndex:i] objectForKey:@"iso_code"];
            
            //Add the instructor object to our instructor array
            [DTArray addObject:[[AssessmentTrialRecord alloc]initAssessmentTrialRecordWithDTkey:sdtkey type:stype leadkey:sleadkey studentkey:sstudentkey firstname:sfirstname lastname:slastname othername:sothername grade:sgrade gender:sgender dateofbirth:sdateofbirth age:sage school:sschool parentname:sparentname parentcontact:sparentcontact parentemail:sparentemail parentaddress:sparentaddress preferredlanguage:spreferredlanguage profileremarks:sprofileremarks image:simage classtype:sclasstype dtstatus:sdtstatus dtdate:sdtdate dttime:sdttime classduration:sclassduration subject:ssubject levelmain:slevelmain levelctm:slevelctm instructor:sinstructor remarks:sremarks media:smedia source:ssource classroom:sclassroom attendance:sattendance studentfullname:sstudentfullname instructorfullname:sinstructorfullname subjectfullname:ssubjectfullname iso_code:siso_code]];
        }
                }
                
                dispatch_semaphore_signal(semaphore);
            }] resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    
    if (result) {
        [self returnfilterdtarray];
        
        [DTTable reloadData];
        if (filteredDTArray.count>0 && selecteddtkeyindex>=0) {
            [DTTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selecteddtkeyindex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    
    return result;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==DTTable) {
        return filteredDTArray.count;
    }else if (tableView==datebartable){
        return 10000;
    }else{
        return sortingarray.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==datebartable) {
        return 100;
    }else if (tableView==DTTable){
        return UITableViewAutomaticDimension;
    }
    return 38;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==DTTable) {
        
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"dtcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        
//        static NSString *CellIdentifier = @"Cell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        DTObject=[[AssessmentTrialRecord alloc]init];
        DTObject = [filteredDTArray objectAtIndex:indexPath.row];
        
//        UILabel *ClassroomLabel;
//        //add switch, label and button
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//
//            //add textfield
//            StudentNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Student.frame.origin.x, 2, title_Student.frame.size.width-10, 20)];
//            StudentNameLabel.font=[UIFont systemFontOfSize:13];
//            StudentNameLabel.textColor=[UIColor darkGrayColor];
//            StudentNameLabel.tag=201;
//            StudentNameLabel.adjustsFontSizeToFitWidth=YES;
//            StudentNameLabel.minimumScaleFactor=0.7;
//            [cell.contentView addSubview:StudentNameLabel];
//
//            TypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Type.frame.origin.x, 2, title_Type.frame.size.width-10, 20)];
//            TypeLabel.font=[UIFont systemFontOfSize:13];
//            TypeLabel.textColor=[UIColor darkGrayColor];
//            TypeLabel.tag=213;
//            [cell.contentView addSubview:TypeLabel];
//
//
//            DTDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Date.frame.origin.x, 2, 100, 20)];
//            DTDateLabel.font=[UIFont systemFontOfSize:13];
//            DTDateLabel.textColor=[UIColor blackColor];
//            DTDateLabel.tag=203;
//            [cell.contentView addSubview:DTDateLabel];
//
//            DTTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Time.frame.origin.x, 18, 66, 20)];
//            DTTimeLabel.font=[UIFont systemFontOfSize:13];
//            DTTimeLabel.textColor=[UIColor blackColor];
//            DTTimeLabel.tag=204;
//            [cell.contentView addSubview:DTTimeLabel];
//
//            ClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Subject.frame.origin.x, 18, title_Subject.frame.size.width-10, 20)];
//            ClassLabel.font=[UIFont systemFontOfSize:13];
//            ClassLabel.adjustsFontSizeToFitWidth=YES;
//            ClassLabel.minimumScaleFactor=0.7;
//            ClassLabel.textColor=[UIColor darkGrayColor];
//            ClassLabel.tag=205;
//            [cell.contentView addSubview:ClassLabel];
//
//
//            InstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Instructor.frame.origin.x, 2, title_Instructor.frame.size.width-10, 20)];
//            InstructorLabel.font=[UIFont systemFontOfSize:13];
//            InstructorLabel.textColor=[UIColor darkGrayColor];
//            InstructorLabel.textAlignment=NSTextAlignmentLeft;
//            InstructorLabel.tag=206;
//            [cell.contentView addSubview:InstructorLabel];
//
//            ClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Instructor.frame.origin.x, 18, title_Instructor.frame.size.width-10, 20)];
//            ClassroomLabel.font=[UIFont systemFontOfSize:13];
//            ClassroomLabel.textColor=[UIColor darkGrayColor];
//            ClassroomLabel.textAlignment=NSTextAlignmentLeft;
//            ClassroomLabel.tag=216;
//            [cell.contentView addSubview:ClassroomLabel];
//
//            GradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Grade.frame.origin.x, 2, 64, 20)];
//            GradeLabel.font=[UIFont systemFontOfSize:13];
//            GradeLabel.textColor=[UIColor darkGrayColor];
//            GradeLabel.textAlignment=NSTextAlignmentLeft;
//            GradeLabel.tag=207;
//            [cell.contentView addSubview:GradeLabel];
//
//            LevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Level.frame.origin.x, 18, title_Level.frame.size.width-10, 20)];
//            LevelLabel.font=[UIFont systemFontOfSize:13];
//            LevelLabel.textColor=[UIColor darkGrayColor];
//            LevelLabel.textAlignment=NSTextAlignmentLeft;
//            LevelLabel.minimumScaleFactor=0.7;
//            LevelLabel.adjustsFontSizeToFitWidth=YES;
//            LevelLabel.tag=208;
//            [cell.contentView addSubview:LevelLabel];
//
//            ClassDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 18, 81, 20)];
//            ClassDurationLabel.font=[UIFont systemFontOfSize:11];
//            ClassDurationLabel.textColor=[UIColor darkGrayColor];
//            ClassDurationLabel.textAlignment=NSTextAlignmentLeft;
//            ClassDurationLabel.tag=209;
//            [cell.contentView addSubview:ClassDurationLabel];
//
//            RemarksLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Remarks.frame.origin.x, 0, 209, 39)];
//            RemarksLabel.font=[UIFont systemFontOfSize:13];
//            RemarksLabel.textColor=[UIColor darkGrayColor];
//            RemarksLabel.numberOfLines=0;
//            RemarksLabel.adjustsFontSizeToFitWidth = YES;
//            RemarksLabel.lineBreakMode=NSLineBreakByWordWrapping| NSLineBreakByTruncatingTail;
//            RemarksLabel.minimumScaleFactor = 0.7;
//            RemarksLabel.tag=210;
//            [cell.contentView addSubview:RemarksLabel];
//
//
//            scStatus = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Open"],[MyClass returntitlewithtitle:@"Closed"],nil]];
//            scStatus.frame = CGRectMake(title_Status.frame.origin.x, 4, 103, 29);
//            scStatus.selectedSegmentIndex = 0;
//            [scStatus addTarget:self action:@selector(changestatus:) forControlEvents: UIControlEventValueChanged];
//            scStatus.tag=211;
//            [cell.contentView addSubview:scStatus];
//
//            ClassTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Type.frame.origin.x, 18, 81, 20)];
//            ClassTypeLabel.font=[UIFont systemFontOfSize:13];
//            ClassTypeLabel.textColor=[UIColor darkGrayColor];
//            ClassTypeLabel.textAlignment=NSTextAlignmentLeft;
//            ClassTypeLabel.tag=212;
//            [cell.contentView addSubview:ClassTypeLabel];
//
//
//            AttendanceButton=[[UIButton alloc]initWithFrame:CGRectMake(title_Attendance.frame.origin.x+title_Attendance.frame.size.width-32+4, 3, 32, 32)];
//            [AttendanceButton addTarget: self action:@selector(attendancebuttontouchupinside:) forControlEvents: UIControlEventTouchUpInside];
//            [AttendanceButton addTarget: self action:@selector(attendancebuttontouchdown:) forControlEvents: UIControlEventTouchDown];
//            AttendanceButton.tag=214;
//            [cell.contentView addSubview:AttendanceButton];
//
//            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
//            singleTap.numberOfTapsRequired = 1;
//
//
//            studentimage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-2-(36*154/180), 1, 36*154/180, 36)];
//            studentimage.layer.cornerRadius=3;
//            studentimage.tag=215;
//            studentimage.layer.masksToBounds=YES;
//            studentimage.userInteractionEnabled = YES;
//            [studentimage addGestureRecognizer:singleTap];
//            [cell.contentView addSubview:studentimage];
//
//        }else{
//            StudentNameLabel=(UILabel *)[cell.contentView viewWithTag:201];
//            //GenderLabel=(UILabel *)[cell.contentView viewWithTag:202];
//            DTDateLabel=(UILabel *)[cell.contentView viewWithTag:203];
//            DTTimeLabel=(UILabel *)[cell.contentView viewWithTag:204];
//            ClassLabel=(UILabel *)[cell.contentView viewWithTag:205];
//            InstructorLabel=(UILabel *)[cell.contentView viewWithTag:206];
//            ClassroomLabel=(UILabel *)[cell.contentView viewWithTag:216];
//            GradeLabel=(UILabel *)[cell.contentView viewWithTag:207];
//            LevelLabel=(UILabel *)[cell.contentView viewWithTag:208];
//            ClassDurationLabel=(UILabel *)[cell.contentView viewWithTag:209];
//            RemarksLabel=(UILabel *)[cell.contentView viewWithTag:210];
//            scStatus=(UISegmentedControl *)[cell.contentView viewWithTag:211];
//            ClassTypeLabel=(UILabel *)[cell.contentView viewWithTag:212];
//            TypeLabel=(UILabel *)[cell.contentView viewWithTag:213];
//            AttendanceButton=(UIButton *)[cell.contentView viewWithTag:214];
//            studentimage=(UIImageView *)[cell.contentView viewWithTag:215];
//
//        }
        
        // Configure the cell...
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
        singleTap.numberOfTapsRequired = 1;
        cell.imageview2.userInteractionEnabled = YES;
        [cell.imageview2 addGestureRecognizer:singleTap];
        [MyClass downloadImageWithImageview:cell.imageview2 gender:DTObject.gender type:DTObject.type typekey:[DTObject.type isEqualToString:@"student"]?DTObject.studentkey:DTObject.leadkey image:DTObject.image async:YES];
        if ([DTObject.type isEqualToString:@"student"]) {
            Student *studentObject=[MyClass retrieveStudent:DTObject.studentkey];
            if([studentObject.due isEqualToString:@"B"]){
                [cell.imageview1 setImage:[UIImage imageNamed:@"redpurple.png"]];
            }else if([studentObject.due isEqualToString:@"C"]){
                [cell.imageview1 setImage:[UIImage imageNamed:@"red_background.png"]];
            }else if([studentObject.due isEqualToString:@"S"]){
                [cell.imageview1 setImage:[UIImage imageNamed:@"purple_background.png"]];
            }else{
                [cell.imageview1 setImage:nil];
            }
        }else{
            [cell.imageview1 setImage:nil];
        }
        
        [cell.button1 setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:@"Class" attendance:DTObject.attendance makeupattendance:nil]] forState:UIControlStateNormal];
        [cell.button1 addTarget: self action:@selector(attendancebuttontouchupinside:) forControlEvents: UIControlEventTouchUpInside];
        [cell.button1 addTarget: self action:@selector(attendancebuttontouchdown:) forControlEvents: UIControlEventTouchDown];
        cell.button1.enabled=![MyClass classLocked:DTObject.locked];
        cell.label1.text=DTObject.studentfullname;
        
        
        
        
        cell.label2.text=[MyClass returntitlewithtitle:[DTObject.type capitalizedString]];
        cell.label8.text=DTObject.classroom;
        cell.label3.text=[MyClass convertDateFormatWithDate:DTObject.DTdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
        //DTDateLabel.text=[MyClass convertDateFormatWithDate:DTObject.DTdate]];
        cell.label4.text = DTObject.DTtime;
        cell.label5.text=[MyClass returnsubjectnamewithsubject_shortname:DTObject.subject centerkey:globalvariables.centerrecord.centerkey];
        [cell.view1 setBackgroundColor:[MyClass returnSubjectColorWithCode:DTObject.subject]];
        cell.label7.text=[MyClass returninstructornamewithusername:DTObject.instructor firstorfullname:@"full"];
        [cell.view2 setBackgroundColor:[MyClass returnInstructorColorWithUsername:DTObject.instructor]];
//        ClassroomLabel.text=DTObject.classroom;
        cell.label9.text=DTObject.grade;
        //AgeLabel.text=DTObject.age;
        cell.label12.text=[NSString stringWithFormat:@"%@%@",DTObject.classduration,[MyClass returntitlewithtitle:@"mins"]];
        cell.label6.text=[MyClass returntitlewithtitle:DTObject.classtype];
        
        if ([DTObject.levelctm isEqualToString:@""]) {
            if ([DTObject.levelmain isEqualToString:@""]) {
                cell.label10.text=@"";
            }else{
                cell.label10.text=DTObject.levelmain;
            }
        }else{
            cell.label10.text=[NSString stringWithFormat:@"%@/%@",DTObject.levelmain,DTObject.levelctm];
        }
        
        
//        cell.label10.frame=CGRectMake(title_Remarks.frame.origin.x, 0, title_Remarks.frame.size.width+50, 50);
        cell.label11.text=DTObject.remarks;
//        [RemarksLabel sizeToFit];
//        CGRect myFrame=RemarksLabel.frame;
//
//        if (myFrame.size.height>27) {
//            myFrame=CGRectMake(title_Remarks.frame.origin.x, 4, myFrame.size.width, 27);
//        }else{
//            myFrame=CGRectMake(title_Remarks.frame.origin.x, 4, myFrame.size.width, myFrame.size.height);
//        }
//        RemarksLabel.frame=myFrame;
        
        
        [cell.segmentedcontrol1 addTarget:self action:@selector(changestatus:) forControlEvents: UIControlEventValueChanged];
        [cell.segmentedcontrol1 setTitle:[MyClass returntitlewithtitle:@"Open"] forSegmentAtIndex:0];
        [cell.segmentedcontrol1 setTitle:[MyClass returntitlewithtitle:@"Closed"] forSegmentAtIndex:1];
        
        if ([DTObject.DTstatus isEqualToString:@"Open"]) {
            cell.segmentedcontrol1.selectedSegmentIndex=0;
        }else{
            cell.segmentedcontrol1.selectedSegmentIndex=1;
        }
        
        
        
        //Accessory
        //cell.accessoryType = UITableViewCellAccessoryDetailButton;
        
        //alternative background color;
        if (indexPath.row % 2==0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        if([DTObject.DTkey isEqualToString:selecteddtkey]){
            cell.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:178.0/255.0 blue:103.0/255.0 alpha:1.0];
        }
        
        return cell;
        

    }else if (tableView==sortingtable){
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        UIButton *button;
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
            
            button=[[UIButton alloc]initWithFrame:CGRectMake(110, 6.5, 25, 25)];
            button.tag=202;
            [button addTarget:self action:@selector(changesortingorder:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
            
        }else{
            sortingnamelabel=(UILabel *)[cell.contentView viewWithTag:201];
            button=(UIButton *)[cell.contentView viewWithTag:202];
        }
        
        sortingnamelabel.text=[MyClass returntitlewithtitle:[self returnsortinglabelwithitem:((SortingRecord *)[sortingarray objectAtIndex:indexPath.row]).item]];
        if ([((SortingRecord *)[sortingarray objectAtIndex:indexPath.row]).order isEqualToString:@"a"]){
            [button setImage:[UIImage imageNamed:@"acending_icon.png"] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:@"decending_icon.png"] forState:UIControlStateNormal];
        }
        
        return cell;
        
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        UILabel *datebardatelabel;
        
        
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            datebardatelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
            datebardatelabel.font=[UIFont boldSystemFontOfSize:13];
            datebardatelabel.textColor=[UIColor whiteColor];
            datebardatelabel.adjustsFontSizeToFitWidth=YES;
            datebardatelabel.tag=301;
            datebardatelabel.transform = CGAffineTransformMakeRotation(M_PI_2);
            datebardatelabel.textAlignment=NSTextAlignmentCenter;
            datebardatelabel.center=CGPointMake(20, 50);
            [cell.contentView addSubview:datebardatelabel];

            
        }else{
            datebardatelabel=(UILabel *)[cell.contentView viewWithTag:301];
        }
        
        // Configure the cell...
        datebardatelabel.text=[MyClass returndateformatMMMYYYYwithMMMMYYYYMMMMdate:[MyClass returnMonthFromBaseDateWithOffset:indexPath.row]];
        datebardatelabel.highlightedTextColor=[UIColor darkGrayColor];
        cell.backgroundColor=[UIColor lightGrayColor];
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==DTTable) {
        //popup DT details view record
        
        [self startsidewindowanimationwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            DTObject=[filteredDTArray objectAtIndex:indexPath.row];
            DTAddEditViewController *dteditpopover = (DTAddEditViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"DTAddEditViewController"];
            dteditpopover.delegate=self;
            dteditpopover.ViewATObject=DTObject;
            dteditpopover.DTTableMode=@"View";
            dteditpopover.PopoverMode=@"PopoverDTFromDTView";
            
            dteditpopover.view.frame=self->sidewindowview.bounds;
            [self->sidewindowview addSubview:dteditpopover.view];
            [self addChildViewController:dteditpopover];
            [dteditpopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
        });
    }else{

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self retrieveDTRecordWithDTstatus:[statusarray objectAtIndex:[scStatusBar selectedSegmentIndex]] month:[MyClass returnMonthFromBaseDateWithOffset:indexPath.row] type:[typearray objectAtIndex:[sctype selectedSegmentIndex]]]) {
                
                selectedmonth=[MyClass returnMonthFromBaseDateWithOffset:indexPath.row];
                [allbutton setBackgroundColor:[UIColor lightGrayColor]];
            }
        });
    }

    
}

-(void)tapImageDetected:(UITapGestureRecognizer *)gr{
    
    UIImageView *theTappedImageView=(UIImageView *)gr.view;
    
    CGPoint point = [theTappedImageView.superview convertPoint:CGPointZero toView:DTTable];
    NSIndexPath *indexpath =[DTTable indexPathForRowAtPoint:point];
    
    DTObject=[filteredDTArray objectAtIndex:indexpath.row];
    //ClassScheduleObject=[ClassScheduleRecordArray objectAtIndex:indexpath.row];
    

    
    if ([DTObject.type isEqualToString:@"student"]) {
        //popup student details view record
        
        if(![MyClass showMenuItemwithObject:@"Student Profile"]){
            return;
        }
        
        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
            
            //studentpopover.delegate=self;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:DTObject.studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];

            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedClasskey=nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedDTkey=DTObject.DTkey;
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(self.view.frame.size.width-240, self.view.frame.size.height);
            
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).TypeSelectionButton.hidden=NO;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).typeselectionarrow.hidden=NO;
            //((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scdayoption.frame=CGRectMake(203, 2, 279, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501, 2, 129, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.hidden=NO;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.hidden=YES;
            [((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]) drawpointerwithoption:@"closed" imageview:((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).dayselectionarrow];
            
            studentdetailsnavcontroller.view.frame=sidewindowview.bounds;
            [self->sidewindowview addSubview:studentdetailsnavcontroller.view];
            [self addChildViewController:studentdetailsnavcontroller];
            [studentdetailsnavcontroller didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
        });

    }else{
        
        if(![MyClass showMenuItemwithObject:@"Lead Profile"]){
            return;
        }
        
        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LeadDetailsNavController *leaddetailsnavcontroller = (LeadDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"LeadDetailsNavController"];
            ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).leadAction=@"PopoverLead";
            ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).DetailsViewLead=[[Lead alloc]init];
            ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).DetailsViewLead.leadkey=DTObject.leadkey;
            ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).selectedDTkey=DTObject.DTkey;
            ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).delegate=self;
            
            
            
            if (![(LeadDetailsViewController *)[leaddetailsnavcontroller topViewController] retrieveLead:DTObject.leadkey]) {
                return;
            }
            
            leaddetailsnavcontroller.view.frame=sidewindowview.bounds;
            [self->sidewindowview addSubview:leaddetailsnavcontroller.view];
            [self addChildViewController:leaddetailsnavcontroller];
            [leaddetailsnavcontroller didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
        });
        

    }
}




- (IBAction)selecttype:(UISegmentedControl *)sender {
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([self retrieveDTRecordWithDTstatus:[statusarray objectAtIndex:[scStatusBar selectedSegmentIndex]] month:@"All" type:[typearray objectAtIndex:[sctype selectedSegmentIndex]]]){
        }else{
            sender.selectedSegmentIndex=1;
        }
    });
}

- (void)selectstatus:(UISegmentedControl *)sender {
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self retrieveDTRecordWithDTstatus:[statusarray objectAtIndex:[scStatusBar selectedSegmentIndex]] month:selectedmonth type:[typearray objectAtIndex:[sctype selectedSegmentIndex]]]) {
            laststatusindex=sender.selectedSegmentIndex;
        }else{
            sender.selectedSegmentIndex=laststatusindex;
        }
    });
}

- (IBAction)addDTRecord:(UIButton *)sender {
    
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DTAddEditViewController *DTPopover = (DTAddEditViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"DTAddEditViewController"];
        DTPopover.delegate=self;
        //DTPopover.PopoverEnrollment=DetailsViewEnrollment;
        DTPopover.DTTableMode=@"Add";
        DTPopover.PopoverMode=@"PopoverDTFromDTView";
        
        DTPopover.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:DTPopover.view];
        [self addChildViewController:DTPopover];
        [DTPopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });

}

- (NSString *) findcurrentschoolmonth
{
    return [MyClass returnMonthFromBaseDateWithOffset:[MyClass returnMonthOffsetWithDate:[NSDate date]]];
}

- (void)doubleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    selectedmonth=[self findcurrentschoolmonth];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self retrieveDTRecordWithDTstatus:[statusarray objectAtIndex:[scStatusBar selectedSegmentIndex]] month:[self findcurrentschoolmonth] type:[typearray objectAtIndex:[sctype selectedSegmentIndex]]]) {
            selectedmonth=[self findcurrentschoolmonth];
            
            [datebartable selectRowAtIndexPath:[NSIndexPath indexPathForRow:[MyClass returnMonthOffsetWithDate:[MyClass convertToNSDateWithDate:selectedmonth DateFormat:@"MMM yyyy"]] inSection:0]  animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    });
}


-(void) showallmonth:(UIButton *)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self retrieveDTRecordWithDTstatus:[statusarray objectAtIndex:[scStatusBar selectedSegmentIndex]] month:@"All" type:[typearray objectAtIndex:[sctype selectedSegmentIndex]]]) {
            [datebartable deselectRowAtIndexPath:[datebartable indexPathForSelectedRow] animated:YES];
            [allbutton setBackgroundColor:[UIColor grayColor]];
            selectedmonth=@"All";
        }
    });
}



-(void)changestatus:(UISegmentedControl *)sender{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:DTTable];
        NSIndexPath *indexPath =[DTTable indexPathForRowAtPoint:point];
        
        //update dt information
        DTObject=[[AssessmentTrialRecord alloc]init];
        DTObject =[filteredDTArray objectAtIndex:indexPath.row];
        NSString *strURL;
        
        
        strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatedt&dtkey=%@&status=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DTObject.DTkey,sender.selectedSegmentIndex==0?@"Open":@"Closed"];
        
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
                result = TRUE;
            }
            dispatch_semaphore_signal(semaphore);
        }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        if (result) {
            [self retrieveDTRecordWithDTstatus:[statusarray objectAtIndex:[scStatusBar selectedSegmentIndex]] month:selectedmonth type:[typearray objectAtIndex:[sctype selectedSegmentIndex]]];
        }else{
            sender.selectedSegmentIndex=sender.selectedSegmentIndex==0?1:0;
            //[MyClass showconnectionlostdialogbox];
        }
    });
}

-(void) dismissDTAddEditpopoverwithdttype:(NSString *)type
{
    [MyClass getLatestDataSetv2withParameters:@"lead,student" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    [self retrieveDTRecordWithDTstatus:@"Open" month:@"All" type:[typearray objectAtIndex:[sctype selectedSegmentIndex]]];
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self closesidewindow];
}


-(void) dismissDTAddEditpopoverduetoconnectionerror
{
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self closesidewindow];
}


-(void) enrollATLeadStudent:(AssessmentTrialRecord *)ATRecord
{

    
    [self closesidewindow];
    
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    mainVC.leftMenu.prepareforsegue=TRUE;
    mainVC.leftMenu.sourceview=@"assessment";
    mainVC.leftMenu.studentinformationaction=@"EnrollATLeadStudent";
    mainVC.leftMenu.studentinformationatobject=ATRecord;
    globalvariables.leftmenuindex=@"1";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];


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

- (IBAction)menubutton:(id)sender {
    [self.mainSlideMenu openLeftMenu];
}

-(void) dismissDTAddEditpopoverwithrefresh:(BOOL)refresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyClass getLatestDataSetv2withParameters:@"student,lead" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
        [self retrieveDTRecordWithDTstatus:[statusarray objectAtIndex:[scStatusBar selectedSegmentIndex]] month:selectedmonth type:[typearray objectAtIndex:[sctype selectedSegmentIndex]]];
    });
    [self closesidewindow];
}

-(void) createView
{
//    tableview=[[UIView alloc]initWithFrame:CGRectMake(0, 144, self.view.frame.size.width, self.view.frame.size.height-144)];
//    //tableview.backgroundColor=[UIColor blackColor];
//    [self.view addSubview:tableview];
    
    datebartable=[[UITableView alloc]initWithFrame:CGRectMake(101, 69, self.view.bounds.size.width-101, 40) style:UITableViewStylePlain];
    datebartable.delegate=self;
    datebartable.dataSource=self;
    datebartable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [datebartable setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:datebartable];
    
    CGPoint oldCenter=datebartable.center;
    datebartable.frame=CGRectMake(69, 101, datebartable.bounds.size.height, datebartable.bounds.size.width);
    datebartable.transform=CGAffineTransformMakeRotation(-M_PI_2);
    datebartable.center=oldCenter;
    
    UITapGestureRecognizer *doubleTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureCaptured:)];
    doubleTap.delaysTouchesBegan=YES;
    doubleTap.numberOfTapsRequired=2;
    [datebartable addGestureRecognizer:doubleTap];
    
    
    selectedmonth=@"All";
    
    allbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 69, 100, 40)];
    allbutton.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    [allbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [allbutton setBackgroundColor:[UIColor grayColor]];
    [allbutton setTitle:[MyClass returntitlewithtitle:@"All"] forState:UIControlStateNormal];
    [allbutton addTarget:self action:@selector(showallmonth:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allbutton];
    
    //scStatusBar = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"All"],[MyClass returntitlewithtitle:@"Open"],[MyClass returntitlewithtitle:@"Closed"],nil]];
    [scStatusBar setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [scStatusBar setTitle:[MyClass returntitlewithtitle:@"Open"] forSegmentAtIndex:1];
    [scStatusBar setTitle:[MyClass returntitlewithtitle:@"Closed"] forSegmentAtIndex:2];
    //scStatusBar.frame = CGRectMake(self.view.frame.size.width-275, 112, 270, 29);
    [scStatusBar addTarget:self action:@selector(selectstatus:) forControlEvents: UIControlEventValueChanged];
    scStatusBar.selectedSegmentIndex=0;
    laststatusindex=0;
    
    //[self.view addSubview:scStatusBar];
    
    
    reloadbutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-45, 34, 28,28)];
    [reloadbutton setImage:[UIImage imageNamed:@"reload_white.png"] forState:UIControlStateNormal];
    [reloadbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reloadbutton addTarget: self action:@selector(viewDidAppear:) forControlEvents: UIControlEventTouchUpInside];
    reloadbutton.hidden=YES;
    [self.view addSubview:reloadbutton];
    
//    DTTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 88, self.view.bounds.size.width, tableview.frame.size.height-88) style:UITableViewStyleGrouped];
//    DTTable.delegate=self;
//    DTTable.dataSource=self;
    DTTable.sectionHeaderHeight=0;
//    [tableview addSubview:DTTable];
    
    if ([DTTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        DTTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
//    dtsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, DTTable.frame.origin.y-50, DTTable.frame.size.width-50, 50)];
//    dtsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
//    dtsearchbar.delegate=self;
//    dtsearchbar.searchBarStyle=UISearchBarStyleMinimal;
//    [tableview addSubview:dtsearchbar];
    
//    sortingorderbutton=[[UIButton alloc]initWithFrame:CGRectMake(dtsearchbar.frame.origin.x+dtsearchbar.frame.size.width, dtsearchbar.frame.origin.y, 50, 50)];
    //sortingorderbutton.backgroundColor=[UIColor darkGrayColor];
//    [sortingorderbutton setImage:[UIImage imageNamed:@"sorting_icon_gray.png"] forState:UIControlStateNormal];
    [sortingorderbutton addTarget:self action:@selector(sortingbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
//    [sortingorderbutton setImageEdgeInsets:UIEdgeInsetsMake(8, 4, 8, 12)];
//    [tableview addSubview:sortingorderbutton];
    
    
    UIPanGestureRecognizer *panGesture;
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.delegate = self;
    [DTTable addGestureRecognizer:panGesture];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshdttable) forControlEvents:UIControlEventValueChanged];
    [DTTable addSubview:tablerefresh];
    
    
//    title_Date=[[UILabel alloc]init];
//    title_Date.font=[UIFont boldSystemFontOfSize:13];
//    title_Date.textColor=[UIColor darkGrayColor];
//    [tableview addSubview:title_Date];
//
//    title_Time=[[UILabel alloc]init];
//    title_Time.font=[UIFont boldSystemFontOfSize:13];
//    title_Time.textColor=[UIColor darkGrayColor];
//    [tableview addSubview:title_Time];
//
//    title_Type=[[UILabel alloc]init];
//    title_Type.font=[UIFont boldSystemFontOfSize:13];
//    title_Type.textColor=[UIColor darkGrayColor];
//    [tableview addSubview:title_Type];
//
//    title_Student=[[UILabel alloc]init];
//    title_Student.font=[UIFont boldSystemFontOfSize:13];
//    title_Student.textColor=[UIColor darkGrayColor];
//    [tableview addSubview:title_Student];
//
//    title_Subject=[[UILabel alloc]init];
//    title_Subject.font=[UIFont boldSystemFontOfSize:13];
//    title_Subject.textColor=[UIColor darkGrayColor];
//    [tableview addSubview:title_Subject];
//
//    title_Instructor=[[UILabel alloc]init];
//    title_Instructor.font=[UIFont boldSystemFontOfSize:13];
//    title_Instructor.textColor=[UIColor darkGrayColor];
//    [tableview addSubview:title_Instructor];
//
//    title_Classroom=[[UILabel alloc]init];
//    title_Classroom.font=[UIFont boldSystemFontOfSize:13];
//    title_Classroom.textColor=[UIColor darkGrayColor];
//    [tableview addSubview:title_Classroom];
//
//    title_Duration=[[UILabel alloc]init];
//    title_Duration.font=[UIFont boldSystemFontOfSize:13];
//    title_Duration.textColor=[UIColor darkGrayColor];
    //[tableview addSubview:title_Duration];
    
//    title_Grade=[[UILabel alloc]init];
//    title_Grade.font=[UIFont boldSystemFontOfSize:13];
//    title_Grade.textColor=[UIColor darkGrayColor];
//    [tableview addSubview:title_Grade];
//    
//    title_Level=[[UILabel alloc]init];
//    title_Level.font=[UIFont boldSystemFontOfSize:13];
//    title_Level.textColor=[UIColor darkGrayColor];
//    [tableview addSubview:title_Level];
//    
//    title_Remarks=[[UILabel alloc]init];
//    title_Remarks.font=[UIFont boldSystemFontOfSize:13];
//    title_Remarks.textColor=[UIColor darkGrayColor];
//    [tableview addSubview:title_Remarks];
//    
//    title_Attendance=[[UILabel alloc]init];
//    title_Attendance.font=[UIFont boldSystemFontOfSize:13];
//    title_Attendance.textColor=[UIColor darkGrayColor];
//    title_Attendance.textAlignment=NSTextAlignmentRight;
//    [tableview addSubview:title_Attendance];
//    
//    title_Status=[[UILabel alloc]init];
//    title_Status.font=[UIFont boldSystemFontOfSize:13];
//    title_Status.textColor=[UIColor darkGrayColor];
//    [tableview addSubview:title_Status];

}

-(void) loadtitle
{
//    NSArray *separatorweight_class=[[NSArray alloc]initWithObjects:@"7",@"5",@"14",@"7",@"4",@"12",@"6",@"6",nil];
//    float fieldseparator=(tableview.frame.size.width-50-6-30)/[[separatorweight_class valueForKeyPath:@"@sum.self"] floatValue];
//
//
//    title_Date.frame=CGRectMake(6, 0, [[separatorweight_class objectAtIndex:0] intValue]*fieldseparator, 21);
//    title_Time.frame=CGRectMake(6, 16, [[separatorweight_class objectAtIndex:0] intValue]*fieldseparator, 21);
//    title_Type.frame=CGRectMake(title_Time.frame.origin.x+title_Time.frame.size.width, 0, [[separatorweight_class objectAtIndex:1] intValue]*fieldseparator, 21);
//    title_Student.frame=CGRectMake(title_Type.frame.origin.x+title_Type.frame.size.width, 0, [[separatorweight_class objectAtIndex:2] intValue]*fieldseparator, 21);
//    title_Subject.frame=CGRectMake(title_Type.frame.origin.x+title_Type.frame.size.width, 16, [[separatorweight_class objectAtIndex:2] intValue]*fieldseparator, 21);
//    title_Instructor.frame=CGRectMake(title_Subject.frame.origin.x+title_Subject.frame.size.width, 0, [[separatorweight_class objectAtIndex:3] intValue]*fieldseparator, 21);
//    title_Classroom.frame=CGRectMake(title_Subject.frame.origin.x+title_Subject.frame.size.width, 16, [[separatorweight_class objectAtIndex:3] intValue]*fieldseparator, 21);
//    title_Grade.frame=CGRectMake(title_Instructor.frame.origin.x+title_Instructor.frame.size.width, 0, [[separatorweight_class objectAtIndex:4] intValue]*fieldseparator, 21);
//    title_Level.frame=CGRectMake(title_Instructor.frame.origin.x+title_Instructor.frame.size.width, 16, [[separatorweight_class objectAtIndex:4] intValue]*fieldseparator, 21);
//    title_Remarks.frame=CGRectMake(title_Level.frame.origin.x+title_Level.frame.size.width, 0, [[separatorweight_class objectAtIndex:5] intValue]*fieldseparator, 21);
//    title_Attendance.frame=CGRectMake(title_Remarks.frame.origin.x+title_Remarks.frame.size.width, 0, [[separatorweight_class objectAtIndex:6] intValue]*fieldseparator, 21);
//    title_Status.frame=CGRectMake(title_Attendance.frame.origin.x+title_Attendance.frame.size.width+30, 0, [[separatorweight_class objectAtIndex:7] intValue]*fieldseparator, 21);
//
    //title_Duration.frame=CGRectMake(50, 16, 40, 21);
    
    
    viewtitle.text=[MyClass returntitlewithtitle:@"Assessment and Trial"];
    title_Student.text=[MyClass returntitlewithtitle:@"Name"];
    title_Type.text=[MyClass returntitlewithtitle:@"Type"];
    title_Subject.text=[MyClass returntitlewithtitle:@"Subject"];
    title_Date.text=[MyClass returntitlewithtitle:@"Date"];
    title_Time.text=[MyClass returntitlewithtitle:@"Time"];
    //title_Duration.text=[MyClass returntitlewithtitle:@"Duration"];
    title_Instructor.text=[MyClass returntitlewithtitle:@"Instructor"];
    title_Classroom.text=[MyClass returntitlewithtitle:@"Classroom"];
    title_Grade.text=[MyClass returntitlewithtitle:@"Grade"];
    title_Level.text=[MyClass returntitlewithtitle:@"Level"];
    title_Remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    title_Status.text=[MyClass returntitlewithtitle:@"Status"];
    title_Attendance.text=[MyClass returntitlewithtitle:@"Attendance"];
    [sctype setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [sctype setTitle:[MyClass returntitlewithtitle:@"Student"] forSegmentAtIndex:1];
    [sctype setTitle:[MyClass returntitlewithtitle:@"Lead"] forSegmentAtIndex:2];
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
        
        [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,staff,product,classroom,marketing,centersettings,userroleandprivilege" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
        [MyClass LoadSchoolCalendarArray];
        [self refreshlanguage];
        [MyClass updatecenterkey];
        InstructorArray=[MyClass retrieveInstructorListwithvalid:@"All" flushcachedata:NO];
        [self viewDidAppear:YES];
        
        
    });
}*/

-(void) reloadPageWithFirstLoad:(BOOL)firstload
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    [datebartable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[MyClass returnMonthOffsetWithDate:[NSDate date]] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,staff,classroom,centersettings,userroleandprivilege,student,lead,arcode" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
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
                
                InstructorArray=[MyClass retrieveInstructorListwithvalid:@"All" flushcachedata:NO];
                
                //add buttonarray
                makeupdtattendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnmakeupattendancebuttonarray]];
                
                scStatusBar.selectedSegmentIndex=1;

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (![self retrieveDTRecordWithDTstatus:@"Open" month:@"All" type:[typearray objectAtIndex:[sctype selectedSegmentIndex]]]) {
                        reloadbutton.hidden=NO;
                        addDTbutton.hidden=YES;
                        return;
                    }else{
                        reloadbutton.hidden=YES;
                        addDTbutton.hidden=NO;
                    }
                    
                    
                    
                });
            }
                });
            
        }];
    });
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
    
    [MyClass updatelocaldbwithparameter:@"dtviewlistsortingorder" value:sortingstring];
    
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
    
    
    [self sortdtrecordlist];
    
    
    [sortingtable reloadData];
    
    
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==DTTable) {
        [self.view endEditing:YES];
    }
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
        
        [self sortdtrecordlist];
    }
}

-(void) sortingbuttonpressed:(UIButton *)sender
{
    
    [self returnsortingarraywithtype:@"dtviewlistsortingorder"];
    
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

-(NSString *) returnsortinglabelwithitem:(NSString *)item
{
    if ([item isEqualToString:@"DTdate"]) {
        return @"Date";
    }else if ([item isEqualToString:@"DTtime"]) {
        return @"Time";
    }else if ([item isEqualToString:@"studentfullname"]) {
        return @"Student Name";
    }else if ([item isEqualToString:@"instructorfullname"]) {
        return @"Instructor";
    }else if ([item isEqualToString:@"subjectfullname"]) {
        return @"Subject";
    }
    return item;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==dtsearchbar) {
        [self returnfilterdtarray];
        //[subjecttable reloadData];
        [DTTable setContentOffset:CGPointZero animated:YES];
    }
}

-(void) returnfilterdtarray
{
    //NSMutableArray *result;
    
    if ([dtsearchbar.text isEqualToString:@""]) {
        filteredDTArray= [[NSMutableArray alloc]initWithArray:DTArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.studentfullname contains[c] %@ or self.instructorfullname contains[c] %@ or self.remarks contains[c] %@ or self.subject contains[c] %@ or self.parentcontact contains[c] %@ or self.subjectfullname contains[c] %@",dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text];
        filteredDTArray= [[NSMutableArray alloc]initWithArray:[DTArray filteredArrayUsingPredicate:predicate]];
    }
    [self sortdtrecordlist];
    
}


-(void) sortdtrecordlist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarraywithtype:@"dtviewlistsortingorder"];
    
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    
    
    filteredDTArray=[NSMutableArray arrayWithArray:[filteredDTArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    
    [DTTable reloadData];
    
}

-(void) returnsortingarraywithtype:(NSString *)type
{
    sortingarray=[MyClass returnsortingarraywithtype:type];
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
    [DTTable deselectRowAtIndexPath:[DTTable indexPathForSelectedRow] animated:YES];
    
    
}

-(void) startsidewindowanimationwithwidth:(float)width
{
    ailoadindicator.hidden=NO;
    ailoadindicator.center = CGPointMake(width/2-7.5,mainWindow.frame.size.height/2-7.5);
    [ailoadindicator startAnimating];
    [self adjustpresentingviewwidthwithwidth:width];
}

-(void) closeleadprofile
{
    [self closesidewindow];
}

-(void) updateCategoryCount
{
    //not used
}

-(void) gobackLeadCategory
{
    //not used
}

-(void) enableAddLeadButton
{
    //not used
}

-(void) refreshstudentdetailviewpresentingviewcontent
{
    [self retrieveDTRecordWithDTstatus:[statusarray objectAtIndex:[scStatusBar selectedSegmentIndex]] month:selectedmonth type:[typearray objectAtIndex:[sctype selectedSegmentIndex]]];
}

-(void) refreshleaddetailviewpresentingviewcontent
{
    [self retrieveDTRecordWithDTstatus:[statusarray objectAtIndex:[scStatusBar selectedSegmentIndex]] month:selectedmonth type:[typearray objectAtIndex:[sctype selectedSegmentIndex]]];
}

-(void) updateleadinformationlist:(NSString *)leadkey
{
    //not used
}

-(void) gotoleadprofile:(NSString *)leadkey
{
    //not used
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
