//
//  LeadInformationViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 17/5/15.
//  Copyright (c) 2015 DreamHigh Company Limited. All rights reserved.
//

#import "LeadInformationViewController.h"
#import "LeadDetailsViewController.h"
#import "MainMenuViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MyClass.h"
#import "MainViewController.h"
#import "MyTableViewCell.h"

@interface LeadInformationViewController ()

@end

@implementation LeadInformationViewController
@synthesize LeadDetailsContainerView;
@synthesize destLeadDetailsViewController;
@synthesize InformationViewLead,LeadInformationAction;



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
    
    topleftview.backgroundColor = [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:0.8];
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(240, 68, .5, self.view.bounds.size.height-68)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checktoreloadapp) name:UIApplicationWillEnterForegroundNotification object:nil];
    
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
        sortingarray=[MyClass returnsortingarraywithtype:@"leadlistsortingorder"];
    }
    
    leadlisttable.editing=NO;
    leadlisttable.scrollEnabled=YES;
    leadTableMode=@"category";
    leadCategory=@"All";
    [self showButton];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    //tablerefresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [tablerefresh addTarget:self action:@selector(refreshtable) forControlEvents:UIControlEventValueChanged];
    [leadlisttable addSubview:tablerefresh];
    leadlisttable.hidden=YES;
    
    leadsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    
    runviewdidappear=TRUE;
    
}

-(void) donotrunviewdidappearinleadinformation
{
    runviewdidappear=FALSE;
}

-(void) refreshtable
{
    [MyClass getLatestDataSetv2withParameters:@"lead" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    [self updateCategoryCount];
    //[self.tableView reloadData];
    [tablerefresh endRefreshing];
}

-(void) showButton
{
    if ([leadTableMode isEqualToString:@"category"]) {
        backbuttonstack.hidden=YES;
        menubutton.hidden=NO;
        //addNewStudentButton.hidden=NO;
        addNewLeadButton.enabled=YES;
        photoalbumbutton.hidden=NO;
        sortingbutton.hidden=YES;
    }else if ([leadTableMode isEqualToString:@"list"]){
        backbuttonstack.hidden=NO;
        menubutton.hidden=YES;
        //addNewStudentButton.hidden=NO;
        addNewLeadButton.enabled=YES;
        photoalbumbutton.hidden=YES;
        sortingbutton.hidden=NO;
    }else if ([leadTableMode isEqualToString:@"sorting"]){
        backbuttonstack.hidden=YES;
        menubutton.hidden=YES;
        addNewLeadButton.enabled=NO;
        photoalbumbutton.hidden=YES;
        sortingbutton.hidden=NO;
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.mainSlideMenu disableSlidePanGestureForRightMenu];


    globalvariables=[GlobalVariables singleObj];
    globalvariables.lastviewcontroller=(NSString *)self;
    
    if(runviewdidappear){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateCategoryCount];
        [self changeLeadListWithCategory:@"All"];
        
        if (Leadkey && ![Leadkey isEqualToString:@""]) {
            LeadInformationAction=@"";
            [self gotoLeadProfilewithLeadkey:Leadkey submenu:Submenu classkeys:selectedKeys];
        }
        });
    }else{
        runviewdidappear=TRUE;
    }


    
    //LeadCategoryContainerView.frame=CGRectMake(0, 0, 220, self.view.bounds.size.height);
    //LeadDetailsContainerView.frame=CGRectMake(220, 0, self.view.bounds.size.width-240, self.view.bounds.size.height);
    //destLeadDetailsViewController.preferredContentSize=LeadDetailsContainerView.frame.size;
    
    //[self performSelector:@selector(updateCategoryCount) withObject:nil afterDelay:0];
    
}

-(void) checktoreloadapp
{
    
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {
        if ([destLeadDetailsViewController.myPopoverController presentingViewController].isBeingPresented) {
            [[destLeadDetailsViewController.myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destLeadDetailsViewController.destleadeditviewcontroller.mypopovercontroller presentingViewController].isBeingPresented){
            [[destLeadDetailsViewController.destleadeditviewcontroller.mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destLeadDetailsViewController.myCallLogSelectionPopoverController presentingViewController].isBeingPresented){
            [[destLeadDetailsViewController.myCallLogSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destLeadDetailsViewController.myDTSelectionPopoverController presentingViewController].isBeingPresented){
            [[destLeadDetailsViewController.myDTSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==leadimagepopover){
              [leadimagepopover dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.mainSlideMenu closeLeftMenu];
        }
        globalvariables.appbecomeactiveaction=@"";
        globalvariables.leftmenuindex=@"0";
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [MyClass reloadApp];
    }else if ([globalvariables.appbecomeactiveaction isEqualToString:@"refresh"]) {
        globalvariables.appbecomeactiveaction=@"";
        
        
        
        if ([destLeadDetailsViewController.myPopoverController presentingViewController].isBeingPresented) {
            [[destLeadDetailsViewController.myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destLeadDetailsViewController.destleadeditviewcontroller.mypopovercontroller presentingViewController].isBeingPresented){
            [[destLeadDetailsViewController.destleadeditviewcontroller.mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destLeadDetailsViewController.myCallLogSelectionPopoverController presentingViewController].isBeingPresented){
            [[destLeadDetailsViewController.myCallLogSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([destLeadDetailsViewController.myDTSelectionPopoverController presentingViewController].isBeingPresented){
            [[destLeadDetailsViewController.myDTSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==leadimagepopover){
            [leadimagepopover dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.mainSlideMenu closeLeftMenu];
        }
        [destLeadDetailsViewController closesidewindow];
        [destLeadDetailsViewController reloadPageWithFirstLoad:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"toLeadDetailsView"]) {
        destLeadDetailsViewController= [[[segue destinationViewController]viewControllers] objectAtIndex:0];
        destLeadDetailsViewController.delegate=self;
        destLeadDetailsViewController.selectedDTkey=DTkey;
        destLeadDetailsViewController.leadAction=LeadInformationAction;
        destLeadDetailsViewController.lastviewindex=-1;
    }
    
    /*if([segue.identifier isEqualToString:@"toLeadListCategory"]){
        destLeadCategoryViewController = [[[segue destinationViewController]viewControllers] objectAtIndex:0];
        destLeadCategoryViewController.delegate=self;
        destLeadCategoryViewController.Leadkey=Leadkey;
    }*/
}

-(void) passSystemMessage:(NSString *)systemmessage
{
    destLeadDetailsViewController.systemMessageLabel.text=systemmessage;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [destLeadDetailsViewController stopAudioPlaying];
    if([leadTableMode isEqualToString:@"category"]){
        //[self changeLeadListWithCategory:@"All"];
        leadTableMode=@"list";
        [backbutton setTitle:[MyClass returntitlewithtitle:@"All"] forState:UIControlStateNormal];
    }
    [self showButton];
    
    
    [self returnfilteredleadlistarray];
    [leadlisttable reloadData];
    [leadlisttable setContentOffset:CGPointZero animated:YES];
    
}

- (void)updateleadsearchbar{
    //if ([leadTableMode isEqualToString:@"category"]) {
    //[self changeLeadListWithCategory:@"All"];
    //}
    
    leadTableMode=@"list";
    [self returnfilteredleadlistarray];
    [leadlisttable reloadData];
    [self showButton];
}

-(void) returnfilteredleadlistarray
{
    if (!leadsearchbar || [leadsearchbar.text isEqualToString:@""]) {
        filteredLeadArray= [NSMutableArray arrayWithArray:leadArray];
    }else{
        //[filteredLeadArray removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.leadkey contains[c] %@ or SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or self.othername contains[c] %@ or self.parentcontact contains[c] %@ or self.leadid contains[c] %@ or self.remarks contains[c] %@ or self.grade contains[c] %@ or self.school contains[c] %@ or self.parentemail contains[c] %@ or self.parentaddress contains[c] %@",leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text,leadsearchbar.text];
        filteredLeadArray= [NSMutableArray arrayWithArray:[leadArray filteredArrayUsingPredicate:predicate]];
    }
    filteredLeadArray=[MyClass sortleadlistwithleadarray:filteredLeadArray sortingarray:sortingarray];
}

-(NSInteger) returnLeadIndexWithLead:(Lead *)lead
{
    for (int i=0; i<filteredLeadArray.count; i++) {
        if ([((Lead *)[filteredLeadArray objectAtIndex:i]).leadkey isEqualToString:lead.leadkey]) {
            return i;
        }
    }
    return -1;
}

-(void) gotoLeadProfilewithLeadkey:(NSString *)leadkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys;
{
    Leadkey=leadkey;
    Submenu=submenu;
    selectedKeys=classkeys;
    
    if(![LeadInformationAction isEqualToString:@"Redirect"]){

        
        if (![leadTableMode isEqualToString:@"list"]) {
            [self updateleadsearchbar];
            [backbutton setTitle:[MyClass returntitlewithtitle:@"All"] forState:UIControlStateNormal];
        }
        
        //clear search
        if (![leadsearchbar.text isEqualToString:@""]) {
            leadsearchbar.text=@"";
            [self returnfilteredleadlistarray];
            [leadlisttable reloadData];
        }
        
        
        //scroll to the selected student
        leadobject=[MyClass returnleadwithleadkey:leadkey];
        long gotorow=[self returnLeadIndexWithLead:leadobject];
        
        
        // change to all folder
        if (gotorow<0) {
            if (![leadCategory isEqualToString:@"All"]) {
                leadCategory=@"All";
                [self changeLeadListWithCategory:leadCategory];
                if ([filteredLeadArray containsObject:leadobject]) {
                    gotorow=[filteredLeadArray indexOfObject:leadobject];
                }
                [backbutton setTitle:[MyClass returntitlewithtitle:@"All"] forState:UIControlStateNormal];
            }
        }
        
        if (gotorow>=0) {
            lastleadkey=leadkey;
            
            [self tableView:leadlisttable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0]];
            //[leadlisttable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0]  atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
            [leadlisttable selectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        }else{
            [MyClass removeViewHistoryWithType:@"lead" Typekey:leadkey];
            [self passSystemMessage:@"Lead no longer exists"];
        }
        //[self.delegate passLeadkey:leadkey leadcategory:LeadCategory];
        [self showButton];
    }
    

}

-(void) changeLeadListWithCategory:(NSString *)category
{
    leadCategory=category;
    if([category isEqualToString:@"All"]){
        leadArray=[[NSMutableArray alloc]initWithArray:[globalvariables.leadlistarray allValues]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@",globalvariables.centerrecord.centerkey];
        leadArray=[[NSMutableArray alloc]initWithArray:[leadArray filteredArrayUsingPredicate:predicate]];
    }
    [self returnfilteredleadlistarray];
    [leadlisttable reloadData];
}

-(BOOL) passLeadkeytoLeadInformation:(NSString *)leadkey leadcategory:(NSString *)leadcategory
{
    
    /*if (destLeadCategoryViewController.navigationController !=nil) {
        [destLeadDetailsViewController.navigationController popToRootViewControllerAnimated:NO];
    }*/
    
    
    destLeadDetailsViewController.DetailsViewLead=[[Lead alloc]init];
    destLeadDetailsViewController.DetailsViewLead.leadkey=leadkey;
    //[destLeadDetailsViewController retrieveLead:Leadkey];
    
    //destLeadDetailsViewController.subjectselected=@"All";
    //[destLeadDetailsViewController.ClassSelectionButton setTitle:@"All Classes" forState:UIControlStateNormal];
    
    //destLeadDetailsViewController.sctableoption.selectedSegmentIndex=0;
    //destLeadDetailsViewController.lastviewindex=0;
    //[destLeadDetailsViewController highlighttableoptionbuttonwithbuttontag:0];
    
    
    
    //destLeadDetailsViewController.leadAction=@"ViewLead";
    [destLeadDetailsViewController showviewhistory:FALSE];
    
    
    /*if ([leadcategory isEqualToString:@"All"] || [leadcategory isEqualToString:@"Male"] || [leadcategory isEqualToString:@"Female"]|| [leadcategory isEqualToString:@"Nursery"]||[leadcategory isEqualToString:@"Kindergarten"]||[leadcategory isEqualToString:@"Primary"]||[leadcategory isEqualToString:@"Secondary"]) {

        if (destLeadDetailsViewController.lastviewindex<0) {
            
            [destLeadDetailsViewController highlighttableoptionbuttonwithbuttontag:0];
            destLeadDetailsViewController.lastviewindex=0;
        }
    }else if([leadcategory isEqualToString:@"Flagged"]){
        if (destLeadDetailsViewController.lastviewindex<0) {

            [destLeadDetailsViewController highlighttableoptionbuttonwithbuttontag:0];
            destLeadDetailsViewController.lastviewindex=0;
        }
    }else{*/
        if (destLeadDetailsViewController.lastviewindex<0) {
            
            [destLeadDetailsViewController highlighttableoptionbuttonwithbuttontag:0];
            destLeadDetailsViewController.lastviewindex=0;
        }
    //}

    
    if (destLeadDetailsViewController.lastviewindex==0) {
        if (destLeadDetailsViewController.systemMessageView.hidden) {
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [destLeadDetailsViewController retrieveLead:leadkey];
            destLeadDetailsViewController.TopMenuView.hidden=NO;
            destLeadDetailsViewController.ViewLead.hidden=NO;
            destLeadDetailsViewController.DTRecordView.hidden=YES;
            destLeadDetailsViewController.MessageView.hidden=YES;
            destLeadDetailsViewController.CallLogView.hidden=YES;
//            destLeadDetailsViewController.navigationItem.title=[MyClass returntitlewithtitle:@"Lead Information"];
            [destLeadDetailsViewController createLeadViewNavigationButton];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
        
    }else if (destLeadDetailsViewController.lastviewindex==3) {
        destLeadDetailsViewController.TopMenuView.hidden=NO;
        destLeadDetailsViewController.ViewLead.hidden=YES;
        destLeadDetailsViewController.MessageView.hidden=YES;
        destLeadDetailsViewController.CallLogView.hidden=YES;
        destLeadDetailsViewController.DTRecordView.hidden=NO;
//        destLeadDetailsViewController.navigationItem.title=[MyClass returntitlewithtitle:@"Trial/Assessment"];

        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [destLeadDetailsViewController createDTViewNavigationButton];
            [destLeadDetailsViewController retrieveDTrecords];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }else if (destLeadDetailsViewController.lastviewindex==1) {
        destLeadDetailsViewController.TopMenuView.hidden=NO;
        destLeadDetailsViewController.ViewLead.hidden=YES;
        destLeadDetailsViewController.MessageView.hidden=NO;
        destLeadDetailsViewController.CallLogView.hidden=YES;
        destLeadDetailsViewController.DTRecordView.hidden=YES;
//        destLeadDetailsViewController.navigationItem.title=[MyClass returntitlewithtitle:@"Messages"];
        
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [destLeadDetailsViewController createMessageViewNavigationButton];
            [destLeadDetailsViewController retrieveMessageRecord];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }else if (destLeadDetailsViewController.lastviewindex==2) {
        destLeadDetailsViewController.TopMenuView.hidden=NO;
        destLeadDetailsViewController.ViewLead.hidden=YES;
        destLeadDetailsViewController.MessageView.hidden=YES;
        destLeadDetailsViewController.CallLogView.hidden=NO;
        destLeadDetailsViewController.DTRecordView.hidden=YES;
//        destLeadDetailsViewController.navigationItem.title=[MyClass returntitlewithtitle:@"Call Log"];
        
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [destLeadDetailsViewController createCallLogViewNavigationButton];
            [destLeadDetailsViewController retrieveCallLogRecord];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }
    lastleadkey=leadkey;
    
    return YES;
    
}

/*-(void) addNewLead
{
    destLeadDetailsViewController.leadAction=@"AddNewLead";
    [destLeadDetailsViewController seguetoleadeditview];
    
}*/

- (IBAction)addnewleadbuttonpressed:(id)sender {
    
    destLeadDetailsViewController.leadAction=@"AddNewLead";
    [destLeadDetailsViewController seguetoleadeditview];
    addNewLeadButton.enabled=NO;
    lastleadkey=nil;
    [leadlisttable reloadData];
    
}

-(void) addDTLead:(DTRecord *)dtobject
{
    //NSLog(@"%@",dtobject.DTkey);
    destLeadDetailsViewController.leadAction=@"AddDTLead";
    destLeadDetailsViewController.DetailsViewDTObject=dtobject;
    [destLeadDetailsViewController seguetoleadeditview];
    addNewLeadButton.enabled=NO;
    lastleadkey=nil;
    [leadlisttable reloadData];
    
}

-(void) updateCategoryCount
{
    NSString *getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadcategorycount",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:getDataURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            AllArray=[[NSMutableArray alloc]init];
            GenderArray=[[NSMutableArray alloc]init];
            GradeArray=[[NSMutableArray alloc]init];
            StatusArray=[[NSMutableArray alloc]init];
            OtherArray=[[NSMutableArray alloc]init];
            SourceArray=[[NSMutableArray alloc]init];
            
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            jsonArray = jsonreturned[@"content"];
            
            for (long i=0; i<jsonArray.count; i++) {
                if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"all"]) {
                    [AllArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"gender"]) {
                    [GenderArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"grade"]) {
                    if ([[[jsonArray objectAtIndex:i] objectForKey:@"count"] intValue]>0) {
                        [GradeArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                    }
                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"status"]) {
                    [StatusArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"other"]) {
                    [OtherArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"source"]) {
                    [SourceArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
                }
            }
        }
    }];
    
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    NSURLSession *session = [NSURLSession sharedSession];
//    [[session dataTaskWithURL:[NSURL URLWithString:[getDataURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        // handle response
//        
//        if (!error) {
//            result=TRUE;
//            AllArray=[[NSMutableArray alloc]init];
//            GenderArray=[[NSMutableArray alloc]init];
//            GradeArray=[[NSMutableArray alloc]init];
//            StatusArray=[[NSMutableArray alloc]init];
//            OtherArray=[[NSMutableArray alloc]init];
//            SourceArray=[[NSMutableArray alloc]init];
//            
//            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
//            jsonArray = jsonreturned[@"content"];
//            
//            for (long i=0; i<jsonArray.count; i++) {
//                if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"all"]) {
//                    [AllArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
//                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"gender"]) {
//                    [GenderArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
//                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"grade"]) {
//                    if ([[[jsonArray objectAtIndex:i] objectForKey:@"count"] intValue]>0) {
//                        [GradeArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
//                    }
//                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"status"]) {
//                    [StatusArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
//                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"other"]) {
//                    [OtherArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
//                }else if ([[[jsonArray objectAtIndex:i] objectForKey:@"category"] isEqualToString:@"source"]) {
//                    [SourceArray addObject:[[CategoryCountRecord alloc]initCategoryCountRecordwithType: [[jsonArray objectAtIndex:i] objectForKey:@"type"] Count: [[jsonArray objectAtIndex:i] objectForKey:@"count"]]];
//                }
//            }
//        }
//        
//        dispatch_semaphore_signal(semaphore);
//    }] resume];
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (result) {
        addNewLeadButton.enabled=YES;
        [ailoadindicator stopAnimating];
        [leadlisttable reloadData];
        leadlisttable.hidden=NO;
        lostconnectionview.hidden=YES;
    }else{
        if (!AllArray) {
            lostconnectionview.hidden=NO;
        }
        
        //[MyClass showconnectionlostdialogbox];
        [ailoadindicator stopAnimating];
    }
}

-(void) updateleadinformationlist:(NSString *)leadkey
{
    [self retrieveDataWithLeadCategory:leadCategory];
    //[destLeadCategoryViewController updateleadinformationlist:(NSString *)leadkey];
}

-(void) gobackLeadCategory
{
    //if (![leadTableMode isEqualToString:@"category"]) {
        leadTableMode=@"category";
        leadsearchbar.text=@"";
    leadlisttable.editing=NO;
        [self updateCategoryCount];
    [self changeLeadListWithCategory:@"All"];
    //}
    [self showButton];
    
}

-(void) enableAddLeadButton{
    addNewLeadButton.enabled=YES;
}

-(void) disableAddLeadButton{
    addNewLeadButton.enabled=NO;
    lastleadkey=nil;
    [leadlisttable reloadData];
}


- (IBAction)menubuttonpressed:(id)sender {
    [destLeadDetailsViewController stopAudioPlaying];
    [self.mainSlideMenu openLeftMenu];
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

- (void) refreshleaddetailviewpresentingviewcontent
{
    //not required
}

/*
-(void) gotoleadprofile:(NSString *)leadkey
{
    [destLeadCategoryViewController.destLeadListViewController closesortingtable];
    if ([destLeadCategoryViewController.navigationController.topViewController isKindOfClass:[LeadCategoryTableViewController class]]) {
        destLeadCategoryViewController.Leadkey=leadkey;
        [destLeadCategoryViewController tableView:destLeadCategoryViewController.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }else if ([destLeadCategoryViewController.navigationController.topViewController isKindOfClass:[LeadListViewController class]]) {
        [destLeadCategoryViewController.destLeadListViewController passleadinformationfromleaddetailview:leadkey];
    }
}*/

-(void) updateSystemMessagewithNoLeadFound
{
    destLeadDetailsViewController.systemMessageLabel.text=[MyClass returntitlewithtitle:@"Select lead or press + to add new"];
    [destLeadDetailsViewController showviewhistory:YES];
    
    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Lead Profile"] message:[MyClass returntitlewithtitle:@"Selected lead no longer exists"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [erroralert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [erroralert addAction:OKAction];
    [self presentViewController:erroralert animated:YES completion:nil];
}

-(void) closeleadprofile
{
    //not used
}

-(void) enrollATLeadStudent:(AssessmentTrialRecord *)ATRecord
{
    //not used
}

-(BOOL) retrieveDataWithLeadCategory:(NSString *)LeadCategory
{
    if (!globalvariables) {
        globalvariables=[GlobalVariables singleObj];
    }
    
    [MyClass getLatestDataSetv2withParameters:@"lead" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    
    
    
    NSString *getDataURL;
    
    if ([LeadCategory isEqualToString:@"All"]) {
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Male"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&gender=Male",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Female"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&gender=Female",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Nursery"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&grade=Nursery",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Kindergarten"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&grade=Kindergarten",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Primary"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&grade=Primary",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Secondary"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&grade=Secondary",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Others"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&grade=Others",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Enrolled"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&status=Enrolled",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Waiting"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&status=Waiting",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Rejected"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&status=Rejected",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Give Up"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&status=Give Up",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"New"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&status=New",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Considering"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&status=Considering",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Black List"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&status=Black List",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Pending Assessment"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&status=Pending Assessment",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"Flagged"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&other=Flagged",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else if ([LeadCategory isEqualToString:@"None"]){
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&source=None",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"]];
    }else{
        getDataURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectleadlist&source=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewleadprofile"],LeadCategory];
    }
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:getDataURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result = TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            jsonArray = jsonreturned[@"content"];
            
            //Set up our Lead array
            leadArray=[[NSMutableArray alloc] init];
            
            //loop through our jsonArray
            for (int i=0; i<jsonArray.count; i++) {
                
                //Create our Lead object
                NSString * sLeadkey=[[jsonArray objectAtIndex:i] objectForKey:@"leadkey"];
                
                Lead *leadobject=[MyClass returnleadwithleadkey:sLeadkey];
                
                NSString * sothername=leadobject.othername;//[[jsonArray objectAtIndex:i] objectForKey:@"othername"];
                NSString * sfirstname=leadobject.firstname;[[jsonArray objectAtIndex:i] objectForKey:@"firstname"];
                NSString * slastname=leadobject.lastname;[[jsonArray objectAtIndex:i] objectForKey:@"lastname"];
                NSString * sgender=leadobject.gender;[[jsonArray objectAtIndex:i] objectForKey:@"gender"];
                NSString * sgrade=leadobject.grade;
                NSString * sschool=leadobject.school;
                NSString * sparentcontact=leadobject.parentcontact;
                NSString * sparentemail=leadobject.parentemail;
                NSString * sparentaddress=leadobject.parentaddress;
                NSString * sremarks=leadobject.remarks;
                NSString * simage=leadobject.image;
                NSString * sleadid=leadobject.leadid;
                NSString * scenterkey=leadobject.centerkey;
                
                //Add the Lead object to our Lead array
                [leadArray addObject:[[Lead alloc]initLeadWithleadkey:sLeadkey firstname:sfirstname lastname:slastname othername:sothername gender:sgender dateofbirth:nil age:nil grade:sgrade preferredlanguage:nil school:sschool parentname:nil parentcontact:sparentcontact parentemail:sparentemail parentaddress:sparentaddress remarks:sremarks flag:nil promotion:nil status:nil image:simage leadid:sleadid leadmedia:nil leadsource:nil studentkey:nil photoalbumrecord:nil centerkey:scenterkey iso_code:nil avatar:nil]];
            }
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[getDataURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            result = TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            jsonArray = jsonreturned[@"content"];
            
            //Set up our Lead array
            leadArray=[[NSMutableArray alloc] init];
            
            //loop through our jsonArray
            for (int i=0; i<jsonArray.count; i++) {
                
                //Create our Lead object
                NSString * sLeadkey=[[jsonArray objectAtIndex:i] objectForKey:@"leadkey"];
                
                Lead *leadobject=[MyClass returnleadwithleadkey:sLeadkey];
                
                NSString * sothername=leadobject.othername;//[[jsonArray objectAtIndex:i] objectForKey:@"othername"];
                NSString * sfirstname=leadobject.firstname;[[jsonArray objectAtIndex:i] objectForKey:@"firstname"];
                NSString * slastname=leadobject.lastname;[[jsonArray objectAtIndex:i] objectForKey:@"lastname"];
                NSString * sgender=leadobject.gender;[[jsonArray objectAtIndex:i] objectForKey:@"gender"];
                NSString * sgrade=leadobject.grade;
                NSString * sschool=leadobject.school;
                NSString * sparentcontact=leadobject.parentcontact;
                NSString * sparentemail=leadobject.parentemail;
                NSString * sparentaddress=leadobject.parentaddress;
                NSString * sremarks=leadobject.remarks;
                NSString * simage=leadobject.image;
                NSString * sleadid=leadobject.leadid;
                NSString * scenterkey=leadobject.centerkey;
                
                //Add the Lead object to our Lead array
                [leadArray addObject:[[Lead alloc]initLeadWithleadkey:sLeadkey firstname:sfirstname lastname:slastname othername:sothername gender:sgender dateofbirth:nil age:nil grade:sgrade preferredlanguage:nil school:sschool parentname:nil parentcontact:sparentcontact parentemail:sparentemail parentaddress:sparentaddress remarks:sremarks flag:nil promotion:nil status:nil image:simage leadid:sleadid leadmedia:nil leadsource:nil studentkey:nil photoalbumrecord:nil centerkey:scenterkey iso_code:nil avatar:nil]];
            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        [self returnfilteredleadlistarray];
        
        //Reload our Lead view
        [leadlisttable reloadData];
        [ailoadindicator stopAnimating];
        leadlisttable.userInteractionEnabled=TRUE;
    }else{
        [ailoadindicator stopAnimating];
        leadlisttable.userInteractionEnabled=TRUE;
    }
    
    return result;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([leadTableMode isEqualToString:@"category"]) {
        return 6;
    }else if ([leadTableMode isEqualToString:@"list"]){
        return 1;
    }else{
        return 2;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([leadTableMode isEqualToString:@"category"]) {
        if (section==0) {
            return 1;
        }else if (section==1){
            return StatusArray.count;
        }else if (section==2){
            return SourceArray.count;
        }else if (section==3){
            return 2;
        }else if (section==4){
            return GradeArray.count;
        }else{
            return 1;
        }
    }else if ([leadTableMode isEqualToString:@"list"]){
        return filteredLeadArray.count;
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
    if ([leadTableMode isEqualToString:@"category"]) {
        if (section==0) {
            return [MyClass returntitlewithtitle:@"All"];
        }else if (section==3){
            return [MyClass returntitlewithtitle:@"Gender"];
        }else if (section==4){
            return GradeArray.count>0?[MyClass returntitlewithtitle:@"Grade"]:nil;
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"Status"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"Source"];
        }else{
            return [MyClass returntitlewithtitle:@"Others"];
        }
    }else if ([leadTableMode isEqualToString:@"sorting"]){
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
    if([leadTableMode isEqualToString:@"category"]){
        NSString *CellIdentifier= @"categorycell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        if (indexPath.section==0) {
            categorycountobject=[AllArray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returntitlewithtitle:[NSString stringWithFormat:@"lead_status_%@",categorycountobject.type]];
            cell.label2.text=categorycountobject.count;
        }else if (indexPath.section==3){
            categorycountobject=[GenderArray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returntitlewithtitle:categorycountobject.type];
            cell.label2.text=categorycountobject.count;
        }else if (indexPath.section==4){
            categorycountobject=[GradeArray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returntitlewithtitle:categorycountobject.type];
            cell.label2.text=categorycountobject.count;
        }else if (indexPath.section==1){
            categorycountobject=[StatusArray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returntitlewithtitle:[NSString stringWithFormat:@"lead_status_%@",categorycountobject.type]];
            cell.label2.text=categorycountobject.count;
        }else if (indexPath.section==2){
            categorycountobject=[SourceArray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returntitlewithtitle:categorycountobject.type];
            cell.label2.text=categorycountobject.count;
        }else if (indexPath.section==5){
            categorycountobject=[OtherArray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returntitlewithtitle:categorycountobject.type];
            cell.label2.text=categorycountobject.count;
        }
    }else if ([leadTableMode isEqualToString:@"list"]){
        //MyTableViewCell *cell;
        NSString *CellIdentifier= @"leadcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        
        Lead * leadObject;
        leadObject = [filteredLeadArray objectAtIndex:indexPath.row];
        
        cell.label1.text=[MyClass returnLeadnameWithLeadkey:leadObject.leadkey option:@"fullbutid"];
        
        if ([leadObject.leadid isEqualToString:@""]) {
            cell.label2.hidden=YES;
        }else{
            cell.label2.hidden=NO;
            cell.label2.text=leadObject.leadid;
        }
        
        
        cell.imageview1.layer.cornerRadius=cell.imageview1.frame.size.width/2;
        cell.imageview1.layer.masksToBounds=YES;
        cell.imageview2.layer.cornerRadius=cell.imageview2.frame.size.width/2;
        cell.imageview2.layer.masksToBounds=YES;
        
        [MyClass downloadImageWithImageview:cell.imageview1 gender:leadObject.gender type:@"lead" typekey:leadObject.leadkey image:leadObject.image async:YES];
        

        
        if ([leadObject.leadkey isEqualToString:lastleadkey]) {
            cell.view1.hidden=NO;
        }else{
            cell.view1.hidden=YES;
        }
    }else if ([leadTableMode isEqualToString:@"sorting"]){
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
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:leadlisttable];
    NSIndexPath *indexpath =[leadlisttable indexPathForRowAtPoint:point];
    
    if ([((SortingRecord *)[sortingarray objectAtIndex:indexpath.row]).order isEqualToString:@"a"]){
        ((SortingRecord *)[sortingarray objectAtIndex:indexpath.row]).order=@"d";
    }else{
        ((SortingRecord *)[sortingarray objectAtIndex:indexpath.row]).order=@"a";
    }
    [self updatesortingstring];
    filteredLeadArray=[MyClass sortleadlistwithleadarray:filteredLeadArray sortingarray:sortingarray];
    [leadlisttable reloadData];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([leadTableMode isEqualToString:@"category"]) {
        
        tableView.userInteractionEnabled=FALSE;
        if (indexPath.section==0) {
            categorycountobject=[AllArray objectAtIndex:indexPath.row];
        }else if (indexPath.section==3){
            categorycountobject=[GenderArray objectAtIndex:indexPath.row];
        }else if (indexPath.section==4){
            categorycountobject=[GradeArray objectAtIndex:indexPath.row];
        }else if (indexPath.section==1){
            categorycountobject=[StatusArray objectAtIndex:indexPath.row];
        }else if (indexPath.section==2){
            categorycountobject=[SourceArray objectAtIndex:indexPath.row];
        }else if (indexPath.section==5){
            categorycountobject=[OtherArray objectAtIndex:indexPath.row];
        }
        
        if (categorycountobject.type) {
            leadTableMode=@"list";
            [self showButton];
            leadCategory=categorycountobject.type;
            [backbutton setTitle:[MyClass returntitlewithtitle:categorycountobject.type?categorycountobject.type:@"All"] forState:UIControlStateNormal];
            [ailoadindicator startAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self retrieveDataWithLeadCategory:leadCategory];
            });
        }
    }else{
        //backbuttonstack.hidden=YES;
        //menubutton.hidden=NO;
        
        Lead *object = [filteredLeadArray objectAtIndex:indexPath.row];
        [self.view endEditing:YES];
        if ([self passLeadkeytoLeadInformation:object.leadkey leadcategory:leadCategory]) {
            lastindexpath=indexPath;
            [MyClass insertViewHistoryWithType:@"lead" Typekey:object.leadkey Name:@"" IDNumber:@"" Gender:@""];
            [leadlisttable reloadData];
        }else{
            [tableView selectRowAtIndexPath:lastindexpath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([leadTableMode isEqualToString:@"category"]) {
        return UITableViewAutomaticDimension;
    }else{
        return UITableViewAutomaticDimension;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([leadTableMode isEqualToString:@"category"]) {
        return 35;
    }else if ([leadTableMode isEqualToString:@"sorting"]){
        return 40;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([leadTableMode isEqualToString:@"sorting"]) {
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
        filteredLeadArray=[MyClass sortleadlistwithleadarray:filteredLeadArray sortingarray:sortingarray];
        
    }
}

-(void) updatesortingstring
{
    [destLeadDetailsViewController stopAudioPlaying];
    NSString *sortingstring=@"";
    
    for (int i=0; i<sortingarray.count; i++) {
        if (i==0) {
            sortingstring=[NSString stringWithFormat:@"%@#%@",((SortingRecord *)[sortingarray objectAtIndex:i]).order,((SortingRecord *)[sortingarray objectAtIndex:i]).item];
        }else{
            sortingstring=[NSString stringWithFormat:@"%@,%@#%@",sortingstring,((SortingRecord *)[sortingarray objectAtIndex:i]).order,((SortingRecord *)[sortingarray objectAtIndex:i]).item];
        }
    }
    [MyClass updateUserAccountSettingsWithField:@"leadlistsortingorder" Value:sortingstring];
//    [MyClass updatelocaldbwithparameter:@"leadlistsortingorder" value:sortingstring];
}

-(void) closesortingtable
{
    [destLeadDetailsViewController stopAudioPlaying];
    leadlisttable.editing=NO;
    leadlisttable.scrollEnabled=YES;
    leadTableMode=@"list";
    [leadlisttable reloadData];
    
    if (lastleadkey) {
        long gotorow=[self returnLeadIndexWithLead:[MyClass returnleadwithleadkey:lastleadkey]];
        if (gotorow>=0) {
            [leadlisttable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
    [self showButton];
}

- (IBAction)photoalbumbuttonpressed:(id)sender {
    [self.view endEditing:YES];
    [destLeadDetailsViewController stopAudioPlaying];
    [self changeLeadListWithCategory:@"All"];
    
    leadimagepopover = (LeadImageGridViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"LeadImageGridViewController"];
    leadimagepopover.delegate=self;
    leadimagepopover.leadArray=filteredLeadArray;
    leadimagepopover.leadcategory=@"All";
    leadimagepopover.source=@"leadprofile";
    leadimagepopover.mode=@"single";
    
    leadimagepopover.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:leadimagepopover animated:YES completion: nil];
}

-(void) passleadfromgrid:(NSString *)leadkey
{
    leadCategory=@"All";
    leadTableMode=@"list";
    [self showButton];
    [backbutton setTitle:[MyClass returntitlewithtitle:leadCategory] forState:UIControlStateNormal];
    [leadlisttable reloadData];
    
    [leadimagepopover dismissViewControllerAnimated:YES completion:nil];
    
    
    
    //scroll to the selected Lead
    long gotorow = 0;
    Lead *leadobject=[MyClass returnleadwithleadkey:leadkey];
    if ([filteredLeadArray containsObject:leadobject]) {
        gotorow=[filteredLeadArray indexOfObject:leadobject];
    }
    
    [leadlisttable selectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self tableView:leadlisttable didSelectRowAtIndexPath:[leadlisttable indexPathForSelectedRow]];
    
}

-(void) passleadarrayfromgrid:(NSMutableArray *)leadarray
{
    //not used
}

- (IBAction)sortingbuttonpressed:(id)sender {
    [destLeadDetailsViewController stopAudioPlaying];
    leadTableMode=@"sorting";
    leadlisttable.editing=YES;
    leadlisttable.scrollEnabled=NO;
    [self showButton];
    [leadlisttable reloadData];
    
}

- (IBAction)backbuttonpressed:(id)sender {
    [destLeadDetailsViewController stopAudioPlaying];
    [self.view endEditing:YES];
    [ailoadindicator startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self changeLeadListWithCategory:@"All"];
        leadTableMode=@"category";
        [self showButton];
        [self updateCategoryCount];
        leadsearchbar.text=@"";
        [self changeLeadListWithCategory:@"All"];
        [ailoadindicator stopAnimating];
    });
    
}

-(void) dismissleadgridview
{
    [leadimagepopover dismissViewControllerAnimated:YES completion:nil];
}


@end
