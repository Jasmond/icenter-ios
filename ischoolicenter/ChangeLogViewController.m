//
//  ChangeLogViewController.m
//  iCenter
//
//  Created by Jasmond Luk on 27/5/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import "ChangeLogViewController.h"
#import "MyTableViewCell.h"
#import "MainMenuViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MainViewController.h"

@interface ChangeLogViewController ()
{
    NSMutableDictionary *edgeConstants;
}
@end

#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]

@implementation ChangeLogViewController
#define maxrange 13 //max - 1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//    UILabel *headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 68)];
//    headerLabel.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];
//    [self.view addSubview:headerLabel];
    
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
    
    logTable.sectionHeaderHeight=0;
    actionSC.tintColor=[UIColor whiteColor];
    [actionSC setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    [actionSC setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
//    dateRangeSelected=@"All Dates";
    typeSelected=@"All Types";
    
    actionArray=[[NSMutableArray alloc]initWithObjects:@"All",@"Insert",@"Update",@"Delete", nil];
//    dateRangeArray=[[NSMutableArray alloc]initWithObjects:@"All Dates",@"Today",@"Yesterday",@"Last 7 days",@"Last 30 days", nil];
    fromDate=[MyClass addDaysWithDate:[NSDate date] days:-2];
    toDate=[NSDate date];
    
    [self updateButtonTitle];
    
    runviewdidappear=TRUE;
    [self refreshlanguage];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor systemGroupedBackgroundColor];
    [tablerefresh addTarget:self action:@selector(getActivityLog) forControlEvents:UIControlEventValueChanged];
    [logTable addSubview:tablerefresh];
    
    //add side calendar
    calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 0, 320, self.view.bounds.size.height) Theme:2 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:YES showclassdot:NO schedulerecord:nil  UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
    calendarview.delegate=self;
    [masterview addSubview:calendarview];
    

    [masterviewbutton addTarget:self action:@selector(closecalendar) forControlEvents:UIControlEventTouchUpInside];
    masterviewbutton.hidden=YES;
}

-(void) doneswitchcenterwithreload:(BOOL)reload centerkey:(NSString *)centerkey centerimage:(UIImage *)centerimage
{
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

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.mainSlideMenu disableSlidePanGestureForRightMenu];
    if (runviewdidappear) {
        globalvariables.lastviewcontroller=(NSString *)self;
        [self reloadPageWithFirstLoad:YES];
    }else{
        runviewdidappear=TRUE;
    }
}

-(void) updateButtonTitle
{
//    [dateRangeButton setTitle:[MyClass returntitlewithtitle:dateRangeSelected] forState:UIControlStateNormal];
    [typeButton setTitle:[MyClass returntitlewithtitle:typeSelected] forState:UIControlStateNormal];
    [fromButton setTitle:[MyClass convertToNSStringWithNSDate:fromDate ToDateFormat:@"dd-MMM-yyyy" Translate:YES] forState:UIControlStateNormal];
    [toButton setTitle:[MyClass convertToNSStringWithNSDate:toDate ToDateFormat:@"dd-MMM-yyyy" Translate:YES] forState:UIControlStateNormal];
}

-(void) checktoreloadapp
{
    
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {
        /*if ([mypopovercontroller presentingViewController].isBeingPresented) {
            [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else */if (self.presentedViewController==switchcenterviewcontroller) {
            [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }/*else if (self.presentedViewController==fullscreenphotoviewcontroller) {
            [fullscreenphotoviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }*/else{
            [self.mainSlideMenu closeLeftMenu];
        }
        globalvariables.appbecomeactiveaction=@"";
        globalvariables.leftmenuindex=@"0";
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [MyClass reloadApp];
    }else if ([globalvariables.appbecomeactiveaction isEqualToString:@"refresh"]){
        
        globalvariables.appbecomeactiveaction=@"";
        /*if ([mypopovercontroller presentingViewController].isBeingPresented) {
            [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else */if (self.presentedViewController==switchcenterviewcontroller) {
            [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.mainSlideMenu closeLeftMenu];
        }

        [self reloadPageWithFirstLoad:NO];

    }
}

-(void) refreshlanguage
{
    headercentername.text=[MyClass returnWindowTitle];
    headertitlename.text=[MyClass returntitlewithtitle:@"Change Log"];
    for (int i=0; i<actionArray.count; i++) {
        [actionSC setTitle:[MyClass returntitlewithtitle:[actionArray objectAtIndex:i]] forSegmentAtIndex:i];
    }
    searchBar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    dateHeading.text=[MyClass returntitlewithtitle:@"Date"];
    ChangedByHeading.text=[MyClass returntitlewithtitle:@"Changed by"];
    studentHeading.text=[MyClass returntitlewithtitle:@"Student"];
    typeHeading.text=[MyClass returntitlewithtitle:@"Type"];
    ChangeDetailsHeading.text=[MyClass returntitlewithtitle:@"Change details"];
    UserActivityHeading.text=[MyClass returntitlewithtitle:@"User activity"];
    [self updateheadercentertitle];
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

-(void) reloadPageWithFirstLoad:(BOOL)firstload
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyClass getLatestDataSetv2withParameters:@"languagetitle,staff,student,arcode" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
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
                    [MyClass updatecenterkey];

                    [self refreshlanguage];
                    [self getActivityLog];
                    [logTable setContentOffset:CGPointZero animated:YES];
                }
            });
        }];
    });
}



-(void) getActivityLog
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getchangelog&language=%@&fromdate=%@&todate=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,globalvariables.language,[MyClass convertToNSStringWithNSDate:fromDate DateFormat:@"yyyy-MM-dd"],[MyClass convertToNSStringWithNSDate:toDate DateFormat:@"yyyy-MM-dd"]];
    
    __block BOOL result=FALSE;
    __block NSMutableArray *JSONArray;

    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        }
    }];
    
    if(result){
        activityLogArray=[[NSMutableArray alloc]init];
        typeArray=[[NSMutableArray alloc]initWithObjects:@"All Types", nil];
        for (int i=0; i<JSONArray.count; i++) {
            NSString * date=[[JSONArray objectAtIndex:i] objectForKey:@"date"];
            NSString * username=[[JSONArray objectAtIndex:i] objectForKey:@"username"];
            NSString * studentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
            NSString * type=[[JSONArray objectAtIndex:i] objectForKey:@"type"];
            NSString * action=[[JSONArray objectAtIndex:i] objectForKey:@"action"];
            NSString * change=[[JSONArray objectAtIndex:i] objectForKey:@"change"];
            NSString * subject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
            NSString * product=[[JSONArray objectAtIndex:i] objectForKey:@"product"];
            NSString * enrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
            NSString * saleskey=[[JSONArray objectAtIndex:i] objectForKey:@"saleskey"];
            NSString * classkey=[[JSONArray objectAtIndex:i] objectForKey:@"classkey"];
            NSString * subtype=[[JSONArray objectAtIndex:i] objectForKey:@"subtype"];
            NSString * subtypekey=[[JSONArray objectAtIndex:i] objectForKey:@"subtypekey"];
            NSString * useractivity=[[JSONArray objectAtIndex:i] objectForKey:@"useractivity"];
            NSString * apiaction=[[JSONArray objectAtIndex:i] objectForKey:@"apiaction"];
            
            if(![typeArray containsObject:type]){
                [typeArray addObject:type];
            }
            
            [activityLogArray addObject:[[ChangeLogRecord alloc]initChangeLogRecordWithDate:date username:username studentkey:studentkey type:type action:action change:change subject:subject product:product enrollmentkey:enrollmentkey saleskey:saleskey classkey:classkey subtype:subtype subtypekey:subtypekey useractivity:useractivity apiaction:apiaction]];
        }
//        [self updateTypePUButton];
        [self returnFilteredArray];
    }
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    for (id object in [logTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}


-(void) returnFilteredArray
{

    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (actionSC.selectedSegmentIndex!=0) {
        newCondition = [NSPredicate predicateWithFormat:@"self.action = %@", [actionArray objectAtIndex:actionSC.selectedSegmentIndex]];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (![typeSelected isEqualToString:@"All Types"]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.type = %@", typeSelected];
        [nsPredicatearray addObject:newCondition];
    }
    
    
    if ([searchBar.text isEqualToString:@""]) {
        filteredActivityLogArray= [[NSMutableArray alloc]initWithArray:activityLogArray];
    }else{
        newCondition = [NSPredicate predicateWithBlock:^BOOL(ChangeLogRecord *object, NSDictionary *bindings) {
            NSString *changedbyfullname=[self returnchangedbynamewithusername:object.username studentkey:object.studentkey];
            NSString *studentfullname=[MyClass returnStudentnameWithStudentkey:object.studentkey option:@"full"];
            NSString *studentid=((Student *)[MyClass returnstudentwithstudentkey:object.studentkey]).studentid;
            return [changedbyfullname rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.studentkey rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.apiaction rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.change rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.action rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.product rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.subject rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.username rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.date rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [studentfullname rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [studentid rangeOfString:searchBar.text options:NSCaseInsensitiveSearch].location!=NSNotFound;
        }];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredActivityLogArray= [[NSMutableArray alloc]initWithArray:[activityLogArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredActivityLogArray= [[NSMutableArray alloc]initWithArray:activityLogArray];
    }
    
    [logTable reloadData];
    
}

-(NSString *) returnchangedbynamewithusername:(NSString *)username studentkey:(NSString *)studentkey
{
    NSRange range=[username rangeOfString:@"@"];
    if([username isEqualToString:@"system"]){
        return [MyClass returntitlewithtitle:@"System"];
    }else if(range.location==NSNotFound){
        //parent
        return [MyClass returnContactRelationshipWithStudentkey:studentkey Contact:username];
    }else{
        //staff
        return [MyClass returnstaffnamewithusername:username firstorfullname:@"full"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return filteredActivityLogArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cellView;

    static NSString *CellIdentifier = @"logCell";
    cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cellView == nil) {
        cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ChangeLogRecord *obj = [filteredActivityLogArray objectAtIndex:indexPath.row];
    
    cellView.label1.text = [obj.date substringToIndex:10];
    cellView.label2.text=[obj.date substringFromIndex:11];
    
    NSRange range=[obj.username rangeOfString:@"@"];
    if([obj.username isEqualToString:@"system"]){
        cellView.label3.text = [MyClass returntitlewithtitle:@"System"];
        [MyClass downloadImageWithImageview:cellView.imageview1 gender:nil type:@"staff" typekey:obj.username image:@"Yes" async:YES];
        cellView.label4.hidden=YES;
    }else if([obj.apiaction isEqualToString:@"createenrollmentstudent"]){
        //parent
        cellView.label3.text = obj.enrollmentkey;
        
        cellView.label4.hidden=YES;
        
        [MyClass downloadImageWithImageview:cellView.imageview1 gender:nil type:@"student" typekey:obj.studentkey image:@"Yes" async:YES];
//        cellView.label4.text = [self returnchangedbynamewithusername:obj.username studentkey:obj.studentkey];
    }else if(range.location==NSNotFound){
        //parent
        cellView.label3.text = [MyClass returnStudentnameWithStudentkey:obj.studentkey option:@"fullbutid"];
        
        cellView.label4.hidden=NO;
        
        [MyClass downloadImageWithImageview:cellView.imageview1 gender:nil type:@"student" typekey:obj.studentkey image:@"Yes" async:YES];
        cellView.label4.text = [self returnchangedbynamewithusername:obj.username studentkey:obj.studentkey];
    }else{
        //staff
        cellView.label3.text = [self returnchangedbynamewithusername:obj.username studentkey:obj.studentkey];
        cellView.label4.text=obj.username;
        [MyClass downloadImageWithImageview:cellView.imageview1 gender:nil type:@"staff" typekey:obj.username image:@"Yes" async:YES];
        cellView.label4.hidden=NO;
    }
    
    cellView.label7.text = [MyClass returntitlewithtitle:obj.type];
    cellView.label8.text = [MyClass returntitlewithtitle:obj.action];
    cellView.label9.text = obj.change;
    cellView.label10.text = obj.useractivity;
    
    Student *student=[MyClass returnstudentwithstudentkey:obj.studentkey];
    [MyClass downloadImageWithImageview:cellView.imageview2 gender:student.gender type:@"student" typekey:obj.studentkey image:@"Yes" async:YES];
    
    if([obj.studentkey isEqualToString:@""]){
        cellView.imageview2.hidden=YES;
        cellView.label5.text=[MyClass returntitlewithtitle:@"NA"];
        cellView.label6.hidden=YES;
    }else{
        cellView.imageview2.hidden=NO;
        if(![student.firstname isEqualToString:@""]){
            cellView.label5.text = [MyClass returnStudentnameWithStudentkey:obj.studentkey option:@"fullbutid"];
            cellView.label6.text = student.studentid;
            cellView.label6.hidden=[student.studentid isEqualToString:@""];
        }else{
            cellView.label5.text=obj.enrollmentkey;
            cellView.label6.hidden=[obj.classkey isEqualToString:@""];
            cellView.label6.text=obj.classkey;
            cellView.label6.hidden=NO;
        }
    }
    
    return cellView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeLogRecord *obj=[filteredActivityLogArray objectAtIndex:indexPath.row];
    if([obj.type isEqualToString:@"Class"]){
        if([obj.action isEqualToString:@"Delete"]){
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.sourceview=@"changelog";
            mainVC.leftMenu.studentprofile_studentkey=obj.studentkey;
            mainVC.leftMenu.studentprofile_submenu=1;
            mainVC.leftMenu.studentprofile_classkeys=[[ClassKeys alloc]initClassKeysWithEnrollmentkey:obj.enrollmentkey Classkey:@""];
            globalvariables.leftmenuindex=@"1";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
        }else{
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.sourceview=@"changelog";
            mainVC.leftMenu.studentprofile_studentkey=obj.studentkey;
            mainVC.leftMenu.studentprofile_submenu=2;
            mainVC.leftMenu.studentprofile_classkeys=[[ClassKeys alloc]initClassKeysWithEnrollmentkey:@"" Classkey:obj.classkey];
            globalvariables.leftmenuindex=@"1";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
        }
    }else if ([obj.type isEqualToString:@"Enrollment"]){
        AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
        mainVC.leftMenu.prepareforsegue=TRUE;
        mainVC.leftMenu.sourceview=@"changelog";
        mainVC.leftMenu.studentprofile_studentkey=obj.studentkey;
        mainVC.leftMenu.studentprofile_submenu=1;
        mainVC.leftMenu.studentprofile_classkeys=[[ClassKeys alloc]initClassKeysWithEnrollmentkey:obj.enrollmentkey Classkey:@""];
        globalvariables.leftmenuindex=@"1";
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
        
    }else if ([obj.type isEqualToString:@"Sales"]){
        AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
        mainVC.leftMenu.prepareforsegue=TRUE;
        mainVC.leftMenu.sourceview=@"changelog";
        mainVC.leftMenu.studentprofile_studentkey=obj.studentkey;
        mainVC.leftMenu.studentprofile_submenu=3;
        mainVC.leftMenu.studentprofile_saleskey=obj.saleskey;
        globalvariables.leftmenuindex=@"1";
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
    }else if ([obj.type isEqualToString:@"Payment"]){
        if(![obj.enrollmentkey isEqualToString:@""]){
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.sourceview=@"changelog";
            mainVC.leftMenu.studentprofile_studentkey=obj.studentkey;
            mainVC.leftMenu.studentprofile_submenu=1;
            mainVC.leftMenu.studentprofile_classkeys=[[ClassKeys alloc]initClassKeysWithEnrollmentkey:obj.enrollmentkey Classkey:@""];
            globalvariables.leftmenuindex=@"1";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
        }else{
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.sourceview=@"changelog";
            mainVC.leftMenu.studentprofile_studentkey=obj.studentkey;
            mainVC.leftMenu.studentprofile_submenu=3;
            mainVC.leftMenu.studentprofile_saleskey=obj.saleskey;
            globalvariables.leftmenuindex=@"1";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
        }
    }else if ([obj.type isEqualToString:@"Discount"]){
        if(![obj.enrollmentkey isEqualToString:@""]){
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.sourceview=@"changelog";
            mainVC.leftMenu.studentprofile_studentkey=obj.studentkey;
            mainVC.leftMenu.studentprofile_submenu=1;
            mainVC.leftMenu.studentprofile_classkeys=[[ClassKeys alloc]initClassKeysWithEnrollmentkey:obj.enrollmentkey Classkey:@""];
            globalvariables.leftmenuindex=@"1";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
        }else{
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.sourceview=@"changelog";
            mainVC.leftMenu.studentprofile_studentkey=obj.studentkey;
            mainVC.leftMenu.studentprofile_submenu=3;
            mainVC.leftMenu.studentprofile_saleskey=obj.saleskey;
            globalvariables.leftmenuindex=@"1";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
        }
    }else if ([obj.type isEqualToString:@"Student"]){
        if (![obj.action isEqualToString:@"Delete"]) {
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.sourceview=@"changelog";
            mainVC.leftMenu.studentprofile_studentkey=obj.studentkey;
            mainVC.leftMenu.studentprofile_submenu=0;
            globalvariables.leftmenuindex=@"1";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
        }
    }else if ([obj.type isEqualToString:@"Center Information"]){
        if (![obj.action isEqualToString:@"Delete"]) {
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.sourceview=@"changelog";
            globalvariables.leftmenuindex=@"11";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:11 inSection:0];
            if ([obj.subtype isEqualToString:@"Center"]) {
                mainVC.leftMenu.centersetup_submenu=0;
            }else if ([obj.subtype isEqualToString:@"Calendar"]) {
                mainVC.leftMenu.centersetup_submenu=1;
            }else if ([obj.subtype isEqualToString:@"Subject"]) {
                mainVC.leftMenu.centersetup_submenu=2;
            }else if ([obj.subtype isEqualToString:@"Classroom"]) {
                mainVC.leftMenu.centersetup_submenu=3;
            }else if ([obj.subtype isEqualToString:@"Staff"]) {
                mainVC.leftMenu.centersetup_submenu=4;
            }else if ([obj.subtype isEqualToString:@"Product"]) {
                mainVC.leftMenu.centersetup_submenu=5;
            }else if ([obj.subtype isEqualToString:@"Marketing"]) {
                mainVC.leftMenu.centersetup_submenu=6;
            }else if ([obj.subtype isEqualToString:@"Policy"]) {

            }
            mainVC.leftMenu.centersetup_submenukey=obj.subtypekey;
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
        }
    }else{
        [logTable deselectRowAtIndexPath:[logTable indexPathForSelectedRow] animated:YES];
    }
}




- (IBAction)actionUpdated:(UISegmentedControl *)sender {
    [self returnFilteredArray];
}

- (IBAction)menubuttonPressed:(id)sender {
    [self.mainSlideMenu openLeftMenu];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self returnFilteredArray];
}

- (IBAction)typeButtonPressed:(UIButton *)sender {
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:typeSelected, nil]  DataType:@"CLType" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(200, typeArray.count*44) View:self Button:sender ItemsArray:typeArray Title:nil];
}

- (CGFloat)visibleLogWidth
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

- (CGFloat)visibleLogHeight
{
    CGFloat height = self.view.bounds.size.height;
    UIWindow *window = self.view.window;
    if (!window || height < 1) return height;
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    return MAX(MIN(MIN(CGRectGetMaxY(frameInWindow), CGRectGetMaxY(window.bounds)) - CGRectGetMinY(frameInWindow), height), 0);
}

- (void)layoutChangeLogForCurrentSize
{
    CGFloat width = [self visibleLogWidth];
    CGFloat height = [self visibleLogHeight];
    if (width < 1 || height < 1) return;
    if (!edgeConstants) {
        edgeConstants = [NSMutableDictionary dictionary];
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if (constraint == masterviewtrailingconstrain) continue;
            BOOL horizontal = constraint.firstItem == self.view && (constraint.firstAttribute == NSLayoutAttributeTrailing || constraint.firstAttribute == NSLayoutAttributeTrailingMargin) && constraint.secondAttribute == NSLayoutAttributeTrailing;
            BOOL vertical = constraint.firstItem == self.view && (constraint.firstAttribute == NSLayoutAttributeBottom || constraint.firstAttribute == NSLayoutAttributeBottomMargin) && constraint.secondAttribute == NSLayoutAttributeBottom;
            if (horizontal || vertical) {
                edgeConstants[[NSValue valueWithNonretainedObject:constraint]] = @(constraint.constant);
            }
        }
    }
    CGFloat visibleRight = width;
    CGFloat visibleBottom = height;
    if (self.view.window) {
        CGPoint right = [self.view convertPoint:CGPointMake(CGRectGetMaxX(self.view.window.bounds), 0) fromView:nil];
        CGPoint bottom = [self.view convertPoint:CGPointMake(0, CGRectGetMaxY(self.view.window.bounds)) fromView:nil];
        CGPoint origin = [self.view convertPoint:CGPointZero toView:nil];
        CGFloat leftShift = MAX(origin.x - CGRectGetMinX(self.view.window.bounds), 0);
        visibleRight = MIN(MAX(right.x + leftShift, 0), self.view.bounds.size.width);
        visibleBottom = MIN(MAX(bottom.y, 0), self.view.bounds.size.height);
    }
    CGFloat overflow = MAX(self.view.bounds.size.width - visibleRight, 0);
    CGFloat verticalOverflow = MAX(self.view.bounds.size.height - visibleBottom, 0);
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        NSNumber *original = edgeConstants[[NSValue valueWithNonretainedObject:constraint]];
        if (!original) continue;
        BOOL vertical = constraint.firstAttribute == NSLayoutAttributeBottom || constraint.firstAttribute == NSLayoutAttributeBottomMargin;
        CGFloat target = original.doubleValue + (vertical ? verticalOverflow : overflow);
        if (fabs(constraint.constant - target) > 0.5) constraint.constant = target;
    }
    BOOL calendarOpen = masterviewleadingconstraint.constant < -1;
    CGFloat trailing = (calendarOpen ? 0 : -320) + overflow;
    if (masterviewtrailingconstrain && fabs(masterviewtrailingconstrain.constant - trailing) > 0.5) {
        masterviewtrailingconstrain.constant = trailing;
    }
    if (calendarview) {
        calendarview.frame = CGRectMake(visibleRight, 0, 320, MAX(visibleBottom, 1));
    }
    CGFloat titleWidth = MAX(visibleRight - 140.0, 0);
    headertitleview.frame = CGRectMake(70, 0, titleWidth, 68);
    headertitlename.frame = CGRectMake(0, 25, titleWidth, 20);
    switchcenterbutton.frame = CGRectMake(0, 0, titleWidth, 68);
    [self updateheadercentertitle];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutChangeLogForCurrentSize];
}

-(void) closecalendar
{
    [self.mainSlideMenu enableSlidePanGestureForLeftMenu];
    [UIView animateWithDuration:0.3 animations:^{
        //masterview.frame=CGRectMake(0, 0, masterview.frame.size.width, masterview.frame.size.height);
        masterviewleadingconstraint.constant=0;
        masterviewtrailingconstrain.constant=-320;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){masterviewbutton.hidden=YES;}];
}

- (IBAction)toButtonPressed:(id)sender {
    [self.mainSlideMenu disableSlidePanGestureForLeftMenu];
    selectedItem=@"logtodate";
    [calendarview refreshviewwithoption:@"start"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[MyClass convertToNSStringWithNSDate:toDate DateFormat:@"dd-MMM-yyyy"], nil] ScrollToDate:nil  instructorselected:@"All"];
        [calendarview refreshviewwithoption:@"stop"];
    });
    
    [UIView animateWithDuration:0.3 animations:^{
        masterviewleadingconstraint.constant=-320;
        masterviewtrailingconstrain.constant=0;
        [self.view layoutIfNeeded];
        masterviewbutton.hidden=NO;
    } completion:nil];
}

- (IBAction)fromButtonPressed:(id)sender {
    [self.mainSlideMenu disableSlidePanGestureForLeftMenu];
    selectedItem=@"logfromdate";
    [calendarview refreshviewwithoption:@"start"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[MyClass convertToNSStringWithNSDate:fromDate DateFormat:@"dd-MMM-yyyy"], nil] ScrollToDate:nil  instructorselected:@"All"];
        [calendarview refreshviewwithoption:@"stop"];
    });
    
    [UIView animateWithDuration:0.3 animations:^{
        masterviewleadingconstraint.constant=-320;
        masterviewtrailingconstrain.constant=0;
        [self.view layoutIfNeeded];
        masterviewbutton.hidden=NO;
    } completion:nil];
}

//- (IBAction)dateRangeButtonPressed:(UIButton *)sender {
//    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:dateRangeSelected, nil]  DataType:@"CLDateRange" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(200, dateRangeArray.count*44) View:self Button:sender ItemsArray:dateRangeArray Title:nil];
//}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"CLType"]) {
        typeSelected=[selecteditems firstObject];
    }/*else if ([datatype isEqualToString:@"CLDateRange"]) {
        dateRangeSelected=[selecteditems firstObject];
    }*/
    [self updateButtonTitle];
    [self returnFilteredArray];
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    [self closecalendar];
    
    
    NSString *selecteddatestring=[selecteddatearray firstObject];
    if ([selectedItem isEqualToString:@"logfromdate"]){
        if (![[MyClass convertToNSStringWithNSDate:fromDate DateFormat:@"dd-MMM-yyyy"] isEqualToString:selecteddatestring]) {
            fromDate=[MyClass convertToNSDateWithDate:selecteddatestring DateFormat:@"dd-MMM-yyyy"];
            
            if([MyClass noOfDayBetweenStartDate:[MyClass convertToNSDateWithDate:selecteddatestring DateFormat:@"dd-MMM-yyyy"] EndDate:toDate]>maxrange){
                toDate=[MyClass addDaysWithDate:fromDate days:maxrange];
            }else if ([MyClass noOfDayBetweenStartDate:[MyClass convertToNSDateWithDate:selecteddatestring DateFormat:@"dd-MMM-yyyy"] EndDate:toDate]<0){
                toDate=fromDate;
            }
            [self updateButtonTitle];
            [MyClass loadingindicatorwithoption:@"start" color:@"white"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getActivityLog];
            });
        }
    }else if ([selectedItem isEqualToString:@"logtodate"]){
        if (![[MyClass convertToNSStringWithNSDate:toDate DateFormat:@"dd-MMM-yyyy"] isEqualToString:selecteddatestring]) {
            toDate=[MyClass convertToNSDateWithDate:selecteddatestring DateFormat:@"dd-MMM-yyyy"];
            
            if([MyClass noOfDayBetweenStartDate:fromDate EndDate:[MyClass convertToNSDateWithDate:selecteddatestring DateFormat:@"dd-MMM-yyyy"]]>maxrange){
                fromDate=[MyClass addDaysWithDate:toDate days:-maxrange];
            }else if ([MyClass noOfDayBetweenStartDate:fromDate EndDate:[MyClass convertToNSDateWithDate:selecteddatestring DateFormat:@"dd-MMM-yyyy"]]<0){
                fromDate=toDate;
            }
            [self updateButtonTitle];
            [MyClass loadingindicatorwithoption:@"start" color:@"white"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getActivityLog];
            });
        }
    }
}

@end
