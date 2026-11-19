//
//  StudentInformationViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 4/25/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "StudentInformationViewController.h"
#import "StudentDetailsViewController.h"
#import "MainMenuViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MyClass.h"
#import "MainViewController.h"
//#import "MainMenuNavController.h"
#import "MyTableViewCell.h"

@interface StudentInformationViewController ()

@end

#define studentlistwidth 240

@implementation StudentInformationViewController
@synthesize StudentDetailsContainerView;
@synthesize destStudentDetailsViewController;
@synthesize InformationViewStudent,StudentInformationAction,StudentInformationLeadObject,StudentInformationATObject,StudentInformationClassScheduleObject,StudentInformationDTObject;

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
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    //create calendar table
    
//    topleftview.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:0.8];
//    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(220, 68, .5, self.view.bounds.size.height-68)];
//    separator.backgroundColor=[UIColor lightGrayColor];
//    [self.view addSubview:separator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checktoreloadapp) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //[self.navigationController.navigationBar setFrame:CGRectMake(0, 0, self.view.frame.size.width,64.0)];
    
    //StudentCategoryContainerView.frame=CGRectMake(0, 0, 220, self.view.bounds.size.height);
    //StudentDetailsContainerView.frame=CGRectMake(220, 0, self.view.bounds.size.width-studentlistwidth, self.view.bounds.size.height);
    destStudentDetailsViewController.preferredContentSize=StudentDetailsContainerView.frame.size;
    
    UIImageView *activityImageView=[[UIImageView alloc]init];
    activityImageView.animationImages=[MyClass returnLoadingIndicatorAnimatedImageWithBaseColor:@"lightgray"];
    activityImageView.alpha=1.0;
    activityImageView.animationDuration=1.5;
    activityImageView.frame=CGRectMake(0,0,30,30);
    [activityImageView startAnimating];
    
    //ailoadindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //ailoadindicator.alpha = 1.0;
    ailoadindicator.color=[UIColor clearColor];
    ailoadindicator.transform=CGAffineTransformMakeScale(1, 1);
    //ailoadindicator.center = CGPointMake(110,self.view.frame.size.height/2);
    //ailoadindicator.hidesWhenStopped = YES;
    [ailoadindicator addSubview:activityImageView];
    //[self.view addSubview:ailoadindicator];
    [ailoadindicator startAnimating];
    
    if (!sortingarray) {
        sortingarray=[MyClass returnsortingarraywithtype:@"studentlistsortingorder"];
    }
    
    studentlisttable.editing=NO;
    studentlisttable.scrollEnabled=YES;
    studentTableMode=@"category";
    studentCategory=@"All";
    [self showButton];
    [self editStudent:NO];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    //tablerefresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [tablerefresh addTarget:self action:@selector(refreshtable) forControlEvents:UIControlEventValueChanged];
    [studentlisttable addSubview:tablerefresh];
    studentlisttable.hidden=YES;
    
    studentsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    runviewdidappear=TRUE;
    
    [editStudentSelectAllButton setTitle:[MyClass returntitlewithtitle:@"Select all"] forState:UIControlStateNormal];
    [editStudentClearAllButton setTitle:[MyClass returntitlewithtitle:@"Clear all"] forState:UIControlStateNormal];
    [editStudentActionButton setTitle:[MyClass returntitlewithtitle:@"Action"] forState:UIControlStateNormal];
    
    selectedStudentKeysArray=[[NSMutableArray alloc]init];
    
}


-(void) checktoreloadapp
{
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {
        
        if ([destStudentDetailsViewController.mySharePopoverController presentingViewController].isBeingPresented) {
            [[destStudentDetailsViewController.mySharePopoverController  presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destStudentDetailsViewController.myPopoverController presentingViewController].isBeingPresented){
            [[destStudentDetailsViewController.myPopoverController  presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destStudentDetailsViewController.deststudenteditviewcontroller.mypopovercontroller presentingViewController].isBeingPresented){
            [[destStudentDetailsViewController.deststudenteditviewcontroller.mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }/*else if ([destStudentDetailsViewController.myCallLogSelectionPopoverController presentingViewController].isBeingPresented){
            [[destStudentDetailsViewController.myCallLogSelectionPopoverController  presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }*/else if ([destStudentDetailsViewController.myClassSelectionPopoverController presentingViewController].isBeingPresented){
            [[destStudentDetailsViewController.myClassSelectionPopoverController  presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destStudentDetailsViewController.myDTSelectionPopoverController presentingViewController].isBeingPresented){
            [[destStudentDetailsViewController.myDTSelectionPopoverController  presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destStudentDetailsViewController.myDaySelectionPopoverController presentingViewController].isBeingPresented){
            [[destStudentDetailsViewController.myDaySelectionPopoverController  presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destStudentDetailsViewController.myTypeSelectionPopoverController presentingViewController].isBeingPresented){
            [[destStudentDetailsViewController.myTypeSelectionPopoverController  presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==studentimagepopover){
            [studentimagepopover dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==destStudentDetailsViewController.documentfolderpopover) {
            [destStudentDetailsViewController.documentfolderpopover dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.mainSlideMenu closeLeftMenu];
        }
        
        
        [destStudentDetailsViewController closesidewindow];
        globalvariables.appbecomeactiveaction=@"";
        globalvariables.leftmenuindex=@"0";
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [MyClass reloadApp];
        
        

        
        
    }else if ([globalvariables.appbecomeactiveaction isEqualToString:@"refresh"]) {
        globalvariables.appbecomeactiveaction=@"";
        
        
        
        if ([destStudentDetailsViewController.mySharePopoverController presentingViewController].isBeingPresented) {
            [[destStudentDetailsViewController.mySharePopoverController  presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destStudentDetailsViewController.myPopoverController presentingViewController].isBeingPresented){
            [[destStudentDetailsViewController.myPopoverController  presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destStudentDetailsViewController.deststudenteditviewcontroller.mypopovercontroller presentingViewController].isBeingPresented){
            [[destStudentDetailsViewController.deststudenteditviewcontroller.mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }/*else if ([destStudentDetailsViewController.myCallLogSelectionPopoverController presentingViewController].isBeingPresented){
            [[destStudentDetailsViewController.myCallLogSelectionPopoverController  presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }*/else if ([destStudentDetailsViewController.myClassSelectionPopoverController presentingViewController].isBeingPresented){
            [[destStudentDetailsViewController.myClassSelectionPopoverController  presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destStudentDetailsViewController.myDTSelectionPopoverController presentingViewController].isBeingPresented){
            [[destStudentDetailsViewController.myDTSelectionPopoverController  presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destStudentDetailsViewController.myDaySelectionPopoverController presentingViewController].isBeingPresented){
            [[destStudentDetailsViewController.myDaySelectionPopoverController  presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }/*else if (destStudentCategoryViewController.destStudentListViewController.mypopovercontroller presentingViewController].isBeingPresented){
            [destStudentCategoryViewController.destStudentListViewController.mypopovercontroller  presentingViewController] dismissViewControllerAnimated:NO Completion:nil];
        }*/else if (self.presentedViewController==destStudentDetailsViewController.documentfolderpopover) {
            [destStudentDetailsViewController.documentfolderpopover dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==studentimagepopover){
            [studentimagepopover dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.mainSlideMenu closeLeftMenu];
        }
        [destStudentDetailsViewController closesidewindow];
        [destStudentDetailsViewController reloadPageWithFirstLoad:NO];
        
    }
}

-(void) refreshtable
{
    [MyClass getLatestDataSetv2withParameters:@"student" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    [self updateCategoryCount];
    //[self.tableView reloadData];
    [tablerefresh endRefreshing];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.mainSlideMenu disableSlidePanGestureForRightMenu];
    globalvariables=[GlobalVariables singleObj];
    globalvariables.lastviewcontroller=(NSString *)self;
    
    if (runviewdidappear) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateCategoryCount];
            [self changeStudentListWithCategory:@"All"];
            
            if ([StudentInformationAction isEqualToString:@"EnrollLead"]) {
                [self EnrollLead:StudentInformationLeadObject];
            }else if ([StudentInformationAction isEqualToString:@"EnrollATLeadStudent"]){
                [self EnrollATLeadStudent:StudentInformationATObject];
            }else if ([StudentInformationAction isEqualToString:@"AddStudentAndSubject"]){
                [self AddStudentAndSubject:StudentInformationClassScheduleObject];
            }
            
            if (Studentkey && ![Studentkey isEqualToString:@""]) {
                StudentInformationAction=@"";
                [self gotostudentprofile:Studentkey submenu:Submenu classkeys:selectedKeys saleskey:selectedsaleskey];
            }
        });
    }else{
        runviewdidappear=TRUE;
    }
}

-(void) donotrunviewdidappearinstudentinformation
{
    runviewdidappear=FALSE;
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"toStudentDetailsView"]) {
        destStudentDetailsViewController= [[[segue destinationViewController]viewControllers] objectAtIndex:0];
        destStudentDetailsViewController.delegate=self;
        destStudentDetailsViewController.selectedClasskey=selectedKeys.classkey;
        destStudentDetailsViewController.selectedEnrollmentkey=selectedKeys.enrollmentkey;
        destStudentDetailsViewController.selectedSaleskey=selectedsaleskey;
        destStudentDetailsViewController.studentAction=StudentInformationAction;
        destStudentDetailsViewController.lastviewindex=-1;
    }/*else if([segue.identifier isEqualToString:@"toStudentListCategory"]){
        destStudentCategoryViewController = [[[segue destinationViewController]viewControllers] objectAtIndex:0];
        destStudentCategoryViewController.delegate=self;
        destStudentCategoryViewController.Studentkey=Studentkey;
    }*/
}

-(void) passSystemMessage:(NSString *)systemmessage
{
    destStudentDetailsViewController.systemMessageLabel.text=systemmessage;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //[self changeStudentListWithCategory:@"All"];
    [destStudentDetailsViewController stopAudioPlaying];
    if([studentTableMode isEqualToString:@"category"]){
        //[self changeStudentListWithCategory:@"All"];
        studentTableMode=@"list";
        [backbutton setTitle:[MyClass returntitlewithtitle:@"All"] forState:UIControlStateNormal];
    }
    [self showButton];
    
    
    [self returnfilteredstudentlistarray];
    //[self filteredarraywithsearchtext:searchText];
    [studentlisttable reloadData];
    [studentlisttable setContentOffset:CGPointZero animated:YES];
    
}

- (void)updatestudentsearchbar{
    //if ([studentTableMode isEqualToString:@"category"]) {
    //[self changeStudentListWithCategory:@"Active"];
    //}
    
    studentTableMode=@"list";
    [self returnfilteredstudentlistarray];
    [studentlisttable reloadData];
    [self showButton];
}

/*
-(void) filteredarraywithsearchtext:(NSString *)searchtext
{
    if (!searchtext || [searchtext isEqualToString:@""]) {
        filteredStudentArray= [NSMutableArray arrayWithArray:studentArray];
    }else{
        //[filteredStudentArray removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.studentkey contains[c] %@ or SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or self.othername contains[c] %@ or any phonearray.contact contains[c] %@ or self.studentid contains[c] %@ or self.remarks contains[c] %@ or self.grade contains[c] %@ or self.school contains[c] %@ or self.parentaddress contains[c] %@ or self.parentemail contains[c] %@",searchtext,searchtext,searchtext,searchtext,searchtext,searchtext,searchtext,searchtext,searchtext,searchtext,searchtext];
        filteredStudentArray= [NSMutableArray arrayWithArray:[studentArray filteredArrayUsingPredicate:predicate]];
    }
    filteredStudentArray=[MyClass sortstudentlistwithstudentarray:filteredStudentArray sortingarray:sortingarray];
    
}*/


-(void) returnfilteredstudentlistarray
{
    if (!studentsearchbar || [studentsearchbar.text isEqualToString:@""]) {
        filteredStudentArray= [NSMutableArray arrayWithArray:studentArray];
    }else{
        NSArray *wildcards=[studentsearchbar.text componentsSeparatedByString:@" "];
        NSString *searchWithWildcards=[wildcards componentsJoinedByString:@"*"];
        searchWithWildcards=[NSString stringWithFormat:@"%@%@%@",@"*",searchWithWildcards,@"*"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.studentkey contains[c] %@ or SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or self.othername contains[c] %@ or any phonearray.contact contains[c] %@ or self.studentid contains[c] %@ or self.remarks like[cd] %@ or self.grade contains[c] %@ or self.school like[cd] %@ or self.parentaddress like[cd] %@ or self.parentemail contains[c] %@ or self.displayfullname like[cd] %@ or self.fcmemberid contains[c] %@ or self.ddaaccountno contains[c] %@ or self.ddaaccountname contains[c] %@ or SELF.parentname contains[c] %@ or SELF.parentname2 contains[c] %@",studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,searchWithWildcards,studentsearchbar.text,searchWithWildcards,searchWithWildcards,studentsearchbar.text,searchWithWildcards,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text];
        filteredStudentArray= [NSMutableArray arrayWithArray:[studentArray filteredArrayUsingPredicate:predicate]];
    }
    filteredStudentArray=[MyClass sortstudentlistwithstudentarray:filteredStudentArray sortingarray:sortingarray];
    
}


-(void) changeStudentListWithCategory:(NSString *)category
{
    studentCategory=category;
    if ([category isEqualToString:@"Active"]) {
        studentArray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@ and self.status !=%@",globalvariables.centerrecord.centerkey,@"Inactive"];
        studentArray=[[NSMutableArray alloc]initWithArray:[studentArray filteredArrayUsingPredicate:predicate]];
    }else if([category isEqualToString:@"Suspended"]){
        studentArray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@ and self.status =%@",globalvariables.centerrecord.centerkey,@"Inactive"];
        studentArray=[[NSMutableArray alloc]initWithArray:[studentArray filteredArrayUsingPredicate:predicate]];
    }else if([category isEqualToString:@"All"]){
        studentArray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@",globalvariables.centerrecord.centerkey];
        studentArray=[[NSMutableArray alloc]initWithArray:[studentArray filteredArrayUsingPredicate:predicate]];
    }
    [self returnfilteredstudentlistarray];
    //[studentlisttable reloadData];
}

-(NSInteger) returnStudentIndexWithStudent:(Student *)student
{
    for (int i=0; i<filteredStudentArray.count; i++) {
        if ([((Student *)[filteredStudentArray objectAtIndex:i]).studentkey isEqualToString:student.studentkey]) {
            return i;
        }
    }
    return -1;
}

-(void) gotostudentprofile:(NSString *)studentkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys saleskey:(NSString *)saleskey
{
    Studentkey=studentkey;
    selectedKeys=classkeys;
    selectedsaleskey=saleskey;
    Submenu=submenu;
    
    if (![StudentInformationAction isEqualToString:@"Redirect"]){

        if (![studentTableMode isEqualToString:@"list"]) {
            [self updatestudentsearchbar];
            [backbutton setTitle:[MyClass returntitlewithtitle:@"All"] forState:UIControlStateNormal];
        }
        
        //clear search
        if (![studentsearchbar.text isEqualToString:@""]) {
            studentsearchbar.text=@"";
            [self returnfilteredstudentlistarray];
            [studentlisttable reloadData];
        }
        
        
        //scroll to the selected student
        
        studentobject=[MyClass returnstudentwithstudentkey:studentkey];
        long gotorow=[self returnStudentIndexWithStudent:studentobject];
        if (gotorow<0) {
            studentCategory=@"All";
            [self changeStudentListWithCategory:studentCategory];
            if ([filteredStudentArray containsObject:studentobject]) {
                gotorow=[filteredStudentArray indexOfObject:studentobject];
            }
            [backbutton setTitle:[MyClass returntitlewithtitle:@"All"] forState:UIControlStateNormal];
        }
        
        if (gotorow>=0) {
            laststudentkey=studentkey;
            [self tableView:studentlisttable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0]];
            [studentlisttable selectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            //[studentlisttable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]  atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else{
            [MyClass removeViewHistoryWithType:@"student" Typekey:studentkey];
            [self passSystemMessage:@"Student no longer exists"];
        }

        [self showButton];
    }
    

    
    
}

- (IBAction)menubuttonpressed:(id)sender {
    [destStudentDetailsViewController stopAudioPlaying];
    [self.mainSlideMenu openLeftMenu];
}



-(BOOL) passStudentkeytoStudentInformation:(NSString *)studentkey studentcategory:(NSString *)studentcategory
{
    
    /*if (destStudentCategoryViewController.navigationController !=nil) {
        [destStudentDetailsViewController.navigationController popToRootViewControllerAnimated:NO];
    }jasmond*/

    destStudentDetailsViewController.DetailsViewStudent=[MyClass returnstudentwithstudentkey:studentkey];
    [destStudentDetailsViewController showviewhistory:FALSE];
    
    //[destStudentDetailsViewController.ClassSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Classes"] forState:UIControlStateNormal];
    if ((Submenu==1 && ![Studentkey isEqualToString:@""]) || (Submenu<=0 && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showstudentpage)) {
        if (destStudentDetailsViewController.lastviewindex<0) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=YES;
            destStudentDetailsViewController.typeselectionarrow.hidden=YES;
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 200.5, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=YES;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=NO;
            

            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            destStudentDetailsViewController.dayselected=@"All";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Days"] forState:UIControlStateNormal];
            
            
            destStudentDetailsViewController.scactiveoption_enrollment.selectedSegmentIndex=0;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:1];
            destStudentDetailsViewController.lastviewindex=1;
            destStudentDetailsViewController.lastdayofweekindex=0;
            destStudentDetailsViewController.lastactivedraftindex_enrollment=0;
            destStudentDetailsViewController.lasttypeindex=0;
        
        }
    }else if (Submenu==2 && ![Studentkey isEqualToString:@""]) {
        if (destStudentDetailsViewController.lastviewindex<0) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=NO;
            destStudentDetailsViewController.typeselectionarrow.hidden=NO;
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 129, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=NO;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=YES;
            

            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            destStudentDetailsViewController.dayselected=@"All";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Days"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_class.selectedSegmentIndex=1;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:2];
            //destStudentDetailsViewController.sctableoption.selectedSegmentIndex=2;
            destStudentDetailsViewController.lastviewindex=2;
            destStudentDetailsViewController.lastdayofweekindex=0;
            destStudentDetailsViewController.lastactivedraftindex_class=1;
            destStudentDetailsViewController.lasttypeindex=0;
        }
    }else if (Submenu==3 && ![Studentkey isEqualToString:@""]) {
        if (destStudentDetailsViewController.lastviewindex<0) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=YES;
            destStudentDetailsViewController.typeselectionarrow.hidden=YES;
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 200.5, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=YES;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=NO;
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:3];
            destStudentDetailsViewController.lastviewindex=3;

            
            
            destStudentDetailsViewController.productcategoryselected=@"All";
            [destStudentDetailsViewController.ProductCategorySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Categories"] forState:UIControlStateNormal];
            //destStudentDetailsViewController.sceventselection.selectedSegmentIndex=0;
        
        }
    }else if ([studentcategory isEqualToString:@"All"] || [studentcategory isEqualToString:@"Male"] || [studentcategory isEqualToString:@"Female"]|| [studentcategory isEqualToString:@"Nursery"]||[studentcategory isEqualToString:@"Kindergarten"]||[studentcategory isEqualToString:@"Primary"]||[studentcategory isEqualToString:@"Secondary"] || [studentcategory isEqualToString:@"AdvancedSearch"]) {
        

        
        if (destStudentDetailsViewController.lastviewindex<0) {


            
            destStudentDetailsViewController.TypeSelectionButton.hidden=NO;
            destStudentDetailsViewController.typeselectionarrow.hidden=NO;
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 200.5, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=YES;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=NO;
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            destStudentDetailsViewController.dayselected=@"All";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Days"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_enrollment.selectedSegmentIndex=0;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:0];
            destStudentDetailsViewController.lastviewindex=0;
            destStudentDetailsViewController.lastdayofweekindex=0;
            destStudentDetailsViewController.lastactivedraftindex_enrollment=0;
            destStudentDetailsViewController.scactiveoption_class.selectedSegmentIndex=1;
            destStudentDetailsViewController.lastactivedraftindex_class=1;
            destStudentDetailsViewController.lasttypeindex=0;
        }

    }else if([studentcategory isEqualToString:@"None"]){
        
        if (destStudentDetailsViewController.lastviewindex<0) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=YES;
            destStudentDetailsViewController.typeselectionarrow.hidden=YES;
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 200.5, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=YES;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=NO;
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            destStudentDetailsViewController.dayselected=@"All";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Days"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_enrollment.selectedSegmentIndex=0;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:0];
            destStudentDetailsViewController.lastviewindex=0;
            destStudentDetailsViewController.lastdayofweekindex=0;
            destStudentDetailsViewController.lastactivedraftindex_enrollment=0;
            destStudentDetailsViewController.scactiveoption_class.selectedSegmentIndex=1;
            destStudentDetailsViewController.lastactivedraftindex_class=1;
            destStudentDetailsViewController.lasttypeindex=0;
        }
        

        
    }else if([studentcategory isEqualToString:@"Monday"]){
        
        if (destStudentDetailsViewController.lastviewindex<0 || ![destStudentDetailsViewController.dayselected isEqualToString:@"Mon"]) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=NO;
            destStudentDetailsViewController.typeselectionarrow.hidden=NO;
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 129, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=NO;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=YES;
            
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            destStudentDetailsViewController.dayselected=@"Mon";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"Mon"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_class.selectedSegmentIndex=1;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:2];
            destStudentDetailsViewController.lastviewindex=2;
            destStudentDetailsViewController.lastdayofweekindex=1;
            destStudentDetailsViewController.lastactivedraftindex_class=1;
            destStudentDetailsViewController.lasttypeindex=0;
        }

    }else if([studentcategory isEqualToString:@"Tuesday"]){
        if (destStudentDetailsViewController.lastviewindex<0 || ![destStudentDetailsViewController.dayselected isEqualToString:@"Tue"]) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=NO;
            //destStudentDetailsViewController.scdayoption.frame=CGRectMake(303, 2, 200.5, 29);
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 129, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=NO;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=YES;
            
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            destStudentDetailsViewController.dayselected=@"Tue";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"Tue"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_class.selectedSegmentIndex=1;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:2];
            //destStudentDetailsViewController.sctableoption.selectedSegmentIndex=2;
            destStudentDetailsViewController.lastviewindex=2;
            destStudentDetailsViewController.lastdayofweekindex=2;
            destStudentDetailsViewController.lastactivedraftindex_class=1;
            destStudentDetailsViewController.lasttypeindex=0;
        }
        

    }else if([studentcategory isEqualToString:@"Wednesday"]){
        if (destStudentDetailsViewController.lastviewindex<0 || ![destStudentDetailsViewController.dayselected isEqualToString:@"Wed"]) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=NO;
            destStudentDetailsViewController.typeselectionarrow.hidden=NO;
            //destStudentDetailsViewController.scdayoption.frame=CGRectMake(303, 2, 200.5, 29);
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 129, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=NO;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=YES;
            
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            destStudentDetailsViewController.dayselected=@"Wed";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"Wed"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_class.selectedSegmentIndex=1;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:2];
            //destStudentDetailsViewController.sctableoption.selectedSegmentIndex=2;
            destStudentDetailsViewController.lastviewindex=2;
            destStudentDetailsViewController.lastdayofweekindex=3;
            destStudentDetailsViewController.lastactivedraftindex_class=0;
            destStudentDetailsViewController.lasttypeindex=0;
        }

    }else if([studentcategory isEqualToString:@"Thursday"]){
        if (destStudentDetailsViewController.lastviewindex<0 || ![destStudentDetailsViewController.dayselected isEqualToString:@"Thu"]) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=NO;
            //destStudentDetailsViewController.scdayoption.frame=CGRectMake(303, 2, 200.5, 29);
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 129, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=NO;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=YES;
            
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            destStudentDetailsViewController.dayselected=@"Thu";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"Thu"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_class.selectedSegmentIndex=1;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:2];
            //destStudentDetailsViewController.sctableoption.selectedSegmentIndex=2;
            destStudentDetailsViewController.lastviewindex=2;
            destStudentDetailsViewController.lastdayofweekindex=4;
            destStudentDetailsViewController.lastactivedraftindex_class=1;
            destStudentDetailsViewController.lasttypeindex=0;
        }
        

    }else if([studentcategory isEqualToString:@"Friday"]){
        if (destStudentDetailsViewController.lastviewindex<0 || ![destStudentDetailsViewController.dayselected isEqualToString:@"Fri"]) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=NO;
            destStudentDetailsViewController.typeselectionarrow.hidden=NO;
            //destStudentDetailsViewController.scdayoption.frame=CGRectMake(303, 2, 200.5, 29);
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 129, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=NO;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=YES;
            
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            destStudentDetailsViewController.dayselected=@"Fri";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"Fri"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_class.selectedSegmentIndex=1;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:2];
            //destStudentDetailsViewController.sctableoption.selectedSegmentIndex=2;
            destStudentDetailsViewController.lastviewindex=2;
            destStudentDetailsViewController.lastdayofweekindex=5;
            destStudentDetailsViewController.lastactivedraftindex_class=1;
            destStudentDetailsViewController.lasttypeindex=0;
        }
        

    }else if([studentcategory isEqualToString:@"Saturday"]){
        if (destStudentDetailsViewController.lastviewindex<0 || ![destStudentDetailsViewController.dayselected isEqualToString:@"Sat"]) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=NO;
            destStudentDetailsViewController.typeselectionarrow.hidden=NO;
            //destStudentDetailsViewController.scdayoption.frame=CGRectMake(303, 2, 200.5, 29);
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 129, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=NO;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=YES;
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            destStudentDetailsViewController.dayselected=@"Sat";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"Sat"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_class.selectedSegmentIndex=1;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:2];
            //destStudentDetailsViewController.sctableoption.selectedSegmentIndex=2;
            destStudentDetailsViewController.lastviewindex=2;
            destStudentDetailsViewController.lastdayofweekindex=6;
            destStudentDetailsViewController.lastactivedraftindex_class=1;
            destStudentDetailsViewController.lasttypeindex=0;
        }
        

    }else if([studentcategory isEqualToString:@"Sunday"]){
        if (destStudentDetailsViewController.lastviewindex<0 || ![destStudentDetailsViewController.dayselected isEqualToString:@"Sun"]) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=NO;
            destStudentDetailsViewController.typeselectionarrow.hidden=NO;
            //destStudentDetailsViewController.scdayoption.frame=CGRectMake(303, 2, 200.5, 29);
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 129, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204-studentlistwidth, 2, 187, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=NO;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=YES;
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            destStudentDetailsViewController.dayselected=@"Sun";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"Sun"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_class.selectedSegmentIndex=1;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:2];
            //destStudentDetailsViewController.sctableoption.selectedSegmentIndex=2;
            destStudentDetailsViewController.lastviewindex=2;
            destStudentDetailsViewController.lastdayofweekindex=7;
            destStudentDetailsViewController.lastactivedraftindex_class=1;
            destStudentDetailsViewController.lasttypeindex=0;
        }
        

    }else if([studentcategory isEqualToString:@"Multi"]){
        if (destStudentDetailsViewController.lastviewindex<0 || ![destStudentDetailsViewController.dayselected isEqualToString:@"Multi"]) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=YES;
            destStudentDetailsViewController.typeselectionarrow.hidden=YES;
            //destStudentDetailsViewController.scdayoption.frame=CGRectMake(303, 2, 200.5, 29);
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 200.5, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=YES;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=NO;
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            //destStudentDetailsViewController.scdayoption.selectedSegmentIndex=8;
            destStudentDetailsViewController.scactiveoption_enrollment.selectedSegmentIndex=0;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:1];
            //destStudentDetailsViewController.sctableoption.selectedSegmentIndex=1;
            destStudentDetailsViewController.lastviewindex=1;
            destStudentDetailsViewController.lastdayofweekindex=7;
            destStudentDetailsViewController.lastactivedraftindex_enrollment=0;
            destStudentDetailsViewController.lasttypeindex=0;
        }
        

    }else if([studentcategory isEqualToString:@"Present"]){
        if (destStudentDetailsViewController.lastviewindex<0) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=YES;
            //destStudentDetailsViewController.scdayoption.frame=CGRectMake(303, 2, 200.5, 29);
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 200.5, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=YES;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=NO;
            
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            //destStudentDetailsViewController.scdayoption.selectedSegmentIndex=0;
            destStudentDetailsViewController.dayselected=@"All";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Days"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_enrollment.selectedSegmentIndex=0;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:1];
            //destStudentDetailsViewController.sctableoption.selectedSegmentIndex=1;
            destStudentDetailsViewController.lastviewindex=1;
            destStudentDetailsViewController.lastdayofweekindex=0;
            destStudentDetailsViewController.lastactivedraftindex_enrollment=0;
            destStudentDetailsViewController.lasttypeindex=0;
        }
        

    }else if([studentcategory isEqualToString:@"Future Class"] || [studentcategory isEqualToString:@"Current Class"] || [studentcategory isEqualToString:@"No Class (Non Dropped)"]  || [studentcategory isEqualToString:@"No Class (All Dropped)"] || [studentcategory isEqualToString:@"TBD Class Left Only"]){
        if (destStudentDetailsViewController.lastviewindex<0) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=YES;
            destStudentDetailsViewController.typeselectionarrow.hidden=YES;
            //destStudentDetailsViewController.scdayoption.frame=CGRectMake(303, 2, 200.5, 29);
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 200.5, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=YES;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=NO;
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            //destStudentDetailsViewController.scdayoption.selectedSegmentIndex=0;
            destStudentDetailsViewController.dayselected=@"All";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Days"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_enrollment.selectedSegmentIndex=0;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:1];
            //destStudentDetailsViewController.sctableoption.selectedSegmentIndex=1;
            destStudentDetailsViewController.lastviewindex=1;
            destStudentDetailsViewController.lastdayofweekindex=0;
            destStudentDetailsViewController.lastactivedraftindex_enrollment=0;
            destStudentDetailsViewController.lasttypeindex=0;
        }
        

    }else if([studentcategory isEqualToString:@"Flagged"]){
        if (destStudentDetailsViewController.lastviewindex<0) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=NO;
            destStudentDetailsViewController.typeselectionarrow.hidden=NO;
            //destStudentDetailsViewController.scdayoption.frame=CGRectMake(303, 2, 200.5, 29);
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 200.5, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=YES;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=NO;
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            //destStudentDetailsViewController.scdayoption.selectedSegmentIndex=0;
            destStudentDetailsViewController.dayselected=@"All";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Days"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_enrollment.selectedSegmentIndex=0;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:0];
            //destStudentDetailsViewController.sctableoption.selectedSegmentIndex=0;
            destStudentDetailsViewController.lastviewindex=0;
            destStudentDetailsViewController.lastdayofweekindex=0;
            destStudentDetailsViewController.lastactivedraftindex_enrollment=0;
            destStudentDetailsViewController.lasttypeindex=0;
        }
        

    }else if([studentcategory isEqualToString:@"Active"] || [studentcategory isEqualToString:@"Suspended"]  || [studentcategory isEqualToString:@"Skipped"]){
        if (destStudentDetailsViewController.lastviewindex<0) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=NO;
//        destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 200.5, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
            destStudentDetailsViewController.scactiveoption_class.hidden=YES;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=NO;
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            //destStudentDetailsViewController.scdayoption.selectedSegmentIndex=0;
            destStudentDetailsViewController.dayselected=@"All";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Days"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_enrollment.selectedSegmentIndex=0;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:0];
            //destStudentDetailsViewController.sctableoption.selectedSegmentIndex=0;
            destStudentDetailsViewController.lastviewindex=0;
            destStudentDetailsViewController.lastdayofweekindex=0;
            destStudentDetailsViewController.lastactivedraftindex_enrollment=0;
            destStudentDetailsViewController.lasttypeindex=0;
        }
        
        
    }else if([studentcategory isEqualToString:@"Draft"]){
        if (destStudentDetailsViewController.lastviewindex<0) {
            destStudentDetailsViewController.TypeSelectionButton.hidden=YES;
            destStudentDetailsViewController.typeselectionarrow.hidden=YES;
            //destStudentDetailsViewController.scdayoption.frame=CGRectMake(303, 2, 200.5, 29);
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 200.5, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
            
            destStudentDetailsViewController.scactiveoption_class.hidden=YES;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=NO;
            
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            //destStudentDetailsViewController.scdayoption.selectedSegmentIndex=0;
            destStudentDetailsViewController.dayselected=@"All";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Days"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_enrollment.selectedSegmentIndex=2;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:1];
            //destStudentDetailsViewController.sctableoption.selectedSegmentIndex=1;
            destStudentDetailsViewController.lastviewindex=1;
            destStudentDetailsViewController.lastdayofweekindex=0;
            destStudentDetailsViewController.lastactivedraftindex_enrollment=0;
            destStudentDetailsViewController.lasttypeindex=0;
        }
        

    }else{// subject classes selected
        
        if (destStudentDetailsViewController.lastviewindex<0  || ![destStudentDetailsViewController.subjectselected isEqualToString:studentcategory]) {
            destStudentDetailsViewController.subjectselected=studentcategory;
            [destStudentDetailsViewController.ClassSelectionButton setTitle:[MyClass returnsubjectnamewithsubject_shortname:studentcategory centerkey:globalvariables.centerrecord.centerkey] forState:UIControlStateNormal];
            destStudentDetailsViewController.TypeSelectionButton.hidden=YES;
            destStudentDetailsViewController.typeselectionarrow.hidden=YES;
//            destStudentDetailsViewController.DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501-studentlistwidth, 2, 200.5, 29);
//            destStudentDetailsViewController.scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
//            destStudentDetailsViewController.scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-299-studentlistwidth, 2, 282, 29);
            
            destStudentDetailsViewController.scactiveoption_class.hidden=YES;
            destStudentDetailsViewController.scactiveoption_enrollment.hidden=NO;
            
            [destStudentDetailsViewController drawpointerwithoption:@"closed" imageview:destStudentDetailsViewController.dayselectionarrow];
            
            destStudentDetailsViewController.dayselected=@"All";
            [destStudentDetailsViewController.DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Days"] forState:UIControlStateNormal];
            destStudentDetailsViewController.scactiveoption_enrollment.selectedSegmentIndex=0;
            [destStudentDetailsViewController highlighttableoptionbuttonwithbuttontag:1];
            destStudentDetailsViewController.lastviewindex=1;
            destStudentDetailsViewController.lastdayofweekindex=0;
            destStudentDetailsViewController.lastactivedraftindex_enrollment=0;
            destStudentDetailsViewController.lasttypeindex=0;
        }
        

    }
    
    
    
    if (destStudentDetailsViewController.lastviewindex==0) {
        if (destStudentDetailsViewController.systemMessageView.hidden) {
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [destStudentDetailsViewController retrieveStudent:studentkey];
            destStudentDetailsViewController.TopMenuView.hidden=NO;
            destStudentDetailsViewController.ViewStudent.hidden=NO;
            destStudentDetailsViewController.EnrollmentRecordView.hidden=YES;
            destStudentDetailsViewController.ClassRecordView.hidden=YES;
            destStudentDetailsViewController.EnrollmentClassMenuView.hidden=YES;
            destStudentDetailsViewController.MessageView.hidden=YES;
            destStudentDetailsViewController.SalesView.hidden=YES;
            destStudentDetailsViewController.CallLogView.hidden=YES;
            destStudentDetailsViewController.DTRecordView.hidden=YES;
            destStudentDetailsViewController.CouponView.hidden=YES;
            destStudentDetailsViewController.headertitlename.text=[MyClass returntitlewithtitle:@"Student Information"];
            [destStudentDetailsViewController createStudentViewNavigationButton];
            [destStudentDetailsViewController highlightduebuttonwithreloadstudentlist:NO];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
        
    }else if (destStudentDetailsViewController.lastviewindex==1){
        destStudentDetailsViewController.TopMenuView.hidden=NO;
        destStudentDetailsViewController.ViewStudent.hidden=YES;
        destStudentDetailsViewController.EnrollmentRecordView.hidden=NO;
        destStudentDetailsViewController.ClassRecordView.hidden=YES;
        destStudentDetailsViewController.EnrollmentClassMenuView.hidden=NO;
        destStudentDetailsViewController.MessageView.hidden=YES;
        destStudentDetailsViewController.SalesView.hidden=YES;
        destStudentDetailsViewController.CallLogView.hidden=YES;
        destStudentDetailsViewController.DTRecordView.hidden=YES;
        destStudentDetailsViewController.CouponView.hidden=YES;
        destStudentDetailsViewController.headertitlename.text=[MyClass returntitlewithtitle:@"Enrollment Information"];
        [destStudentDetailsViewController createEnrollmentViewNavigationButton];
        destStudentDetailsViewController.TypeSelectionButton.hidden=YES;
        destStudentDetailsViewController.typeselectionarrow.hidden=YES;
//        if (destStudentDetailsViewController.scactiveoption.numberOfSegments==3) {
//            [destStudentDetailsViewController.scactiveoption insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Due"] atIndex:3 animated:NO];
//            [destStudentDetailsViewController.scactiveoption insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Voided"] atIndex:4 animated:NO];
//            
//        }
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [destStudentDetailsViewController retrieveEnrollmentWithStudentkey:studentkey];
            [destStudentDetailsViewController highlightduebuttonwithreloadstudentlist:YES];
        });

        
    }else if (destStudentDetailsViewController.lastviewindex==2){
        
        destStudentDetailsViewController.TopMenuView.hidden=NO;
        destStudentDetailsViewController.ViewStudent.hidden=YES;
        destStudentDetailsViewController.EnrollmentRecordView.hidden=YES;
        destStudentDetailsViewController.ClassRecordView.hidden=NO;
        destStudentDetailsViewController.EnrollmentClassMenuView.hidden=NO;
        destStudentDetailsViewController.MessageView.hidden=YES;
        destStudentDetailsViewController.SalesView.hidden=YES;
        destStudentDetailsViewController.CallLogView.hidden=YES;
        destStudentDetailsViewController.DTRecordView.hidden=YES;
        destStudentDetailsViewController.CouponView.hidden=YES;
        destStudentDetailsViewController.headertitlename.text=[MyClass returntitlewithtitle:@"Class Information"];
        [destStudentDetailsViewController createClassViewNavigationButton];
        destStudentDetailsViewController.TypeSelectionButton.hidden=NO;
        destStudentDetailsViewController.typeselectionarrow.hidden=NO;
//        if (destStudentDetailsViewController.scactiveoption.numberOfSegments>3) {
//            [destStudentDetailsViewController.scactiveoption removeSegmentAtIndex:3 animated:NO];
//            [destStudentDetailsViewController.scactiveoption removeSegmentAtIndex:3 animated:NO];
//        }
        

        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [destStudentDetailsViewController retrieveClassWithEnrollmentkey:nil];
            selectedKeys.enrollmentkey=nil;
            [destStudentDetailsViewController highlightduebuttonwithreloadstudentlist:YES];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
        
        [destStudentDetailsViewController.DetailsViewClassTable addGestureRecognizer:destStudentDetailsViewController.panGesture];
        
    }else if (destStudentDetailsViewController.lastviewindex==3){
        destStudentDetailsViewController.TopMenuView.hidden=NO;
        destStudentDetailsViewController.ViewStudent.hidden=YES;
        destStudentDetailsViewController.EnrollmentRecordView.hidden=YES;
        destStudentDetailsViewController.ClassRecordView.hidden=YES;
        destStudentDetailsViewController.EnrollmentClassMenuView.hidden=YES;
        destStudentDetailsViewController.MessageView.hidden=YES;
        destStudentDetailsViewController.SalesView.hidden=NO;
        destStudentDetailsViewController.CallLogView.hidden=YES;
        destStudentDetailsViewController.DTRecordView.hidden=YES;
        destStudentDetailsViewController.CouponView.hidden=YES;
        destStudentDetailsViewController.headertitlename.text=[MyClass returntitlewithtitle:@"Sales Records"];


        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [destStudentDetailsViewController createSalesViewNavigationButton];
            [destStudentDetailsViewController retrieveSalesRecord];
            [destStudentDetailsViewController highlightduebuttonwithreloadstudentlist:YES];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
        
    }else if (destStudentDetailsViewController.lastviewindex==4){
        destStudentDetailsViewController.TopMenuView.hidden=NO;
        destStudentDetailsViewController.ViewStudent.hidden=YES;
        destStudentDetailsViewController.EnrollmentRecordView.hidden=YES;
        destStudentDetailsViewController.ClassRecordView.hidden=YES;
        destStudentDetailsViewController.EnrollmentClassMenuView.hidden=YES;
        destStudentDetailsViewController.MessageView.hidden=NO;
        destStudentDetailsViewController.SalesView.hidden=YES;
        destStudentDetailsViewController.CallLogView.hidden=YES;
        destStudentDetailsViewController.DTRecordView.hidden=YES;
        destStudentDetailsViewController.CouponView.hidden=YES;
        destStudentDetailsViewController.headertitlename.text=[MyClass returntitlewithtitle:@"Messages"];
        

        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [destStudentDetailsViewController createMessageViewNavigationButton];
            [destStudentDetailsViewController retrieveMessageRecord];
            [destStudentDetailsViewController highlightduebuttonwithreloadstudentlist:YES];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
        
    }else if (destStudentDetailsViewController.lastviewindex==5){
        destStudentDetailsViewController.TopMenuView.hidden=NO;
        destStudentDetailsViewController.ViewStudent.hidden=YES;
        destStudentDetailsViewController.EnrollmentRecordView.hidden=YES;
        destStudentDetailsViewController.ClassRecordView.hidden=YES;
        destStudentDetailsViewController.EnrollmentClassMenuView.hidden=YES;
        destStudentDetailsViewController.MessageView.hidden=YES;
        destStudentDetailsViewController.SalesView.hidden=YES;
        destStudentDetailsViewController.CallLogView.hidden=NO;
        destStudentDetailsViewController.DTRecordView.hidden=YES;
        destStudentDetailsViewController.CouponView.hidden=YES;
        destStudentDetailsViewController.headertitlename.text=[MyClass returntitlewithtitle:@"Call Log"];


        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [destStudentDetailsViewController createCallLogViewNavigationButton];
            [destStudentDetailsViewController retrieveCallLogRecord];
            [destStudentDetailsViewController highlightduebuttonwithreloadstudentlist:YES];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
        
    }else if (destStudentDetailsViewController.lastviewindex==6){
        destStudentDetailsViewController.TopMenuView.hidden=NO;
        destStudentDetailsViewController.ViewStudent.hidden=YES;
        destStudentDetailsViewController.EnrollmentRecordView.hidden=YES;
        destStudentDetailsViewController.ClassRecordView.hidden=YES;
        destStudentDetailsViewController.EnrollmentClassMenuView.hidden=YES;
        destStudentDetailsViewController.MessageView.hidden=YES;
        destStudentDetailsViewController.SalesView.hidden=YES;
        destStudentDetailsViewController.CallLogView.hidden=YES;
        destStudentDetailsViewController.DTRecordView.hidden=NO;
        destStudentDetailsViewController.CouponView.hidden=YES;
        destStudentDetailsViewController.headertitlename.text=[MyClass returntitlewithtitle:@"Trial/Assessment"];
        

        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [destStudentDetailsViewController createDTViewNavigationButton];
            [destStudentDetailsViewController retrieveDTrecords];
            [destStudentDetailsViewController highlightduebuttonwithreloadstudentlist:YES];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
        
    }else if (destStudentDetailsViewController.lastviewindex==7){
        destStudentDetailsViewController.TopMenuView.hidden=NO;
        destStudentDetailsViewController.ViewStudent.hidden=YES;
        destStudentDetailsViewController.EnrollmentRecordView.hidden=YES;
        destStudentDetailsViewController.ClassRecordView.hidden=YES;
        destStudentDetailsViewController.EnrollmentClassMenuView.hidden=YES;
        destStudentDetailsViewController.MessageView.hidden=YES;
        destStudentDetailsViewController.SalesView.hidden=YES;
        destStudentDetailsViewController.CallLogView.hidden=YES;
        destStudentDetailsViewController.DTRecordView.hidden=YES;
        destStudentDetailsViewController.CouponView.hidden=NO;
        destStudentDetailsViewController.headertitlename.text=[MyClass returntitlewithtitle:@"Coupon Records"];


        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [destStudentDetailsViewController createCouponViewNavigationButton];
            [destStudentDetailsViewController retrieveCouponRecord];
            [destStudentDetailsViewController highlightduebuttonwithreloadstudentlist:YES];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
        
    }
    
    laststudentkey=studentkey;
    
    return YES;
    
}

- (IBAction)addnewstudentbuttonpressed:(id)sender {

    destStudentDetailsViewController.studentAction=@"AddNewStudent";
    [destStudentDetailsViewController seguetostudenteditview];
    addNewStudentButton.enabled=NO;
    laststudentkey=nil;
    [studentlisttable reloadData];
    
}

- (IBAction)backbuttonpressed:(id)sender {
    [self.view endEditing:YES];
    [destStudentDetailsViewController stopAudioPlaying];
    [ailoadindicator startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        studentTableMode=@"category";
        [self showButton];
        [self editStudent:NO];
        [self updateCategoryCount];
        studentsearchbar.text=@"";
        [self changeStudentListWithCategory:@"All"];
        [ailoadindicator stopAnimating];
    });
}

- (IBAction)photoalbumbuttonpressed:(id)sender {
    [destStudentDetailsViewController stopAudioPlaying];
    [self.view endEditing:YES];
    
    [self changeStudentListWithCategory:@"Active"];

    studentimagepopover = (StudentImageGridViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"StudentImageGridViewController"];
    studentimagepopover.delegate=self;
    studentimagepopover.studentArray=filteredStudentArray;
    studentimagepopover.studentcategory=@"All";
    studentimagepopover.mode=@"single";
    
    studentimagepopover.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:studentimagepopover animated:YES completion: nil];
}

-(void) editStudent:(BOOL)editstudent
{
    if(editstudent){
        editStudentButtonView.tag=1;
        editStudentButtonView.hidden=YES;
        editStudentActionStack.hidden=NO;
        advanceSearchButtonView.hidden=YES;
        cancelEditStudentButtonView.hidden=NO;
        [studentlisttable reloadData];
    }else{
        [selectedStudentKeysArray removeAllObjects];
        editStudentButtonView.tag=0;
        editStudentButtonView.hidden=[studentTableMode isEqualToString:@"category"];
        editStudentActionStack.hidden=YES;
        advanceSearchButtonView.hidden=NO;

        cancelEditStudentButtonView.hidden=YES;
        [studentlisttable reloadData];
    }
}


- (IBAction)canceleditstudentbuttonpressed:(id)sender {
    [self editStudent:NO];
}

- (IBAction)editstudentbuttonpressed:(id)sender {
    [self editStudent:YES];
}

- (IBAction)advancedSearchButtonPressed:(id)sender {
    [destStudentDetailsViewController showAdvancedSearchWindow];
}

-(void) dismissAdvancedSearchWithLoading:(BOOL)loading
{
    if(loading){
        ailoadindicator.hidden=NO;
        [ailoadindicator startAnimating];
    }else{
        ailoadindicator.hidden=YES;
        [ailoadindicator stopAnimating];
    }
}

-(void) returnSearchResult:(NSMutableArray *)student_Array
{
    studentCategory=@"AdvancedSearch";
    studentTableMode=@"list";
    [backbutton setTitle:[MyClass returntitlewithtitle:@"Back"] forState:UIControlStateNormal];
    [self showButton];
    studentArray=[[NSMutableArray alloc]initWithArray:student_Array];
    [self returnfilteredstudentlistarray];
    [studentlisttable reloadData];
    [studentlisttable setContentOffset:CGPointZero animated:YES];
    
    [self->ailoadindicator stopAnimating];
    self->ailoadindicator.hidden=YES;
    
}


- (IBAction)sortingbuttonpressed:(id)sender {
    studentTableMode=@"sorting";
    studentlisttable.editing=YES;
    studentlisttable.scrollEnabled=NO;
    [self showButton];
    [studentlisttable reloadData];
    [destStudentDetailsViewController stopAudioPlaying];
    
}

-(void) EnrollLead:(Lead *)leadobject
{
    //NSLog(@"%@",dtobject.DTkey);
    destStudentDetailsViewController.studentAction=@"EnrollLead";
    destStudentDetailsViewController.DetailsViewLeadObject=leadobject;
    [destStudentDetailsViewController seguetostudenteditview];
    
}

-(void) EnrollATLeadStudent:(AssessmentTrialRecord *)atobject
{
    //NSLog(@"%@",dtobject.DTkey);

    
    if ([atobject.type isEqualToString:@"lead"]) {
        if ([atobject.studentkey isEqualToString:@""]) {
            destStudentDetailsViewController.studentAction=@"EnrollATLeadStudent";
            destStudentDetailsViewController.DetailsViewATObject=atobject;
            [destStudentDetailsViewController seguetostudenteditview];
        }else{
            destStudentDetailsViewController.studentAction=@"EnrollStudentSubject";
            destStudentDetailsViewController.DetailsViewATObject=atobject;
            destStudentDetailsViewController.DetailsViewStudent=[MyClass returnstudentwithstudentkey:atobject.studentkey];
            //destStudentDetailsViewController.DetailsViewStudentkey=atobject.studentkey;
        }
    }else{
        destStudentDetailsViewController.studentAction=@"EnrollStudentSubject";
        destStudentDetailsViewController.DetailsViewATObject=atobject;
        //destStudentDetailsViewController.DetailsViewStudentkey=atobject.studentkey;
        destStudentDetailsViewController.DetailsViewStudent=[MyClass returnstudentwithstudentkey:atobject.studentkey];
    }
}

-(void) AddStudentAndSubject:(ClassScheduleRecord *)classscheduleobject
{
    destStudentDetailsViewController.studentAction=@"AddStudentAndSubject";
    destStudentDetailsViewController.DetailsViewClassScheduleObject=classscheduleobject;
    [destStudentDetailsViewController seguetostudenteditview];
}

-(void) updateCategoryCount
{
    NSString *getDataURL;

    getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentcategorycount2&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
    //}
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:getDataURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            AllArray=[[NSMutableArray alloc]init];
            TypeArray=[[NSMutableArray alloc]init];
            SubjectArray=[[NSMutableArray alloc]init];
            DayArray=[[NSMutableArray alloc]init];
            StatusArray=[[NSMutableArray alloc]init];
            OthersArray=[[NSMutableArray alloc]init];
            GradeArray=[[NSMutableArray alloc]init];
            GenderArray=[[NSMutableArray alloc]init];
            NSMutableArray *tmpsubjectarray=[[NSMutableArray alloc]init];
            NSString *subjectnonecount;
            
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            jsonArray = jsonreturned[@"content"];
            
            for (long i=0; i<jsonArray.count; i++) {
                if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"all"]) {
                    [AllArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"type"]) {
                    [TypeArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"subject"]) {
                    //[SubjectArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                    if ([[[jsonArray objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"None"]) {
                        subjectnonecount=[[jsonArray objectAtIndex:i] objectForKey:@"count"];
                    }else{
                        [tmpsubjectarray addObject:[[SubjectRecord alloc]initSubjectRecordwithCenterkey:nil Subjectkey:nil Subject_Englishname:[MyClass returnsubjectnamewithsubject_shortname:[[jsonArray objectAtIndex:i] objectForKey:@"type"] centerkey:globalvariables.centerrecord.centerkey] Subject_Chinesename:nil Subject_shortname:[[jsonArray objectAtIndex:i] objectForKey:@"type"] Enrollmentmode:nil Tuition_method:nil Tuition_mode:nil Studentcapacity:nil StandardNoOfClassOrMonth:nil ClassDuration:nil ClassDurationAssessment:nil ClassDurationTrial:nil Status:nil LevelArray:nil TuitionArray:nil Remarks:[[jsonArray objectAtIndex:i] objectForKey:@"count"] ScheduleArray:nil Subject_Category:nil WeeklyAutoRenewDefault:NO validity:nil makeup_quota_unit:@"" makeup_quota_value:@"-1" leaveday_by_makeupschedule:NO leaveday_by_classdate:NO leaveday_follow_teacher:NO leaveday_by_enrolledschedule:NO leaveday_by_staffschedule:NO leaveday_follow_level:NO leaveday_follow_lesson:NO colorcode:0 fcsubject:nil lessonnumberDict:nil leaveday_follow_category:NO allowsameschedule:NO subject_fulldescription:nil subject_image:nil publishinchatbot:NO chatbot_category:nil chatbot_tag1:nil trial_by_existinglesson:NO trial_by_definedschedule:NO trialcapacity:nil chatbot_enabletrial:NO showmakeupbuttonifnotimeslot:NO btspromotioncode831:nil btspromotioncode1031:nil showabsentbuttononarrangeleave:NO pregenperiodcount:0 autolevelupgrade:nil]];
                    }
                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"day"]) {
                    [DayArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"status"]) {
                    [StatusArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"others"]) {
                    [OthersArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"grade"]) {
                    if ([[[jsonArray objectAtIndex:i] objectForKey:@"count"] intValue]>0) {
                        [GradeArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                    }
                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"gender"]) {
                    [GenderArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                }
            }
            
            //sort subject
            NSSortDescriptor *sortBySubjectname = [NSSortDescriptor sortDescriptorWithKey:[globalvariables.language isEqualToString:@"English"]?@"subject_englishname":@"subject_chinesename" ascending:YES selector:@selector(caseInsensitiveCompare:)];
            NSArray *sortdescriptors = @[sortBySubjectname];
            tmpsubjectarray = [NSMutableArray arrayWithArray:[tmpsubjectarray sortedArrayUsingDescriptors:sortdescriptors]];
            
            for (int i=0; i<tmpsubjectarray.count; i++) {
                [SubjectArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: ((SubjectRecord *)[tmpsubjectarray objectAtIndex:i]).subject_shortname Count: ((SubjectRecord *)[tmpsubjectarray objectAtIndex:i]).remarks]];
            }
            [SubjectArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType:@"None" Count:subjectnonecount]];
            

            
            //return YES;
        }
    }];
    
    if(result){
        //addStudentButton.enabled=YES;
        [ailoadindicator stopAnimating];
        
        [studentlisttable reloadData];
        
        studentlisttable.hidden=NO;
        lostconnectionview.hidden=YES;
    }else{
        if (!AllArray) {
            lostconnectionview.hidden=NO;
        }
        
        //[MyClass showconnectionlostdialogbox];
        [ailoadindicator stopAnimating];
    }
}

-(void) dismissstudentgridviewwithreload:(BOOL)reload
{
    [studentimagepopover dismissViewControllerAnimated:YES completion:nil];
}



-(void) updatestudentinformationlist:(NSString *)studentkey reloadlist:(BOOL)reload
{
    if (reload) {
        [MyClass getLatestDataSetv2withParameters:@"student" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
        [self changeStudentListWithCategory:studentCategory];
        [studentlisttable reloadData];
    }else{
        [studentlisttable reloadData];
    }
}

-(void) gobackStudentCategory
{
    //if (![studentTableMode isEqualToString:@"category"]) {
        studentTableMode=@"category";
    [self editStudent:NO];
        studentsearchbar.text=@"";
    studentlisttable.editing=NO;
        [self updateCategoryCount];
    [self changeStudentListWithCategory:@"All"];
    //}else{
        
    //}
    [self showButton];
    
}

-(void) enableAddStudentButton{
    addNewStudentButton.enabled=YES;

}

-(void) disableAddStudentButton{
    addNewStudentButton.enabled=NO;
    laststudentkey=nil;
    [studentlisttable reloadData];
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

- (void) refreshstudentdetailviewpresentingviewcontent
{
    //not required
}


-(void) updateSystemMessagewithNoStudentFound
{
    destStudentDetailsViewController.systemMessageLabel.text=[MyClass returntitlewithtitle:@"Select student or press + to add new"];
    [destStudentDetailsViewController showviewhistory:YES];
    //destStudentDetailsViewController.systemMessageLabel.frame=CGRectMake(0, 0, 570, 704);
    //destStudentDetailsViewController.ViewHistoryTableMasterView.hidden=NO;
    
    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student Profile"] message:[MyClass returntitlewithtitle:@"Selected student no longer exists"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [erroralert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [erroralert addAction:OKAction];
    [self presentViewController:erroralert animated:YES completion:nil];
}

-(void) refreshparentviewdocumentfoldercount
{
    //delegate not being used
}

-(void) resetstudentdetailviewlastviewindex
{
    destStudentDetailsViewController.lastviewindex=-1;  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([studentTableMode isEqualToString:@"category"]) {
        return 7;
    }else if ([studentTableMode isEqualToString:@"list"]){
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([studentTableMode isEqualToString:@"category"]) {
        if (section==0) {
            return 1;
        }else if (section==1){
            return 2;
        }else if (section==2){
            return StatusArray.count;
        }else if (section==3){
            return SubjectArray.count;
        }else if (section==4){
            return DayArray.count;
        }else if (section==5){
            return GradeArray.count;
        }else{// if (section==4){
            if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"eyelevelhq"]) {
                return 2;
            }
            return 1;
        }
    }else if ([studentTableMode isEqualToString:@"list"]){
        return filteredStudentArray.count;
    }else{
        if (section==0) {
            return sortingarray.count;
        }else{
            return 1;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([studentTableMode isEqualToString:@"category"]) {
        if (section==0) {
            return [MyClass returntitlewithtitle:@"All"];
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"Type"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"Status"];
        }else if (section==3){
            return [MyClass returntitlewithtitle:@"Subject"];
        }else if (section==4){
            return [MyClass returntitlewithtitle:@"Class Day"];
        }else if (section==5){
            return [MyClass returntitlewithtitle:@"Grade"];
        }else{// if (section==4){
            return [MyClass returntitlewithtitle:@"Others"];
        }
    }else if ([studentTableMode isEqualToString:@"sorting"]){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Sorting Order"];
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *headerTitle = [self tableView:tableView titleForHeaderInSection:section];
    
    if (headerTitle) {
        UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
        header.backgroundColor=[UIColor systemGroupedBackgroundColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 8, 200, 32)];
        label.text=[[MyClass returntitlewithtitle:headerTitle] uppercaseString];;
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor grayColor];
        [header addSubview:label];
        return header;
    }

    
    return nil;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell;
    if([studentTableMode isEqualToString:@"category"]){
        NSString *CellIdentifier= @"categorycell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.section==0) {
            categorycountobject=[AllArray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returntitlewithtitle:categorycountobject.type];
            cell.label2.text=categorycountobject.count;
            cell.label2.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showstudentcategorycount;
        }else if (indexPath.section==3){
            categorycountobject=[SubjectArray objectAtIndex:indexPath.row];
            cell.label1.text=[categorycountobject.type isEqualToString:@"None"]?[MyClass returntitlewithtitle:@"None"]:[MyClass returnsubjectnamewithsubject_shortname:categorycountobject.type centerkey:globalvariables.centerrecord.centerkey];
            cell.label2.text=categorycountobject.count;
            cell.label2.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showstudentcategorycount;
        }else if (indexPath.section==4){
            categorycountobject=[DayArray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returntitlewithtitle:categorycountobject.type];
            cell.label2.text=categorycountobject.count;
            cell.label2.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showstudentcategorycount;
        }else if (indexPath.section==2){
            categorycountobject=[StatusArray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returntitlewithtitle:categorycountobject.type];
            cell.label2.text=categorycountobject.count;
            cell.label2.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showstudentcategorycount;
        }else if (indexPath.section==1){
            categorycountobject=[TypeArray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returntitlewithtitle:categorycountobject.type];
            cell.label2.text=categorycountobject.count;
            cell.label2.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showstudentcategorycount;
        }else if (indexPath.section==5){
            categorycountobject=[GradeArray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returntitlewithtitle:categorycountobject.type];
            cell.label2.text=categorycountobject.count;
            cell.label2.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showstudentcategorycount;
        }else if (indexPath.section==6){
            categorycountobject=[OthersArray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returntitlewithtitle:categorycountobject.type];
            cell.label2.text=categorycountobject.count;
            cell.label2.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showstudentcategorycount;
        }
    }else if ([studentTableMode isEqualToString:@"list"]){
        //MyTableViewCell *cell;
        NSString *CellIdentifier= @"studentcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        // Configure the cell...
        
        Student * studentObject;
        studentObject = [filteredStudentArray objectAtIndex:indexPath.row];
        studentObject=[MyClass retrieveStudent:studentObject.studentkey];
        
        cell.label1.text=studentObject.displayfullname;// [MyClass returnStudentnameWithStudentkey:studentObject.studentkey option:@"fullbutid"];
        
        if ([studentObject.studentid isEqualToString:@""]) {
            cell.label2.hidden=YES;
        }else{
            cell.label2.hidden=NO;
            cell.label2.text=studentObject.studentid;
        }
        
        
        cell.imageview1.layer.cornerRadius=cell.imageview1.frame.size.width/2;
        cell.imageview1.layer.masksToBounds=YES;
        cell.imageview2.layer.cornerRadius=cell.imageview2.frame.size.width/2;
        cell.imageview2.layer.masksToBounds=YES;
        
        [MyClass downloadImageWithImageview:cell.imageview1 gender:studentObject.gender type:@"student" typekey:studentObject.studentkey image:studentObject.image async:YES];
        
        if([studentObject.due isEqualToString:@"B"]){
            [cell.imageview2 setImage:[UIImage imageNamed:@"redpurple.png"]];
        }else if([studentObject.due isEqualToString:@"C"]){
            [cell.imageview2 setImage:[UIImage imageNamed:@"red_background.png"]];
        }else if([studentObject.due isEqualToString:@"S"]){
            [cell.imageview2 setImage:[UIImage imageNamed:@"purple_background.png"]];
        }else{
            [cell.imageview2 setImage:nil];
        }
        
        cell.imageview3.hidden=editStudentActionStack.hidden;
        if([selectedStudentKeysArray containsObject:studentObject.studentkey]){
            cell.imageview3.layer.opacity=1.0;
        }else{
            cell.imageview3.layer.opacity=0.3;
        }
        
        if ([studentObject.studentkey isEqualToString:laststudentkey]) {
            cell.view1.hidden=NO;
        }else{
            cell.view1.hidden=YES;
        }
    }else if ([studentTableMode isEqualToString:@"sorting"]){
        if (indexPath.section==0) {
            NSString *CellIdentifier= @"sortingcell";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.label1.text=[MyClass returntitlewithtitle:((SortingRecord *)[sortingarray objectAtIndex:indexPath.row]).item];
            [cell.button1 addTarget:self action:@selector(changesortingorder:) forControlEvents:UIControlEventTouchUpInside];
            if ([((SortingRecord *)[sortingarray objectAtIndex:indexPath.row]).order isEqualToString:@"a"]){
                [cell.button1 setImage:[UIImage imageNamed:@"acending_icon.png"] forState:UIControlStateNormal];
            }else{
                [cell.button1 setImage:[UIImage imageNamed:@"decending_icon.png"] forState:UIControlStateNormal];
            }
        }else{
            NSString *CellIdentifier= @"sortingclose";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell.button1 setTitle:[MyClass returntitlewithtitle:@"Close"] forState:UIControlStateNormal];
            [cell.button1 addTarget:self action:@selector(closesortingtable) forControlEvents:UIControlEventTouchUpInside];
            
        }

    }

    //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void) changesortingorder:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:studentlisttable];
    NSIndexPath *indexpath =[studentlisttable indexPathForRowAtPoint:point];
    
    if ([((SortingRecord *)[sortingarray objectAtIndex:indexpath.row]).order isEqualToString:@"a"]){
        ((SortingRecord *)[sortingarray objectAtIndex:indexpath.row]).order=@"d";
    }else{
        ((SortingRecord *)[sortingarray objectAtIndex:indexpath.row]).order=@"a";
    }
    [self updatesortingstring];
    filteredStudentArray=[MyClass sortstudentlistwithstudentarray:filteredStudentArray sortingarray:sortingarray];
    [studentlisttable reloadData];
    
    
}


-(void) showButton
{
    BOOL addnewstudent=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).addnewstudent;
    if ([studentTableMode isEqualToString:@"category"]) {
        backbuttonstack.hidden=YES;
        menubutton.hidden=NO;
        addNewStudentButton.enabled=addnewstudent;
        photoalbumbutton.hidden=NO;
        sortingbutton.hidden=YES;
        editStudentButtonView.hidden=YES;
    }else if ([studentTableMode isEqualToString:@"list"]){
        backbuttonstack.hidden=NO;
        menubutton.hidden=YES;
        addNewStudentButton.enabled=addnewstudent;
        photoalbumbutton.hidden=YES;
        sortingbutton.hidden=NO;
        editStudentButtonView.hidden=NO;
    }else if ([studentTableMode isEqualToString:@"sorting"]){
        backbuttonstack.hidden=YES;
        menubutton.hidden=YES;
        addNewStudentButton.enabled=NO;
        photoalbumbutton.hidden=YES;
        sortingbutton.hidden=NO;
        editStudentButtonView.hidden=YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([studentTableMode isEqualToString:@"category"]) {

        tableView.userInteractionEnabled=FALSE;
        if (indexPath.section==0) {
            categorycountobject=[AllArray objectAtIndex:indexPath.row];
        }else if (indexPath.section==3){
            categorycountobject=[SubjectArray objectAtIndex:indexPath.row];
        }else if (indexPath.section==4){
            categorycountobject=[DayArray objectAtIndex:indexPath.row];
        }else if (indexPath.section==2){
            categorycountobject=[StatusArray objectAtIndex:indexPath.row];
        }else if (indexPath.section==1){
            categorycountobject=[TypeArray objectAtIndex:indexPath.row];
        }else if (indexPath.section==5){
            categorycountobject=[GradeArray objectAtIndex:indexPath.row];
        }else if (indexPath.section==6){
            categorycountobject=[OthersArray objectAtIndex:indexPath.row];
        }
        
        if (categorycountobject.type) {
            studentTableMode=@"list";
            [self showButton];
            studentCategory=categorycountobject.type;
            [backbutton setTitle:[MyClass returntitlewithtitle:categorycountobject.type?categorycountobject.type:@"All"] forState:UIControlStateNormal];
            [ailoadindicator startAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self retrieveDataWithStudentCategory:studentCategory];
            });
        }
    }else{
        //backbuttonstack.hidden=YES;
        //menubutton.hidden=NO;
        
        Student *object = [filteredStudentArray objectAtIndex:indexPath.row];
        [self.view endEditing:YES];
        
        if (editStudentActionStack.hidden) {
            if ([self passStudentkeytoStudentInformation:object.studentkey studentcategory:studentCategory]) {
                lastindexpath=indexPath;
                [MyClass insertViewHistoryWithType:@"student" Typekey:object.studentkey Name:@"" IDNumber:@"" Gender:@""];
                [studentlisttable reloadData];
            }else{
                [tableView selectRowAtIndexPath:lastindexpath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
        }else{
            if ([selectedStudentKeysArray containsObject:object.studentkey]) {
                [selectedStudentKeysArray removeObject:object.studentkey];
            }else{
                [selectedStudentKeysArray addObject:object.studentkey];
            }
            [studentlisttable reloadData];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([studentTableMode isEqualToString:@"category"]) {
        /*if (indexPath.section==2 || indexPath.section==4) {
            if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
                return CGFLOAT_MIN;
            }
        }*/
        return UITableViewAutomaticDimension;
    }else{
        return UITableViewAutomaticDimension;
    }
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([studentTableMode isEqualToString:@"category"]) {
        if (section==2 || section==4) {
            if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
                return CGFLOAT_MIN;
            }
        }
        return 35;
    }else if ([studentTableMode isEqualToString:@"sorting"]){
        return 40;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}


-(BOOL) retrieveDataWithStudentCategory:(NSString *)StudentCategory
{
    if (!globalvariables) {
        globalvariables=[GlobalVariables singleObj];
    }
    
    [MyClass getLatestDataSetv2withParameters:@"student" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    
    __block BOOL result=FALSE;
    if(StudentCategory){
        NSString *getDataURL;


            if ([StudentCategory isEqualToString:@"All"]) {
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&status=All&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Nursery"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&grade=Nursery&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Kindergarten"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&grade=Kindergarten&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Primary"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&grade=Primary&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Secondary"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&grade=Secondary&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Others"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&grade=Others&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"None"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&subject=None&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Monday"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&classday=Mon&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Tuesday"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&classday=Tue&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Wednesday"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&classday=Wed&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Thursday"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&classday=Thu&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Friday"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&classday=Fri&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Saturday"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&classday=Sat&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Sunday"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&classday=Sun&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Multi"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&classday=Multi&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Current Class"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&status=CurrentClass&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Future Class"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&status=FutureClass&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"No Class (Non Dropped)"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&status=NoClassND&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"No Class (All Dropped)"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&status=NoClassAD&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"TBD Class Left Only"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&status=TBDClassLeftOnly&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Flagged"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&status=Flagged&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Suspended"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&status=Suspended&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Active"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&status=Active&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Draft"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&status=Draft&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else if ([StudentCategory isEqualToString:@"Skipped"]){
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&status=Skipped&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],globalvariables.username];
            }else{
                getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectstudentlist2&subject=%@&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewstudentprofile"],[MyClass enurlstring:StudentCategory],globalvariables.username];
            }

        
        [MyClass callGETwithURL:getDataURL completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result = TRUE;
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                NSDictionary *jsondictionary = jsonreturned[@"content"];
                NSArray *jsonstudentarray = jsondictionary[@"studentrecords"];
                
                //Set up our student array
                studentArray=[[NSMutableArray alloc] init];
                
                //loop through our jsonArray
                for (int i=0; i<jsonstudentarray.count; i++) {
                    
                    //Create our student object
                    NSString * sstudentkey=[[jsonstudentarray objectAtIndex:i] objectForKey:@"studentkey"];
                    [studentArray addObject:[MyClass returnstudentwithstudentkey:sstudentkey]];
                }
            }
        }];
    }else{
        result=TRUE;
        //reload studentArray
        for (int i=0; i<studentArray.count; i++) {
            NSString *sstudentkey=((Student *)[studentArray objectAtIndex:i]).studentkey;
            if (sstudentkey) {
                Student *obj=[MyClass returnstudentwithstudentkey:sstudentkey];
                [studentArray replaceObjectAtIndex:i withObject:obj];
            }
        }
    }
    
    

        
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        [self returnfilteredstudentlistarray];
        
        //Reload our student view
        [studentlisttable reloadData];
        [ailoadindicator stopAnimating];
        studentlisttable.userInteractionEnabled=TRUE;
    }else{
        [ailoadindicator stopAnimating];
        studentlisttable.userInteractionEnabled=TRUE;
    }
    
    return result;
        
}



-(void) dismissstudentgridview
{
    [studentimagepopover dismissViewControllerAnimated:YES completion:nil];
}

-(void) passstudentfromgrid:(NSString *)studentkey
{
    studentCategory=@"All";
    //[self changeStudentListWithCategory:@"Active"];
    studentTableMode=@"list";
    
    [self showButton];
    [backbutton setTitle:[MyClass returntitlewithtitle:studentCategory] forState:UIControlStateNormal];
    [studentlisttable reloadData];
    
    [studentimagepopover dismissViewControllerAnimated:YES completion:nil];
    
    //scroll to the selected student
    long gotorow=0;
    Student *studentobject=[MyClass returnstudentwithstudentkey:studentkey];
    if ([filteredStudentArray containsObject:studentobject]) {
        gotorow=[filteredStudentArray indexOfObject:studentobject];
    }
    
    [studentlisttable selectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self tableView:studentlisttable didSelectRowAtIndexPath:[studentlisttable indexPathForSelectedRow]];
}

-(void) passstudentarrayfromgrid:(NSMutableArray *)studentarray
{
    //not used
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([studentTableMode isEqualToString:@"sorting"]) {
        if (indexPath.section==0) {
            return YES;
        }
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


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    //do whatever u want after row has been moved
    if (toIndexPath.section==0 && (fromIndexPath.row !=toIndexPath.row)) {
        sortingobject=[sortingarray objectAtIndex:fromIndexPath.row];
        [sortingarray removeObjectAtIndex:fromIndexPath.row];
        [sortingarray insertObject:sortingobject atIndex:toIndexPath.row];
        
        [self updatesortingstring];
        filteredStudentArray=[MyClass sortstudentlistwithstudentarray:filteredStudentArray sortingarray:sortingarray];
        
    }
}

-(void) updatesortingstring
{
    [destStudentDetailsViewController stopAudioPlaying];
    NSString *sortingstring=@"";
    
    for (int i=0; i<sortingarray.count; i++) {
        if (i==0) {
            sortingstring=[NSString stringWithFormat:@"%@#%@",((SortingRecord *)[sortingarray objectAtIndex:i]).order,((SortingRecord *)[sortingarray objectAtIndex:i]).item];
        }else{
            sortingstring=[NSString stringWithFormat:@"%@,%@#%@",sortingstring,((SortingRecord *)[sortingarray objectAtIndex:i]).order,((SortingRecord *)[sortingarray objectAtIndex:i]).item];
        }
    }
    [MyClass updateUserAccountSettingsWithField:@"studentlistsortingorder" Value:sortingstring];
    //[MyClass updatelocaldbwithparameter:@"studentlistsortingorder" value:sortingstring];
}

-(void) closesortingtable
{
    [destStudentDetailsViewController stopAudioPlaying];
    studentlisttable.editing=NO;
    studentlisttable.scrollEnabled=YES;
    studentTableMode=@"list";
    [studentlisttable reloadData];
    
    if (laststudentkey) {
        long gotorow=[self returnStudentIndexWithStudent:[MyClass returnstudentwithstudentkey:laststudentkey]];
        if (gotorow>=0) {
            [studentlisttable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
    [self showButton];
}



- (IBAction)editstudentactionbuttonpressed:(UIButton *)sender {
    if(selectedStudentKeysArray.count==0){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Action"] message:[MyClass returntitlewithtitle:@"Please select student first"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else{
        NSMutableArray *actionarray=[[NSMutableArray alloc]init];
        if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).issuecoupon){
            [actionarray addObject:@"Issue Coupon"];
        }
        
        if(globalvariables.centerrecord.enablemembershippoint && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).issuepoint){
            [actionarray addObject:@"Issue Point"];
        }
        
        if(actionarray.count>0){
            [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"studentaction" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, actionarray.count*44) View:self Button:sender ItemsArray:actionarray Title:nil];
        }
    }
}

- (IBAction)editstudentclearallbuttonpressed:(id)sender {
    [selectedStudentKeysArray removeAllObjects];
    [studentlisttable reloadData];
}

- (IBAction)editstudentselectallbuttonpressed:(id)sender {
    [selectedStudentKeysArray removeAllObjects];
    for (int i=0; i<filteredStudentArray.count; i++) {
        Student *object=[filteredStudentArray objectAtIndex:i];
        [selectedStudentKeysArray addObject:object.studentkey];
    }
    [studentlisttable reloadData];
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if([datatype isEqualToString:@"studentaction"]){
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"Issue Coupon"]) {
            [destStudentDetailsViewController issueCouponToStudents:[[NSMutableArray alloc]initWithArray:selectedStudentKeysArray]];
        }else if ([result isEqualToString:@"Issue Point"]){
            [destStudentDetailsViewController issuePointToStudents:[[NSMutableArray alloc]initWithArray:selectedStudentKeysArray] multipleStudents:YES];
        }
    }
}

-(void) dismissEditStudentView
{
    [self editStudent:NO];
}
@end
