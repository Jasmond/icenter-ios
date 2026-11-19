//
//  MessagePopoverViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 16/10/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import "MessagePopoverViewController.h"
#import "MyClass.h"
#import "MessagePhotoCollectionViewCell.h"
//#import "AFNetworking.h"
//#import "UIImageView+AFNetworking.h"
#import "SDWebImage.h"

@import Photos;

@import BSImagePicker;

@interface MessagePopoverViewController ()

@end

@implementation MessagePopoverViewController
@synthesize MessageTableMode,CallingSource,CallingKey,OMessageRecordObject,allleadarray,allstudentarray,allstaffarray,staffgrouparray;

#define maxPopupHeight self.view.frame.size.height
#define kbPopupHeight 380

#define popoverwidth 320
#define messagetypetablewidth 300
#define targettablewidth 300
#define subjecttablewidth 450
#define instructortablewidth 300
#define individualtablewidth 300
#define classdatetablewidth 320
#define gradetablewidth 300
#define leadstatustablewidth 300
#define studentstatustablewidth 300
#define staffgrouptablewidth 300
#define starttimetablewidth 320
#define droptablewidth 300
#define readstatustablewidth 320
#define readstatuscontacttablewidth 300
#define messagephotowidth 550
#define centerwidth 375

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    //initialize field
    df=[[NSDateFormatter alloc]init];
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    workingMessage=[[OutboxMessageRecord alloc]init];
    
    //boyimage=[UIImage imageNamed:@"boyimage.jpg"];
    //girlimage=[UIImage imageNamed:@"girlimage.png"];
    imageCache=[[NSCache alloc]init];
    
    keyboardshow=FALSE;
    photoimagechanged=FALSE;
    selectedCenters=[[NSMutableArray alloc]initWithObjects:globalvariables.centerrecord.centerkey, nil];
    
    [self loadcalendar];
    [self InitializeField];
    [self createsidetables];
    [self adjusttablesize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [centerNoneButton setTitle:[MyClass returntitlewithtitle:@"None"] forState:UIControlStateNormal];
    [centertAllButton setTitle:[MyClass returntitlewithtitle:@"All"] forState:UIControlStateNormal];
    
    [saveasdraftButton setTitle:[MyClass returntitlewithtitle:@"Save as Draft"] forState:UIControlStateNormal];
    [editButton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
    [copyButton setTitle:[MyClass returntitlewithtitle:@"Copy"] forState:UIControlStateNormal];
    [deleteButton setTitle:[MyClass returntitlewithtitle:@"Delete"] forState:UIControlStateNormal];
    [doneButton setTitle:[MyClass returntitlewithtitle:@"Send"] forState:UIControlStateNormal];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) updateTableRowArray
{
    recipientRowDataArray=[[NSMutableArray alloc]init];

    if ([MessageTableMode isEqualToString:@"Add"] || [MessageTableMode isEqualToString:@"Copy"]) {
        if(allcenterarray.count>0){
            [recipientRowDataArray addObject:@"Center"];
        }
    }
    [recipientRowDataArray addObject:@"MessageType"];
    [recipientRowDataArray addObject:@"RecipientType"];
    if([self isMainCenterOnlySelected]){
        [recipientRowDataArray addObject:@"Individual"];
    }
    if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
        if (workingMessage.recipientgroup.individualarray.count==0) {
            [recipientRowDataArray addObject:@"Subject"];
            if ([self isMainCenterOnlySelected]) {
                [recipientRowDataArray addObject:@"Instructor"];
            }
            [recipientRowDataArray addObject:@"ClassDate"];
            [recipientRowDataArray addObject:@"Grade"];
            [recipientRowDataArray addObject:@"StudentStatus"];
            [recipientRowDataArray addObject:@"Drop"];
        }
    }else if ([workingMessage.recipienttype isEqualToString:@"Lead"]){
        if (workingMessage.recipientgroup.individualarray.count==0) {
            [recipientRowDataArray addObject:@"Grade"];
            [recipientRowDataArray addObject:@"LeadStatus"];
        }
    }else if ([workingMessage.recipienttype isEqualToString:@"Staff"]){
        [recipientRowDataArray addObject:@"StaffGroup"];
    }
}

-(BOOL) isMainCenterOnlySelected{
    return (selectedCenters.count==1 && [selectedCenters containsObject:globalvariables.centerrecord.centerkey]);
}

-(void) returnAvailableCenterArray
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrieveavailablecenterkeys&privilegetype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,@"sendmessage"];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSMutableArray *JSONArray=[[NSMutableArray alloc]init];
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            
            //loop through our jsonArray
            allcenterarray=[[NSMutableArray alloc]init];
            for (int i=0; i<JSONArray.count; i++) {
                NSString * ccenterkey=[[JSONArray objectAtIndex:i] objectForKey:@"centerkey"];
                [allcenterarray addObject:[MyClass returncenterrecordwithcenterkey:ccenterkey]];
            }
            filteredCenterArray=[[NSMutableArray alloc]initWithArray:allcenterarray];
            [self sortFilteredCenterArray];
        }
    }];
}

-(void) sortFilteredCenterArray
{
    NSSortDescriptor *sortByCenterName;
    if ([globalvariables.language isEqualToString:@"English"]) {
        sortByCenterName = [NSSortDescriptor sortDescriptorWithKey:@"centershortname_english" ascending:YES selector:@selector(localizedStandardCompare:)];
    }else{
        sortByCenterName = [NSSortDescriptor sortDescriptorWithKey:@"centershortname_chinese" ascending:YES selector:@selector(localizedStandardCompare:)];
    }
    
    NSArray *sortDescriptors = @[sortByCenterName];
    filteredCenterArray = [NSMutableArray arrayWithArray:[filteredCenterArray sortedArrayUsingDescriptors:sortDescriptors]];
}

-(void) loadcalendar
{
    hourPickerViewMenu=[NSMutableArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",nil];
    minutePickerViewMenu=[NSMutableArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
}


-(void) createsidetables
{
    messagetypearray = [[NSArray alloc]initWithObjects:@"General",@"Promotional",@"Important",nil];
    targetarray=[[NSArray alloc]initWithObjects:@"Student",@"Lead",@"Staff", nil];
    leadstatusarray=[[NSMutableArray alloc]initWithObjects:@"New Leads",@"Enrolled Leads",@"Pending Assessment Leads",@"Considering Leads",@"Waiting Leads",@"Give up Leads",@"Black List Leads",nil];
    studentstatusarray=[[NSMutableArray alloc]initWithObjects:@"Attending",@"Future",@"No Scheduled Class",nil];
    //staffgrouparray=[MyClass returnStaffGroupArrayIncludeAll:NO];
    
    allsubjectarray=[MyClass retrievesubjectinformationwithstatus:@"Active" category:@"All" flushcachedata:NO];
    filteredsubjectarray=[[NSMutableArray alloc]initWithArray:allsubjectarray];
    
    allinstructorarray=[MyClass filterInstructorArrayWithInstructorArray:[MyClass retrieveInstructorListwithvalid:@"All" flushcachedata:NO] Valid:@"Yes"];
    filteredinstructorarray=[[NSMutableArray alloc]initWithArray:allinstructorarray];
    
    gradearray=[[NSMutableArray alloc]initWithArray:[((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).grade componentsSeparatedByString:@","]];
    
    droparray=[[NSMutableArray alloc]initWithObjects:@"Non Drop",@"Dropped",nil];
    activearray=[[NSMutableArray alloc]initWithObjects:@"Active",@"Inactive",nil];
    
    //message type
    MessageTypeTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, messagetypetablewidth, self.view.frame.size.height)];
    [self.view addSubview:MessageTypeTableMasterView];
    MessageTypeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, messagetypetablewidth, self.view.bounds.size.height-44-20) style:UITableViewStyleGrouped];
    MessageTypeTable.dataSource=self;
    MessageTypeTable.delegate=self;
    [MessageTypeTable reloadData];
    MessageToolbar.clipsToBounds=YES;
    
    [MessageTypeTableMasterView addSubview:MessageTypeTable];
    MessageTypeTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, messagetypetablewidth, 44)];
    [MessageTypeTableMasterView addSubview:MessageTypeTableToolBar];
    [self createMessageTypeTableToolBar];
    
    //target
    TargetTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, targettablewidth, self.view.frame.size.height)];
    [self.view addSubview:TargetTableMasterView];
    TargetTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, targettablewidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    TargetTable.dataSource=self;
    TargetTable.delegate=self;
    [TargetTable reloadData];
    
    [TargetTableMasterView addSubview:TargetTable];
    TargetTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, targettablewidth, 44)];
    TargetTableToolBar.clipsToBounds=YES;
    [TargetTableMasterView addSubview:TargetTableToolBar];
    [self createTargetTableToolBar];

    
    //individual table
    IndividualTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, individualtablewidth, self.view.frame.size.height)];
    [self.view addSubview:IndividualTableMasterView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, IndividualTableMasterView.frame.size.width,84)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [IndividualTableMasterView addSubview:headerView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Individual"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    individualsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 40, IndividualTableMasterView.frame.size.width, 42)];
    individualsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    individualsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    individualsearchbar.delegate=self;
    [headerView addSubview:individualsearchbar];
    
    IndividualTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84+20, individualtablewidth, self.view.frame.size.height-44-84-20) style:UITableViewStyleGrouped];
    IndividualTable.dataSource=self;
    IndividualTable.delegate=self;
    IndividualTable.sectionHeaderHeight=0;
    [IndividualTable reloadData];
    [IndividualTableMasterView addSubview:IndividualTable];
    
    IndividualTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, individualtablewidth, 44)];
    IndividualTableToolBar.clipsToBounds=YES;
    [IndividualTableMasterView addSubview:IndividualTableToolBar];
    
    
    individualimagebutton=[[UIButton alloc]initWithFrame:CGRectMake(IndividualTableMasterView.frame.size.width-44, 4, 40, 40)];
    [individualimagebutton setImage:[UIImage imageNamed:@"instructoricon.png"] forState:UIControlStateNormal];
    [individualimagebutton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [individualimagebutton addTarget: self action:@selector(ImageButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
    [headerView addSubview:individualimagebutton];
    
    [self createIndividualTableToolBar];
    
    //recipient list table
    RecipientListTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, individualtablewidth, self.view.frame.size.height)];
    [self.view addSubview:RecipientListTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, IndividualTableMasterView.frame.size.width,84)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [RecipientListTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Recipient"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    RecipientListsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 40, IndividualTableMasterView.frame.size.width, 42)];
    RecipientListsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    RecipientListsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    RecipientListsearchbar.delegate=self;
    [headerView addSubview:RecipientListsearchbar];
    
    RecipientListTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84+20, individualtablewidth, self.view.frame.size.height-44-84-20) style:UITableViewStyleGrouped];
    RecipientListTable.dataSource=self;
    RecipientListTable.delegate=self;
    RecipientListTable.sectionHeaderHeight=0;
    [RecipientListTable reloadData];
    [RecipientListTableMasterView addSubview:RecipientListTable];
    
    RecipientListTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, individualtablewidth, 44)];
    RecipientListTableToolBar.clipsToBounds=YES;
    [RecipientListTableMasterView addSubview:RecipientListTableToolBar];
    
    [self createRecipientListTableToolBar];
    
    //instructor table
    InstructorTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, instructortablewidth, self.view.frame.size.height)];
    [self.view addSubview:InstructorTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, InstructorTableMasterView.frame.size.width,84)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [InstructorTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Instructor"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    instructorsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 40, InstructorTableMasterView.frame.size.width, 42)];
    instructorsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    instructorsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    instructorsearchbar.delegate=self;
    [headerView addSubview:instructorsearchbar];
    
    InstructorTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84+20, instructortablewidth, self.view.frame.size.height-44-84-20) style:UITableViewStyleGrouped];
    InstructorTable.dataSource=self;
    InstructorTable.delegate=self;
    InstructorTable.sectionHeaderHeight=0;
    [InstructorTable reloadData];
    [InstructorTableMasterView addSubview:InstructorTable];
    
    InstructorTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, instructortablewidth, 44)];
    InstructorTableToolBar.clipsToBounds=YES;
    [InstructorTableMasterView addSubview:InstructorTableToolBar];
    
    
    [self createInstructorTableToolBar];
    

    
    //class date & Expiry date
    ClassDateTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, classdatetablewidth, self.view.frame.size.height)];
    [self.view addSubview:ClassDateTableMasterView];
    ClassDateTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, classdatetablewidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    ClassDateTable.dataSource=self;
    ClassDateTable.delegate=self;
    ClassDateTable.scrollEnabled=false;
    [ClassDateTable reloadData];
    
    [ClassDateTableMasterView addSubview:ClassDateTable];
    ClassDateTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, classdatetablewidth, 44)];
    ClassDateTableToolBar.clipsToBounds=YES;
    [ClassDateTableMasterView addSubview:ClassDateTableToolBar];
    [self createClassDateTableToolBar];
    
    //grade
    GradeTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, gradetablewidth, self.view.frame.size.height)];
    [self.view addSubview:GradeTableMasterView];
    GradeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, gradetablewidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    GradeTable.dataSource=self;
    GradeTable.delegate=self;
    [GradeTable reloadData];
    
    [GradeTableMasterView addSubview:GradeTable];
    GradeTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, gradetablewidth, 44)];
    GradeTableToolBar.clipsToBounds=YES;
    [GradeTableMasterView addSubview:GradeTableToolBar];
    [self createGradeTableToolBar];
    
    //student status
    StudentStatusTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, leadstatustablewidth, self.view.frame.size.height)];
    [self.view addSubview:StudentStatusTableMasterView];
    StudentStatusTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, leadstatustablewidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    StudentStatusTable.dataSource=self;
    StudentStatusTable.delegate=self;
    [StudentStatusTable reloadData];
    
    [StudentStatusTableMasterView addSubview:StudentStatusTable];
    StudentStatusTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, leadstatustablewidth, 44)];
    StudentStatusTableToolBar.clipsToBounds=YES;
    [StudentStatusTableMasterView addSubview:StudentStatusTableToolBar];
    [self createStudentStatusTableToolBar];
    
    //lead status
    LeadStatusTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, studentstatustablewidth, self.view.frame.size.height)];
    [self.view addSubview:LeadStatusTableMasterView];
    LeadStatusTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, studentstatustablewidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    LeadStatusTable.dataSource=self;
    LeadStatusTable.delegate=self;
    [LeadStatusTable reloadData];
    
    [LeadStatusTableMasterView addSubview:LeadStatusTable];
    LeadStatusTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, studentstatustablewidth, 44)];
    LeadStatusTableToolBar.clipsToBounds=YES;
    [LeadStatusTableMasterView addSubview:LeadStatusTableToolBar];
    [self createLeadStatusTableToolBar];
    
    //staff group
    StaffGroupTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, staffgrouptablewidth, self.view.frame.size.height)];
    [self.view addSubview:StaffGroupTableMasterView];
    StaffGroupTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, staffgrouptablewidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    StaffGroupTable.dataSource=self;
    StaffGroupTable.delegate=self;
    [StaffGroupTable reloadData];
    
    [StaffGroupTableMasterView addSubview:StaffGroupTable];
    StaffGroupTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, staffgrouptablewidth, 44)];
    StaffGroupTableToolBar.clipsToBounds=YES;
    [StaffGroupTableMasterView addSubview:StaffGroupTableToolBar];
    [self createStaffGroupTableToolBar];
    
    //start time
    StartTimeTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, starttimetablewidth, self.view.frame.size.height)];
    [self.view addSubview:StartTimeTableMasterView];
    StartTimeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, starttimetablewidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    StartTimeTable.dataSource=self;
    StartTimeTable.delegate=self;
    [StartTimeTable reloadData];
    
    [StartTimeTableMasterView addSubview:StartTimeTable];

    StartTimeTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, starttimetablewidth, 44)];
    StartTimeTableToolBar.clipsToBounds=YES;
    [StartTimeTableMasterView addSubview:StartTimeTableToolBar];
    [self createStartTimeTableToolBar];
    
    //drop
    DropTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, droptablewidth, self.view.frame.size.height)];
    [self.view addSubview:DropTableMasterView];
    DropTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, droptablewidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    DropTable.dataSource=self;
    DropTable.delegate=self;
    [DropTable reloadData];
    
    [DropTableMasterView addSubview:DropTable];
    DropTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, droptablewidth, 44)];
    DropTableToolBar.clipsToBounds=YES;
    [DropTableMasterView addSubview:DropTableToolBar];
    [self createDropTableToolBar];
    

    
    
    //read status table
    ReadStatusTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, readstatustablewidth, self.view.frame.size.height)];
    [self.view addSubview:ReadStatusTableMasterView];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, ReadStatusTableMasterView.frame.size.width,84)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [ReadStatusTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Read Status"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    readstatussearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 40, ReadStatusTableMasterView.frame.size.width, 42)];
    readstatussearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    readstatussearchbar.searchBarStyle=UISearchBarStyleMinimal;
    readstatussearchbar.delegate=self;
    [headerView addSubview:readstatussearchbar];
    
    ReadStatusTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84+20, readstatustablewidth, self.view.frame.size.height-44-84-20) style:UITableViewStyleGrouped];
    ReadStatusTable.dataSource=self;
    ReadStatusTable.delegate=self;
    ReadStatusTable.sectionHeaderHeight=0;
    [ReadStatusTable reloadData];
    [ReadStatusTableMasterView addSubview:ReadStatusTable];
    
    ReadStatusTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, readstatustablewidth, 44)];
    ReadStatusTableToolBar.clipsToBounds=YES;
    [ReadStatusTableMasterView addSubview:ReadStatusTableToolBar];
    
    
    [self createReadStatusTableToolBar];

    
    //read status contact table
    ReadStatusContactTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth+readstatustablewidth, 0, readstatuscontacttablewidth, self.view.frame.size.height)];
    [self.view addSubview:ReadStatusContactTableMasterView];

    ReadStatusContactTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, readstatuscontacttablewidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    ReadStatusContactTable.dataSource=self;
    ReadStatusContactTable.delegate=self;
    
    [ReadStatusContactTable reloadData];
    [ReadStatusContactTableMasterView addSubview:ReadStatusContactTable];
    
    ReadStatusContactTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, readstatuscontacttablewidth, 44)];
    ReadStatusContactTableToolBar.clipsToBounds=YES;
    [ReadStatusContactTableMasterView addSubview:ReadStatusContactTableToolBar];
    
    
    [self createReadStatusContactTableToolBar];
    readstatuscontactarray=[[NSMutableArray alloc]init];

    //add separator
    UILabel *separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth+readstatustablewidth, 44, 0.6, self.view.frame.size.height-44)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
    
    //subject table
    SubjectTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, subjecttablewidth, self.view.frame.size.height)];
    [self.view addSubview:SubjectTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, SubjectTableMasterView.frame.size.width,84)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [SubjectTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Subject"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    subjectsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 40, SubjectTableMasterView.frame.size.width, 42)];
    subjectsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    subjectsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    subjectsearchbar.delegate=self;
    [headerView addSubview:subjectsearchbar];
    
    SubjectTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84+20, subjecttablewidth, self.view.frame.size.height-44-84-20) style:UITableViewStyleGrouped];
    SubjectTable.dataSource=self;
    SubjectTable.delegate=self;
    SubjectTable.sectionHeaderHeight=0;
    [SubjectTable reloadData];
    [SubjectTableMasterView addSubview:SubjectTable];
    
    SubjectTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, subjecttablewidth, 44)];
    SubjectTableToolBar.clipsToBounds=YES;
    [SubjectTableMasterView addSubview:SubjectTableToolBar];
    [self createSubjectTableToolBar];
    
    //Message Photo
    MessagePhotoMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, messagephotowidth, self.view.frame.size.height)];
    [self.view addSubview:MessagePhotoMasterView];
    //MessagePhotoMasterView.backgroundColor=[UIColor blackColor];
    
    fullscreen_scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+20, MessagePhotoMasterView.bounds.size.width, MessagePhotoMasterView.bounds.size.height-44-20)];
    fullscreen_scrollview.backgroundColor=[UIColor blackColor];
    fullscreen_scrollview.maximumZoomScale=7.0;
    fullscreen_scrollview.minimumZoomScale=1;
    fullscreen_scrollview.delegate=self;
    
    [MessagePhotoMasterView addSubview:fullscreen_scrollview];
    fullscreen_messageimageview=[[UIImageView alloc]init];
    fullscreen_messageimageview.backgroundColor=[UIColor whiteColor];
    fullscreen_messageimageview.contentMode=UIViewContentModeScaleAspectFit;
    [fullscreen_scrollview addSubview:fullscreen_messageimageview];
    fullscreen_scrollview.contentSize = fullscreen_messageimageview.frame.size;
    
    //add webview
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    webView = [[WKWebView alloc] initWithFrame:fullscreen_scrollview.frame configuration:theConfiguration];
    webView.backgroundColor=[UIColor whiteColor];
    [MessagePhotoMasterView addSubview:webView];
    
    //add videoview
    videoView = [[UIView alloc]initWithFrame:fullscreen_scrollview.frame];
    [MessagePhotoMasterView addSubview:videoView];
    avplayerviewcontroller=[[AVPlayerViewController alloc]init];
    avplayerviewcontroller.view.frame=videoView.bounds;
    [videoView addSubview:avplayerviewcontroller.view];
    [self addChildViewController:avplayerviewcontroller];
    [avplayerviewcontroller didMoveToParentViewController:self];

    
    MessagePhotoToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, messagephotowidth, 44)];
    [MessagePhotoMasterView addSubview:MessagePhotoToolBar];
    [self createMessagePhotoToolBar];
    
    //add separator
    separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth, 20, 1, self.view.bounds.size.height-20)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
    
    
    photocloseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    photocloseButton.frame = CGRectMake(20, 33, 20, 20);
    [photocloseButton setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [photocloseButton addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [photocloseButton.heightAnchor constraintEqualToConstant:20].active = true;
    [photocloseButton.widthAnchor constraintEqualToConstant:20].active = true;
    
    [MessagePhotoMasterView addSubview:photocloseButton];
    
    photorotateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    photorotateButton.frame = CGRectMake(messagephotowidth-40, 33, 20, 20);
    [photorotateButton setImage:[UIImage imageNamed:@"rotatebutton_blue.png"] forState:UIControlStateNormal];
    [photorotateButton addTarget:self action:@selector(rotateimage) forControlEvents:UIControlEventTouchUpInside];
    [photorotateButton.heightAnchor constraintEqualToConstant:20].active = true;
    [photorotateButton.widthAnchor constraintEqualToConstant:20].active = true;
    
    [MessagePhotoMasterView addSubview:photorotateButton];
    
    photoshareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    photoshareButton.frame = CGRectMake(messagephotowidth-40, 33, 20, 20);
    [photoshareButton setImage:[UIImage imageNamed:@"photosharebutton_blue.png"] forState:UIControlStateNormal];
    [photoshareButton addTarget:self action:@selector(shareimage:) forControlEvents:UIControlEventTouchUpInside];
    [photoshareButton.heightAnchor constraintEqualToConstant:20].active = true;
    [photoshareButton.widthAnchor constraintEqualToConstant:20].active = true;
    
    [MessagePhotoMasterView addSubview:photoshareButton];
    
    
    //center table view
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, centerwidth,81)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [CenterMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Center"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    
    centersearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 36, centerwidth, 42)];
    centersearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    centersearchbar.delegate=self;
    centersearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:centersearchbar];
    centertable.sectionHeaderHeight=0;
    
    [self.view bringSubviewToFront:CenterMasterView];
    [CenterMasterView bringSubviewToFront:centertableseparator];
}



-(void) createMessagePhotoToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//
//    
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 25, 25);
//    [button setImage:[UIImage imageNamed:@"rotatebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(rotateimage) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:25].active = true;
//    [button.widthAnchor constraintEqualToConstant:25].active = true;
//    UIBarButtonItem *rotateButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 25, 25);
//    [button setImage:[UIImage imageNamed:@"photosharebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(shareimage:) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:25].active = true;
//    [button.widthAnchor constraintEqualToConstant:25].active = true;
//    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    
//    
//    

    
    photoshareButton.hidden=YES;
    photorotateButton.hidden=YES;
    
    
    if ([MessageTableMode isEqualToString:@"View"]) {
//        barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,shareButton, nil];
        photoshareButton.hidden=NO;
    }else{
        if ([messagephotoobject.filetype isEqualToString:@"image"]) {
//            barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,rotateButton, nil];
            photorotateButton.hidden=NO;
        }
    }
//    [MessagePhotoToolBar setItems:barItems];
}

-(void) createMessageTypeTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [MessageTypeTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [MessageTypeTableMasterView addSubview:button];
}

-(void) createTargetTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [TargetTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [TargetTableMasterView addSubview:button];
}

-(void) createIndividualTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,anyButton, nil];
//    [IndividualTableToolBar setItems:barItems];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [IndividualTableMasterView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 100, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"Reset to Any"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(anybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(individualtablewidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
    [IndividualTableMasterView addSubview:button];
    
    
    
    
}

-(void) createRecipientListTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [RecipientListTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [RecipientListTableMasterView addSubview:button];
}

-(void) createReadStatusTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [ReadStatusTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [ReadStatusTableMasterView addSubview:button];
}

-(void) createReadStatusContactTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    barItems = [[NSMutableArray alloc]initWithObjects:flexSpace, nil];
//    [ReadStatusContactTableToolBar setItems:barItems];
}

-(void) createInstructorTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,anyButton, nil];
//    [InstructorTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [InstructorTableMasterView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 100, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"Reset to Any"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(anybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(instructortablewidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
    [InstructorTableMasterView addSubview:button];
}

-(void) createClassDateTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[selectedItem isEqualToString:@"ClassDate"]?[MyClass returntitlewithtitle:@"Reset to Any"]:[MyClass returntitlewithtitle:@"None"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
//    
//    yearButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,yearButton,flexSpace,anyButton, nil];
//    [ClassDateTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [ClassDateTableMasterView addSubview:button];
    
    
    yearButton = [UIButton buttonWithType:UIButtonTypeSystem];
    yearButton.frame = CGRectMake(45, 33, 100, 20);
    yearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    yearButton.userInteractionEnabled=NO;
    [ClassDateTableMasterView addSubview:yearButton];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 100, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"Reset to Any"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(anybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(classdatetablewidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
    [ClassDateTableMasterView addSubview:button];
}


-(void) createGradeTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,anyButton, nil];
//    [GradeTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [GradeTableMasterView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 100, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"Reset to Any"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(anybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(gradetablewidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
    [GradeTableMasterView addSubview:button];
}

-(void) createStudentStatusTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,anyButton, nil];
//    [StudentStatusTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [StudentStatusTableMasterView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 100, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"Reset to Any"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(anybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(studentstatustablewidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
    [StudentStatusTableMasterView addSubview:button];
}

-(void) createLeadStatusTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,anyButton, nil];
//    [LeadStatusTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [LeadStatusTableMasterView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 100, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"Reset to Any"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(anybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(leadstatustablewidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
    [LeadStatusTableMasterView addSubview:button];
}

-(void) createStaffGroupTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,anyButton, nil];
//    [StaffGroupTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [StaffGroupTableMasterView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 100, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"Reset to Any"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(anybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(staffgrouptablewidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
    [StaffGroupTableMasterView addSubview:button];
}

-(void) createSubjectTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//
//    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,anyButton, nil];
//    [SubjectTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [SubjectTableMasterView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 100, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"Reset to Any"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(anybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(subjecttablewidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
    [SubjectTableMasterView addSubview:button];
}

-(void) createStartTimeTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [StartTimeTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [StartTimeTableMasterView addSubview:button];
}

-(void) createDropTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,anyButton, nil];
//    [DropTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [DropTableMasterView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 100, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"Reset to Any"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(anybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(droptablewidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
    [DropTableMasterView addSubview:button];
}


-(void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [avplayerviewcontroller.player pause];
}

-(void) closesidewindow
{
    [avplayerviewcontroller.player pause];
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [MessagePopoverTable deselectRowAtIndexPath:[MessagePopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) anybuttonpressed
{
    if (showIndividualTable){
        workingMessage.recipientgroup.individualarray=[[NSMutableArray alloc]init];
        individualsearchbar.text=@"";
        filteredindividualarray=[[NSMutableArray alloc]initWithArray:allindividualarray];
        
        if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
            workingMessage.recipientgroup.droparray=[[NSMutableArray alloc]initWithObjects:@"Non Drop", nil];
        }
    }else if (showSubjectTable){
        workingMessage.recipientgroup.subjectarray=[[NSMutableArray alloc]init];
        subjectsearchbar.text=@"";
        filteredsubjectarray=[[NSMutableArray alloc]initWithArray:allsubjectarray];
    }else if (showInstructorTable){
        workingMessage.recipientgroup.instructorarray=[[NSMutableArray alloc]init];
        instructorsearchbar.text=@"";
        filteredinstructorarray=[[NSMutableArray alloc]initWithArray:allinstructorarray];
    }else if (showClassDateTable){
        if ([selectedItem isEqualToString:@"ClassDate"]) {
            workingMessage.recipientgroup.classdatearray=[[NSMutableArray alloc]init];
        }else if ([selectedItem isEqualToString:@"ExpiryDate"]){
            workingMessage.hn_expiry_date=@"";
        }
    }else if (showGradeTable){
        workingMessage.recipientgroup.gradearray=[[NSMutableArray alloc]init];
    }else if (showLeadStatusTable){
        workingMessage.recipientgroup.leadstatusarray=[[NSMutableArray alloc]init];
    }else if (showStudentStatusTable){
        workingMessage.recipientgroup.studentstatusarray=[[NSMutableArray alloc]init];
    }else if (showStaffGroupTable){
        workingMessage.recipientgroup.staffgrouparray=[[NSMutableArray alloc]init];
    }else if (showDropTable){
        workingMessage.recipientgroup.droparray=[[NSMutableArray alloc]init];
    }
    
    [self closesidewindow];
    [self updateTableRowArray];
    [MessagePopoverTable reloadData];
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

-(BOOL) checkifclassdate:(NSString *)value
{
    if ([value length]>=11) {
        [df setDateFormat:@"dd-MMM-yyyy"];
        NSDate *date=[df dateFromString:[value substringToIndex:11]];
        if (date) {
            return TRUE;
        }else{
            return FALSE;
        }
    }else{
        return FALSE;
    }
}

-(void) createViewBarButton{
    
    if ([OMessageRecordObject.automessageflag isEqualToString:@"Y"]) {
        
        
    }else{
        copyButton.hidden=YES;
        editButton.hidden=YES;
        deleteButton.hidden=YES;
        saveButton.hidden=YES;
        saveasdraftButton.hidden=YES;
        doneButton.hidden=YES;
        
        
        if ([CallingSource isEqualToString:@"StudentView"]) {

//                UIBarButtonItem *copyButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Copy"] style:UIBarButtonItemStylePlain target:self action:@selector(copyButtonPressed:)];
//                UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//                UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//                NSArray *buttons =[NSArray arrayWithObjects:copyButton,flexibleSpaceBarButton,editButton,nil];
//                [MessageToolbar setItems:buttons animated:NO];
            
            copyButton.hidden=NO;
            editButton.hidden=NO;
            
        }else if ([CallingSource isEqualToString:@"LeadView"]){
//            UIBarButtonItem *copyButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Copy"] style:UIBarButtonItemStylePlain target:self action:@selector(copyButtonPressed:)];
//            //UIBarButtonItem *deleteButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonPressed:)];
//            UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//            UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//            NSArray *buttons =[NSArray arrayWithObjects:copyButton,flexibleSpaceBarButton,editButton,nil];
//            [MessageToolbar setItems:buttons animated:NO];
            
            copyButton.hidden=NO;
            editButton.hidden=NO;
        }else{
//            UIBarButtonItem *copyButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Copy"] style:UIBarButtonItemStylePlain target:self action:@selector(copyButtonPressed:)];
//            UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//            UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//            UIBarButtonItem *deleteButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonPressed:)];
//            UIBarButtonItem *saveButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Save"] style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)];
//            
//            NSArray *buttons;
            
            if (![MyClass isMessageSentWithMessageSentTime:workingMessage.messagestarttime] || [workingMessage.status isEqualToString:@"D"]) {
//                buttons =[NSArray arrayWithObjects:copyButton,flexibleSpaceBarButton,editButton,nil];
                
                copyButton.hidden=NO;
                editButton.hidden=NO;
                
            }else{
                if ([self hotnewsfieldchanged]) {
//                    buttons =[NSArray arrayWithObjects:copyButton,flexibleSpaceBarButton,saveButton,nil];
                    copyButton.hidden=NO;
                    saveButton.hidden=NO;
                }else{
//                    buttons =[NSArray arrayWithObjects:copyButton,flexibleSpaceBarButton,deleteButton,nil];
                    copyButton.hidden=NO;
                    deleteButton.hidden=NO;
                    if (!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).deletemessage) {
                        deleteButton.enabled=NO;
                    }
                }
            }
            
            if ([workingMessage.messagetype isEqualToString:@"Teacher Note"]) {
                copyButton.enabled=NO;
            }else{
                copyButton.enabled=YES;
            }
//            [MessageToolbar setItems:buttons animated:NO];
        }
    }
}

-(BOOL) hotnewsfieldchanged
{
    if (OMessageRecordObject.hotnews!=workingMessage.hotnews) {
        return YES;
    }else if(OMessageRecordObject.hotnews==YES && ![OMessageRecordObject.hn_expiry_date isEqualToString:workingMessage.hn_expiry_date]){
        return YES;
    }
    return NO;
}



-(void) createCopyBarButton{
//    UIBarButtonItem *draftButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Save as Draft"] style:UIBarButtonItemStylePlain target:self action:@selector(draftButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Send"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    doneButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendbroadcastmessage;
//    NSArray *buttons =[NSArray arrayWithObjects:draftButton,flexibleSpaceBarButton,doneButton,nil];
//    [MessageToolbar setItems:buttons animated:NO];
    
    copyButton.hidden=YES;
    editButton.hidden=YES;
    deleteButton.hidden=YES;
    saveButton.hidden=YES;
    saveasdraftButton.hidden=NO;
    doneButton.hidden=NO;
    
}

-(void) createEditBarButton{
//    UIBarButtonItem *draftButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Save as Draft"] style:UIBarButtonItemStylePlain target:self action:@selector(draftButtonPressed:)];
//    UIBarButtonItem *deleteButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Send"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    doneButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendbroadcastmessage;
//    NSArray *buttons =[NSArray arrayWithObjects:draftButton,flexibleSpaceBarButton,deleteButton,flexibleSpaceBarButton,doneButton,nil];
//    [MessageToolbar setItems:buttons animated:NO];
    
    copyButton.hidden=YES;
    editButton.hidden=YES;
    deleteButton.hidden=NO;
    saveButton.hidden=YES;
    saveasdraftButton.hidden=NO;
    doneButton.hidden=NO;
    
}

-(void) createAddBarButton{
//    UIBarButtonItem *draftButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Save as Draft"] style:UIBarButtonItemStylePlain target:self action:@selector(draftButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Send"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    doneButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendbroadcastmessage;
//    NSArray *buttons =[NSArray arrayWithObjects:draftButton,flexibleSpaceBarButton,doneButton,nil];
//    [MessageToolbar setItems:buttons animated:NO];
    
    copyButton.hidden=YES;
    editButton.hidden=YES;
    deleteButton.hidden=YES;
    saveButton.hidden=YES;
    saveasdraftButton.hidden=NO;
    doneButton.hidden=NO;
    
}

-(void) adjusttablesize
{
    tablebottomconstraint.constant=keyboardheight;
    
    float tableheight;
    float tablewidth;
    
    tableheight=maxPopupHeight-keyboardheight;
    
    
    if (showMessageTypeTable) {
        tablewidth=popoverwidth+messagetypetablewidth;
    }else if (showTargetTable){
        tablewidth=popoverwidth+targettablewidth;
    }else if (showIndividualTable){
        tablewidth=popoverwidth+individualtablewidth;
    }else if (showRecipientListTable){
        tablewidth=popoverwidth+individualtablewidth;
    }else if (showSubjectTable){
        tablewidth=popoverwidth+subjecttablewidth;
    }else if (showInstructorTable){
        tablewidth=popoverwidth+instructortablewidth;
    }else if (showClassDateTable){
        tablewidth=popoverwidth+classdatetablewidth;
    }else if (showGradeTable){
        tablewidth=popoverwidth+gradetablewidth;
    }else if (showLeadStatusTable){
        tablewidth=popoverwidth+leadstatustablewidth;
    }else if (showStudentStatusTable){
        tablewidth=popoverwidth+studentstatustablewidth;
    }else if (showStaffGroupTable){
        tablewidth=popoverwidth+staffgrouptablewidth;
    }else if (showStartTimeTable){
        tablewidth=popoverwidth+starttimetablewidth;
    }else if (showDropTable){
        tablewidth=popoverwidth+droptablewidth;
    }else if (showReadStatusTable){
        if (showReadStatusContactTable) {
            tablewidth=popoverwidth+readstatustablewidth+readstatuscontacttablewidth;
        }else{
            tablewidth=popoverwidth+readstatustablewidth;
        }
    }else if (showMessagePhoto){
        tablewidth=popoverwidth+messagephotowidth;
    }else if (showCenterTable){
        tablewidth=popoverwidth+centerwidth;
    }else{
        tablewidth=popoverwidth;
    }
    
    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    
    self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
    
    
    if (showMessageTypeTable){
        [MessageTypeTable setFrame:CGRectMake(0, 44+20, messagetypetablewidth, tableheight-44-20)];
        MessageTypeTableMasterView.hidden=NO;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showTargetTable){
        [TargetTable setFrame:CGRectMake(0, 44+20, targettablewidth, tableheight-44-20)];
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=NO;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showIndividualTable){
        [IndividualTable setFrame:CGRectMake(0, 44+84+20, individualtablewidth, tableheight-44-84-20)];
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=NO;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showRecipientListTable){
        [RecipientListTable setFrame:CGRectMake(0, 44+84+20, individualtablewidth, tableheight-44-84-20)];
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=NO;
        CenterMasterView.hidden=YES;
    }else if (showSubjectTable){
        [SubjectTable setFrame:CGRectMake(0, 44+84+20, subjecttablewidth, tableheight-44-84-20)];
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=NO;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showInstructorTable){
        [InstructorTable setFrame:CGRectMake(0, 44+84+20, instructortablewidth, tableheight-44-84-20)];
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=NO;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showClassDateTable){
        [ClassDateTable setFrame:CGRectMake(0, 44+20, classdatetablewidth, tableheight-44-20)];
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=NO;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showGradeTable){
        [GradeTable setFrame:CGRectMake(0, 44+20, gradetablewidth, tableheight-44-20)];
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=NO;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showLeadStatusTable){
        [LeadStatusTable setFrame:CGRectMake(0, 44+20, leadstatustablewidth, tableheight-44-20)];
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=NO;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showStudentStatusTable){
        [StudentStatusTable setFrame:CGRectMake(0, 44+20, studentstatustablewidth, tableheight-44-20)];
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=NO;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showStaffGroupTable){
        [StaffGroupTable setFrame:CGRectMake(0, 44+20, staffgrouptablewidth, tableheight-44-20)];
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=NO;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showStartTimeTable){
        [StartTimeTable setFrame:CGRectMake(0, 44+20, starttimetablewidth, tableheight-44-20)];
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=NO;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showDropTable){
        [DropTable setFrame:CGRectMake(0, 44+20, droptablewidth, tableheight-44-20)];
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=NO;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showReadStatusTable){
        [ReadStatusTable setFrame:CGRectMake(0, 44+84+20, readstatustablewidth, tableheight-44-84-20)];
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=NO;
        if (showReadStatusContactTable) {
            [ReadStatusContactTable setFrame:CGRectMake(0, 44+20, readstatuscontacttablewidth, tableheight-44-20)];
            ReadStatusContactTableMasterView.hidden=NO;
        }else{
            ReadStatusContactTableMasterView.hidden=YES;
        }
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showMessagePhoto){
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=NO;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }else if (showCenterTable){
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=NO;
    }else{
        MessageTypeTableMasterView.hidden=YES;
        TargetTableMasterView.hidden=YES;
        IndividualTableMasterView.hidden=YES;
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LeadStatusTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        StaffGroupTableMasterView.hidden=YES;
        StartTimeTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ReadStatusTableMasterView.hidden=YES;
        ReadStatusContactTableMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        RecipientListTableMasterView.hidden=YES;
        CenterMasterView.hidden=YES;
    }
}

/*
-(void) storeTmpField
{
    if (MessageEnglishText) {workingMessage.messageenglish=MessageEnglishText.text;}
    if (MessageChineseText) {workingMessage.messagechinese=MessageChineseText.text;}
}*/

-(BOOL) InitializeField
{
    if (!globalvariables) {
        globalvariables=[GlobalVariables singleObj];
    }
    
    [self showsidewindowwithwindow:@"none"];
    
    //initialize field
    
    if ([MessageTableMode isEqualToString:@"Add"]) {
        
        workingMessage.messagetype=@"General";
        
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        workingMessage.messagestarttime=[df stringFromDate:[NSDate date]];
        workingMessage.messageenglish=@"";
        workingMessage.messagechinese=@"";
        workingMessage.recipienttype=@"Student";
        workingMessage.hotnews=[CallingSource isEqualToString:@"NotificationView"];
        workingMessage.hn_expiry_date=[MyClass convertToNSStringWithNSDate:[[NSDate date] dateByAddingTimeInterval:14*24*60*60] DateFormat:@"yyyy-MM-dd"];
        workingMessage.recipientgroup=[[RecipientGroupRecord alloc]init];
        workingMessage.recipientgroup.subjectarray=[[NSMutableArray alloc]init];
        workingMessage.recipientgroup.instructorarray=[[NSMutableArray alloc]init];
        workingMessage.recipientgroup.classdatearray=[[NSMutableArray alloc]init];
        workingMessage.recipientgroup.gradearray=[[NSMutableArray alloc]init];
        workingMessage.recipientgroup.individualarray=[[NSMutableArray alloc]init];
        workingMessage.recipientgroup.leadstatusarray=[[NSMutableArray alloc]init];
        workingMessage.recipientgroup.studentstatusarray=[[NSMutableArray alloc]init];
        workingMessage.recipientgroup.staffgrouparray=[[NSMutableArray alloc]init];
        workingMessage.channel=globalvariables.centerrecord.defaultstudentmessagechannel;//[self returnChannelCodeWithIndex:[MyClass getlocaldbwithparameter:@"defaultstudentmessagechannel"]];

        workingMessage.recipientgroup.droparray=[[NSMutableArray alloc]initWithObjects:@"Non Drop", nil];
        workingMessage.photoarray=[[NSMutableArray alloc]init];
        
        if (OMessageRecordObject) {
            if([CallingSource isEqualToString:@"NotificationView"]){
                workingMessage.photoarray=OMessageRecordObject.photoarray;
                photoimagechanged=TRUE;
            }else{
                workingMessage.photoarray=OMessageRecordObject.photoarray;
                photoimagechanged=TRUE;
                workingMessage.messageenglish=OMessageRecordObject.messageenglish;
                workingMessage.messagechinese=OMessageRecordObject.messagechinese;
                workingMessage.recipienttype=OMessageRecordObject.recipienttype;
                workingMessage.recipientgroup.individualarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.individualarray];
                workingMessage.channel=@"A";
            }
        }
        [self retrievemessagerecipientwithcallingsource:workingMessage.recipienttype];
        [self returnAvailableCenterArray];
        
        [self createAddBarButton];
    }else if ([MessageTableMode isEqualToString:@"View"]){
        workingMessage.messagetype=OMessageRecordObject.messagetype;
        //tmpReceipent=MessageRecordObject.messagereceipient;
        workingMessage.messagestarttime=OMessageRecordObject.messagestarttime;
        workingMessage.messageenglish=OMessageRecordObject.messageenglish;
        workingMessage.messagechinese=OMessageRecordObject.messagechinese;
        workingMessage.status=OMessageRecordObject.status;
        workingMessage.channel=OMessageRecordObject.channel;
        workingMessage.automessageflag=OMessageRecordObject.automessageflag;
        
        workingMessage.recipienttype=OMessageRecordObject.recipienttype;
        workingMessage.recipientgroup=[[RecipientGroupRecord alloc]init];
        workingMessage.recipientgroup.subjectarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.subjectarray];
        workingMessage.recipientgroup.instructorarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.instructorarray];
        workingMessage.recipientgroup.classdatearray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.classdatearray];
        workingMessage.recipientgroup.gradearray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.gradearray];
        workingMessage.recipientgroup.individualarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.individualarray];
        workingMessage.recipientgroup.leadstatusarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.leadstatusarray];
        workingMessage.recipientgroup.studentstatusarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.studentstatusarray];
        workingMessage.recipientgroup.staffgrouparray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.staffgrouparray];
        workingMessage.recipientgroup.droparray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.droparray];
        workingMessage.photoarray=[MyClass copyPhotoArrayWithPhotoArray:OMessageRecordObject.photoarray LoadInternalURL:NO];
        workingMessage.hotnews=OMessageRecordObject.hotnews;
        workingMessage.hn_expiry_date=OMessageRecordObject.hn_expiry_date;

        [self retrievemessagerecipientwithcallingsource:workingMessage.recipienttype];
        
        [self createViewBarButton];
    }else if ([MessageTableMode isEqualToString:@"Edit"]){
        //[self loadcalendar];
        [self showsidewindowwithwindow:@"none"];
        workingMessage.photoarray=[MyClass copyPhotoArrayWithPhotoArray:OMessageRecordObject.photoarray LoadInternalURL:NO];
        [self retrievemessagerecipientwithcallingsource:workingMessage.recipienttype];
        
        [self createEditBarButton];
    }else if ([MessageTableMode isEqualToString:@"Copy"]){
        //[self loadcalendar];
        
        [self showsidewindowwithwindow:@"none"];
        
        workingMessage.messagetype=OMessageRecordObject.messagetype;
        //tmpReceipent=MessageRecordObject.messagereceipient;
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        workingMessage.messagestarttime=[df stringFromDate:[NSDate date]];
        workingMessage.messageenglish=OMessageRecordObject.messageenglish;
        workingMessage.messagechinese=OMessageRecordObject.messagechinese;
        workingMessage.hotnews=OMessageRecordObject.hotnews;
        workingMessage.hn_expiry_date=OMessageRecordObject.hn_expiry_date;
        
        workingMessage.recipienttype=OMessageRecordObject.recipienttype;
        workingMessage.recipientgroup=[[RecipientGroupRecord alloc]init];
        
        workingMessage.recipientgroup.subjectarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.subjectarray];
        workingMessage.recipientgroup.instructorarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.instructorarray];
        workingMessage.recipientgroup.classdatearray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.classdatearray];
        workingMessage.recipientgroup.gradearray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.gradearray];
        workingMessage.recipientgroup.individualarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.individualarray];
        workingMessage.recipientgroup.leadstatusarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.leadstatusarray];
        workingMessage.recipientgroup.studentstatusarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.studentstatusarray];
        workingMessage.recipientgroup.staffgrouparray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.staffgrouparray];
        workingMessage.recipientgroup.droparray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.droparray];
        workingMessage.photoarray=[MyClass copyPhotoArrayWithPhotoArray:OMessageRecordObject.photoarray LoadInternalURL:YES];
        workingMessage.channel=OMessageRecordObject.channel;
        
        if (workingMessage.photoarray.count>0) {
            photoimagechanged=YES;
        }
        
        [self retrievemessagerecipientwithcallingsource:workingMessage.recipienttype];
        [self returnAvailableCenterArray];
        [self createAddBarButton];
    }else if ([MessageTableMode isEqualToString:@"RemoteAdd"]){
        //[self loadcalendar];
        
        [self showsidewindowwithwindow:@"none"];
        
        workingMessage.messagetype=OMessageRecordObject.messagetype;
        workingMessage.messagestarttime=OMessageRecordObject.messagestarttime;
        workingMessage.messageenglish=OMessageRecordObject.messageenglish;
        workingMessage.messagechinese=OMessageRecordObject.messagechinese;
        //tmpCallingKey=[[NSMutableArray alloc]initWithObjects:MessageRecordObject.studentkey,nil];
        workingMessage.hotnews=NO;
        workingMessage.hn_expiry_date=@"";
        
        workingMessage.recipienttype=OMessageRecordObject.recipienttype;
        workingMessage.recipientgroup=[[RecipientGroupRecord alloc]init];
        workingMessage.recipientgroup.subjectarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.subjectarray];
        workingMessage.recipientgroup.instructorarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.instructorarray];
        workingMessage.recipientgroup.classdatearray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.classdatearray];
        workingMessage.recipientgroup.gradearray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.gradearray];
        workingMessage.recipientgroup.individualarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.individualarray];
        workingMessage.recipientgroup.leadstatusarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.leadstatusarray];
        workingMessage.recipientgroup.studentstatusarray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.studentstatusarray];
        workingMessage.recipientgroup.staffgrouparray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.staffgrouparray];
        workingMessage.recipientgroup.droparray=[[NSMutableArray alloc]initWithArray:OMessageRecordObject.recipientgroup.droparray];
        workingMessage.photoarray=[MyClass copyPhotoArrayWithPhotoArray:OMessageRecordObject.photoarray LoadInternalURL:YES];
        workingMessage.channel=OMessageRecordObject.channel;
        
        if (workingMessage.photoarray.count>0) {
            photoimagechanged=YES;
        }
        
        [self retrievemessagerecipientwithcallingsource:workingMessage.recipienttype];
        
        [self createAddBarButton];
    }
    
    [self updateTableRowArray];
    
    return YES;
    
    
}

-(NSString *) returnChannelCodeWithIndex:(NSString *)index
{
    if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
        if([index isEqualToString:@"0"]){
            return @"AS";
        }else if([index isEqualToString:@"1"]){
            return @"A";
        }else if([index isEqualToString:@"2"]){
            return @"S";
        }else if([index isEqualToString:@"3"]){
            return @"E";
        }
    }else if ([workingMessage.recipienttype isEqualToString:@"Lead"]) {
        if([index isEqualToString:@"0"]){
            return @"S";
        }else if([index isEqualToString:@"1"]){
            return @"E";
        }
    }
    return @"";
}

-(NSInteger) returnChannelIndex
{
    if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
        if ([workingMessage.channel isEqualToString:@"AS"]) {
            return 0;
        }else if ([workingMessage.channel isEqualToString:@"A"]) {
            return 1;
        }else if ([workingMessage.channel isEqualToString:@"S"]) {
            return 2;
        }else if ([workingMessage.channel isEqualToString:@"E"]){
            return 3;
        }
    }else if ([workingMessage.recipienttype isEqualToString:@"Lead"]) {
        if ([workingMessage.channel isEqualToString:@"S"]) {
            return 0;
        }else if ([workingMessage.channel isEqualToString:@"E"]) {
            return 1;
        }
    }else{
        if ([workingMessage.channel isEqualToString:@"A"]) {
            return 0;
        }else if ([workingMessage.channel isEqualToString:@"S"]) {
            return 1;
        }else if ([workingMessage.channel isEqualToString:@"E"]){
            return 2;
        }
    }
    return 0;
}

-(NSString *) returnChannelNameWithChannelCode:(NSString *)code
{
    if ([code isEqualToString:@"A"]) {
        return @"App";
    }else if ([code isEqualToString:@"AS"]){
        return @"App/SMS";
    }else if ([code isEqualToString:@"S"]){
        return @"SMS";
    }else{
        return @"Email";
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==MessagePopoverTable) {
        if ([MessageTableMode isEqualToString:@"View"] && [MyClass isMessageSentWithMessageSentTime:workingMessage.messagestarttime] && ![workingMessage.status isEqualToString:@"D"] && ([workingMessage.recipienttype isEqualToString:@"Student"]|| [workingMessage.recipienttype isEqualToString:@"Staff"]) && ([OMessageRecordObject.channel isEqualToString:@"A"] || [OMessageRecordObject.channel isEqualToString:@"AS"])) {
            return 8;
        }else{
            return 8;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==MessagePopoverTable) {
        if (section==0) {
            return recipientRowDataArray.count;
        }else{
            if ([MessageTableMode isEqualToString:@"View"]) {
                if (section==6){
                    return workingMessage.hotnews?2:1;
                }
            }else{
                if (section==7){
                    return workingMessage.hotnews?2:1;
                }
            }
        }
        return 1;
    }else if (tableView==MessageTypeTable){
        return messagetypearray.count;
    }else if (tableView==TargetTable){
        return targetarray.count;
    }else if (tableView==IndividualTable){
        return filteredindividualarray.count;
    }else if (tableView==RecipientListTable){
        return filteredrecipientlistarray.count;
    }else if (tableView==SubjectTable){
        return filteredsubjectarray.count;
    }else if (tableView==InstructorTable){
        return filteredinstructorarray.count;
    }else if (tableView==ClassDateTable){
        return showClassDateTable?1:0;
    }else if (tableView==GradeTable){
        return gradearray.count;
    }else if (tableView==LeadStatusTable){
        return leadstatusarray.count;
    }else if (tableView==StudentStatusTable){
        return studentstatusarray.count;
    }else if (tableView==StaffGroupTable){
        return staffgrouparray.count;
    }else if (tableView==DropTable){
        return droparray.count;
    }else if (tableView==ReadStatusTable){
        return filteredreadstatusarray.count;
    }else if (tableView==StartTimeTable){
        return showStartTimeTable?1:0;
    }else if (tableView==ReadStatusContactTable){
        return readstatuscontactarray.count;
    }else if(tableView==centertable){
        return filteredCenterArray.count;
    }
    return 0;

}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==MessagePopoverTable) {
        if ([MessageTableMode isEqualToString:@"View"]) {
            if(section==0){
                return [MyClass returntitlewithtitle:@"Recipient"];
            }else if (section==1) {
                return [MyClass returntitlewithtitle:@"Channel"];
            }else if(section==2){
                return [MyClass returntitlewithtitle:@"Message Time"];
            }else if (section==3){
                return [MyClass returntitlewithtitle:@"Message (English)"];
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Message (Chinese)"];
            }else if (section==5){
                return (workingMessage.photoarray.count==0)?nil:[MyClass returntitlewithtitle:@"Attachments"];
            }else if (section==6){
                return [MyClass returntitlewithtitle:@"Hot News"];
            }else{
                return [MyClass returntitlewithtitle:@"Read Status"];
            }
        }else{
            if(section==0){
                return [MyClass returntitlewithtitle:@"Recipient"];
            }else if (section==1) {
                return @" ";
            }else if (section==2) {
                return [MyClass returntitlewithtitle:@"Channel"];
            }else if(section==3){
                return [MyClass returntitlewithtitle:@"Message Time"];
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Message (English)"];
            }else if (section==5){
                return [MyClass returntitlewithtitle:@"Message (Chinese)"];
            }else if (section==6){
                return [MyClass returntitlewithtitle:@"Attachments"];
            }else if (section==7){
                return [MyClass returntitlewithtitle:@"Hot News"];
            }else{
                return [MyClass returntitlewithtitle:@"Read Status"];
            }
        }

    }else if (tableView==MessageTypeTable){
        return [MyClass returntitlewithtitle:@"Message Type"];
    }else if (tableView==TargetTable){
        return [MyClass returntitlewithtitle:@"Target"];
    }else if (tableView==ClassDateTable){
        if ([selectedItem isEqualToString:@"ClassDate"]) {
            return [MyClass returntitlewithtitle:@"Class Date"];
        }else{
            return [MyClass returntitlewithtitle:@"Expiry Date"];
        }
    }else if (tableView==GradeTable){
        return [MyClass returntitlewithtitle:@"Grade"];
    }else if (tableView==LeadStatusTable){
        return [MyClass returntitlewithtitle:@"Status"];
    }else if (tableView==StudentStatusTable){
        return [MyClass returntitlewithtitle:@"Status"];
    }else if (tableView==StaffGroupTable){
        return [MyClass returntitlewithtitle:@"Group"];
    }else if (tableView==StartTimeTable){
        return [MyClass returntitlewithtitle:@"Schedule Send Time"];
    }else if (tableView==DropTable){
        return [MyClass returntitlewithtitle:@"Drop"];
    }else if (tableView==ReadStatusContactTable){
        return [MyClass returntitlewithtitle:@"iParent Users"];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *headerTitle = [self tableView:tableView titleForHeaderInSection:section];
    
    if (headerTitle) {
        UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        header.backgroundColor=[UIColor systemGroupedBackgroundColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
        label.text=[[MyClass returntitlewithtitle:headerTitle] uppercaseString];;
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor grayColor];
        [header addSubview:label];
        return header;
    }

    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==MessagePopoverTable) {
        
        //if (indexPath.section==5){
            if([MessageTableMode isEqualToString:@"View"]){
                if (indexPath.section==5) {
                    if (workingMessage.photoarray.count==0){
                        return CGFLOAT_MIN;
                    }
                    return ((workingMessage.photoarray.count-1)/4+1)*80;
                }

            }else{
                if (indexPath.section==6) {
                    return ((workingMessage.photoarray.count)/4+1)*80;
                }
            }
        //}
        
        return UITableViewAutomaticDimension;
    }else if (tableView==IndividualTable){
        return 44;
    }else if (tableView==RecipientListTable){
        return 44;
    }else if (tableView==StartTimeTable){
        return 402;
    }else if (tableView==ReadStatusTable){
        return 44;
    }else if (tableView==ReadStatusContactTable){
        return 44;
    }else if (tableView==ClassDateTable){
        return ClassDateTableMasterView.frame.size.height-64;
    }else if (tableView==centertable){
        return UITableViewAutomaticDimension;
    }
    return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==SubjectTable) {
        return CGFLOAT_MIN;
    }else if (tableView==IndividualTable) {
        return CGFLOAT_MIN;
    }else if (tableView==RecipientListTable) {
        return CGFLOAT_MIN;
    }else if (tableView==InstructorTable) {
        return CGFLOAT_MIN;
    }else if (tableView==ReadStatusTable) {
        return CGFLOAT_MIN;
    }else if (tableView==MessagePopoverTable){
        if ([MessageTableMode isEqualToString:@"View"]) {
            if (section==5) {
                if (workingMessage.photoarray.count==0) {
                    return CGFLOAT_MIN;
                }
            }
        }else{
            if (section==1) {
                return 15;
            }
        }
    }else if (tableView==centertable) {
        return CGFLOAT_MIN;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView numberOfSections]-1==section) {
        return 30;
    }else{
        return CGFLOAT_MIN;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UITableViewCell *cell;
    
    if(tableView==centertable){
        MyTableViewCell *myCell;
        static NSString *CellIdentifier = @"centercell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CenterRecord *centerobject=[filteredCenterArray objectAtIndex:indexPath.row];
        [MyClass downloadImageWithImageview:myCell.imageview1 gender:nil type:@"centerimage" typekey:centerobject.launchimage_landscape image:@"Yes" async:YES];
        
        myCell.label1.text=[MyClass returncentershortnamewithcenterkey:centerobject.centerkey];
        myCell.imageview2.hidden=!([selectedCenters containsObject:centerobject.centerkey] || (selectedCenters && selectedCenters.count==0));
        
        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return myCell;
        
    }else if (tableView==MessagePopoverTable) {
        MyTableViewCell *myCell;
        
        if ([MessageTableMode isEqualToString:@"View"]) {
            //if (cell == nil) {
            
            
            
            if (indexPath.section==0) {
                if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"MessageType"]){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Message Type"];
                    if ([workingMessage.messagetype isEqualToString:@"General"]) {
                        myCell.label2.textColor=[UIColor darkGrayColor];
                    }else if ([workingMessage.messagetype isEqualToString:@"Important"]) {
                        myCell.label2.textColor=[UIColor redColor];
                    }else{
                        myCell.label2.textColor=[UIColor orangeColor];
                    }
                    myCell.label2.text=[MyClass returntitlewithtitle:workingMessage.messagetype];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"RecipientType"]){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Target"];
                    myCell.label2.text=[MyClass returntitlewithtitle:workingMessage.recipienttype];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Individual"]){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Individual"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"Individual"];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Subject"]){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Subject"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"Subject"];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Instructor"]){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Instructor"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"Instructor"];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"ClassDate"]){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Class Date"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"ClassDate"];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Grade"]){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Grade"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"Grade"];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"StudentStatus"]){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Status"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"StudentStatus"];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Drop"]){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Drop"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"Drop"];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"LeadStatus"]){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Status"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"LeadStatus"];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"StaffGroup"]){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Group"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"StaffGroup"];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==1){
                static NSString *CellIdentifier = @"segmentcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
                    [myCell.segmentedcontrol1 removeAllSegments];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"App/SMS" atIndex:0 animated:NO];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"App" atIndex:1 animated:NO];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"SMS" atIndex:2 animated:NO];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"Email" atIndex:3 animated:NO];
                    
                }else if ([workingMessage.recipienttype isEqualToString:@"Lead"]){
                    [myCell.segmentedcontrol1 removeAllSegments];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"SMS" atIndex:0 animated:NO];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"Email" atIndex:1 animated:NO];
                }else if ([workingMessage.recipienttype isEqualToString:@"Staff"]){
                    [myCell.segmentedcontrol1 removeAllSegments];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"App" atIndex:0 animated:NO];
                }
                myCell.segmentedcontrol1.selectedSegmentIndex=[self returnChannelIndex];
                //[myCell.segmentedcontrol1 addTarget:self action:@selector(selectmessagechannel:) forControlEvents: UIControlEventValueChanged];
                //myCell.segmentedcontrol1.userInteractionEnabled=NO;
                myCell.segmentedcontrol1.enabled=NO;
                
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==2){
                static NSString *CellIdentifier = @"rolabellabelcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.label1.text=[MyClass returntitlewithtitle:@"Send Time"];
                myCell.label2.text=[MyClass convertDateFormatWithDate:workingMessage.messagestarttime FromDateFormat:@"yyyy-MM-dd HH:mm:ss" ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES];
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==3){
                static NSString *CellIdentifier = @"labelcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.label1.text=workingMessage.messageenglish;
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==4){
                static NSString *CellIdentifier = @"labelcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.label1.text=workingMessage.messagechinese;
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;;
            }else if (indexPath.section==5){
                static NSString *CellIdentifier = @"collectionviewcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.collectionview1.tag=100;
                
                //UICollectionViewFlowLayout *vfl=[[UICollectionViewFlowLayout alloc]init];
                //myCell.collectionview1.collectionViewLayout=vfl;
                UILongPressGestureRecognizer *longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongGesture:)];
                [myCell.collectionview1 addGestureRecognizer:longPressGesture];
                myCell.collectionview1.backgroundColor=[UIColor clearColor];
                [myCell.collectionview1 registerClass:[MessagePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
                [myCell.collectionview1 reloadData];
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==7){
                static NSString *CellIdentifier = @"labellabelcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.label1.text=[MyClass returntitlewithtitle:@"Read Status"];
                myCell.label2.text=@"";
                myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if (indexPath.section==6){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    //myCell.switch1.enabled=NO;
                    myCell.switch1.on=workingMessage.hotnews;
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(hotnewspressed:) forControlEvents:UIControlEventValueChanged];
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Post in Hot News"];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    if ([workingMessage.automessageflag isEqualToString:@"Y"] || [workingMessage.messagetype isEqualToString:@"Teacher Note"]) {
                        myCell.switch1.enabled=NO;
                    }else{
                        myCell.switch1.enabled=YES;
                    }
                    
                }else if (indexPath.row==1){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Expiry Date"];
                    myCell.label2.text=[workingMessage.hn_expiry_date isEqualToString:@""]?[MyClass returntitlewithtitle:@"None"]:[MyClass convertDateFormatWithDate:workingMessage.hn_expiry_date FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    myCell.hidden=!workingMessage.hotnews;
                }
            }
            
            return myCell;
            
            
        }else{// if([ClassTableMode isEqualToString:@"Edit"]){
            if (indexPath.section==0) {
                if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"MessageType"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Message Type"];
                    if ([workingMessage.messagetype isEqualToString:@"General"]) {
                        myCell.label2.textColor=[UIColor darkGrayColor];
                    }else if ([workingMessage.messagetype isEqualToString:@"Important"]) {
                        myCell.label2.textColor=[UIColor redColor];
                    }else{
                        myCell.label2.textColor=[UIColor orangeColor];
                    }
                    myCell.label2.text=[MyClass returntitlewithtitle:workingMessage.messagetype];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"RecipientType"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Target"];
                    myCell.label2.text=[MyClass returntitlewithtitle:workingMessage.recipienttype];
                    myCell.accessoryType=[CallingSource isEqualToString:@"NotificationView"]?UITableViewCellAccessoryNone: UITableViewCellAccessoryDisclosureIndicator;
                    myCell.selectionStyle=[CallingSource isEqualToString:@"NotificationView"]?UITableViewCellSelectionStyleNone: UITableViewCellSelectionStyleDefault;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Individual"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Individual"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"Individual"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Subject"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Subject"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"Subject"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Instructor"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Instructor"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"Instructor"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"ClassDate"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Class Date"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"ClassDate"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Grade"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Grade"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"Grade"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"StudentStatus"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Status"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"StudentStatus"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Drop"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Drop"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"Drop"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"LeadStatus"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Status"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"LeadStatus"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"StaffGroup"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Group"];
                    myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"StaffGroup"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Center"]) {
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Center"];
                    myCell.label2.text=[MyClass returncenternamewithcenterkeys:selectedCenters];;
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
            }else if (indexPath.section==1){
                static NSString *CellIdentifier = @"labellabelcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.label1.text=[MyClass returntitlewithtitle:@"Recipient"];
                myCell.label2.text=[MyClass returntitlewithtitle:@"Show"];
                myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }else if (indexPath.section==2){
                static NSString *CellIdentifier = @"segmentcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
                    [myCell.segmentedcontrol1 removeAllSegments];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"App/SMS" atIndex:0 animated:NO];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"App" atIndex:1 animated:NO];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"SMS" atIndex:2 animated:NO];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"Email" atIndex:3 animated:NO];
                    
                }else if ([workingMessage.recipienttype isEqualToString:@"Lead"]){
                    [myCell.segmentedcontrol1 removeAllSegments];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"SMS" atIndex:0 animated:NO];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"Email" atIndex:1 animated:NO];
                }else if ([workingMessage.recipienttype isEqualToString:@"Staff"]){
                    [myCell.segmentedcontrol1 removeAllSegments];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:@"App" atIndex:0 animated:NO];
                }
                myCell.segmentedcontrol1.selectedSegmentIndex=[self returnChannelIndex];
                [myCell.segmentedcontrol1 addTarget:self action:@selector(selectmessagechannel:) forControlEvents: UIControlEventValueChanged];
                myCell.segmentedcontrol1.userInteractionEnabled=YES;
                myCell.segmentedcontrol1.enabled=YES;
                
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==3){
                static NSString *CellIdentifier = @"labellabelcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.label1.text=[MyClass returntitlewithtitle:@"Send Time"];
                myCell.label2.text=[MyClass convertDateFormatWithDate:workingMessage.messagestarttime FromDateFormat:@"yyyy-MM-dd HH:mm:ss" ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES];
                myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }else if (indexPath.section==4){
                static NSString *CellIdentifier = @"remarkscell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.textview1.tag=0;
                myCell.textview1.text=workingMessage.messageenglish;
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==5){
                static NSString *CellIdentifier = @"remarkscell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.textview1.tag=1;
                myCell.textview1.text=workingMessage.messagechinese;
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;;
            }else if (indexPath.section==6){
                static NSString *CellIdentifier = @"collectionviewcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.collectionview1.tag=100;
                
                //UICollectionViewFlowLayout *vfl=[[UICollectionViewFlowLayout alloc]init];
                //myCell.collectionview1.collectionViewLayout=vfl;
                UILongPressGestureRecognizer *longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongGesture:)];
                [myCell.collectionview1 addGestureRecognizer:longPressGesture];
                myCell.collectionview1.backgroundColor=[UIColor clearColor];
                [myCell.collectionview1 registerClass:[MessagePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
                
                [myCell.collectionview1 reloadData];
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;;
            }else if (indexPath.section==7){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.switch1.on=workingMessage.hotnews;
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(hotnewspressed:) forControlEvents:UIControlEventValueChanged];
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Post in Hot News"];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    if ([workingMessage.automessageflag isEqualToString:@"Y"] || [workingMessage.messagetype isEqualToString:@"Teacher Note"]) {
                        myCell.switch1.enabled=NO;
                    }else{
                        myCell.switch1.enabled=YES;
                    }
                }else if (indexPath.row==1){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Expiry Date"];
                    myCell.label2.text=[workingMessage.hn_expiry_date isEqualToString:@""]?[MyClass returntitlewithtitle:@"None"]:[MyClass convertDateFormatWithDate:workingMessage.hn_expiry_date FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    myCell.hidden=!workingMessage.hotnews;
                }
            }
            
            
            return myCell;
            
        }
        
    }else if (tableView==MessageTypeTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *messagetypename;
        UIImageView *messagetypeselected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            messagetypename = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 38)];
            messagetypename.font=[UIFont systemFontOfSize:15];
            messagetypename.textColor=[UIColor darkGrayColor];
            messagetypename.tag=1200;
            [cell.contentView addSubview:messagetypename];
            
            messagetypeselected = [[UIImageView alloc]initWithFrame:CGRectMake(messagetypetablewidth-45, 7, 24, 24)];
            [messagetypeselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            messagetypeselected.tag=1202;
            [cell.contentView addSubview:messagetypeselected];
        }else{
            messagetypename=(UILabel *)[cell.contentView viewWithTag:1200];
            messagetypeselected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        messagetypename.text=[MyClass returntitlewithtitle:[messagetypearray objectAtIndex:indexPath.row]];
        messagetypeselected.hidden=[[messagetypearray objectAtIndex:indexPath.row] isEqualToString:workingMessage.messagetype]?NO:YES;
        

        
    }else if (tableView==TargetTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *targetname;
        UIImageView *targetselected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            targetname = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 38)];
            targetname.font=[UIFont systemFontOfSize:15];
            targetname.textColor=[UIColor darkGrayColor];
            targetname.tag=1200;
            [cell.contentView addSubview:targetname];
            
            targetselected = [[UIImageView alloc]initWithFrame:CGRectMake(targettablewidth-45, 7, 24, 24)];
            [targetselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            targetselected.tag=1202;
            [cell.contentView addSubview:targetselected];
        }else{
            targetname=(UILabel *)[cell.contentView viewWithTag:1200];
            targetselected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        targetname.text=[MyClass returntitlewithtitle:[targetarray objectAtIndex:indexPath.row]];
        targetselected.hidden=[[targetarray objectAtIndex:indexPath.row] isEqualToString:workingMessage.recipienttype]?NO:YES;
        
        
    }else if (tableView==SubjectTable){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *subjectcode;
        UILabel *subjectname;
        UIImageView *subjectselected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            subjectcode = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 65, 38)];
            subjectcode.font=[UIFont systemFontOfSize:15];
            subjectcode.textColor=[UIColor darkGrayColor];
            subjectcode.tag=1200;
            [cell.contentView addSubview:subjectcode];
            
            subjectname = [[UILabel alloc]initWithFrame:CGRectMake(85, 0, subjecttablewidth-100-30, 38)];
            subjectname.font=[UIFont systemFontOfSize:15];
            subjectname.textColor=[UIColor darkGrayColor];
            subjectname.tag=1201;
            [cell.contentView addSubview:subjectname];
            
            subjectselected = [[UIImageView alloc]initWithFrame:CGRectMake(subjecttablewidth-45, 7, 24, 24)];
            [subjectselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            subjectselected.tag=1202;
            [cell.contentView addSubview:subjectselected];
        }else{
            subjectcode=(UILabel *)[cell.contentView viewWithTag:1200];
            subjectname=(UILabel *)[cell.contentView viewWithTag:1201];
            subjectselected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        subjectcode.text=((SubjectRecord *)[filteredsubjectarray objectAtIndex:indexPath.row]).subject_shortname;
        subjectname.text=[MyClass returnsubjectnamewithsubject_shortname:subjectcode.text centerkey:globalvariables.centerrecord.centerkey];
        subjectselected.hidden=[workingMessage.recipientgroup.subjectarray containsObject:((SubjectRecord *)[filteredsubjectarray objectAtIndex:indexPath.row]).subject_shortname]?NO:YES;
    }else if (tableView==InstructorTable){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *instructorname;
        UIImageView *instructorselected;
        UIImageView *avatar;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            avatar = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7, 24, 24)];
            avatar.layer.masksToBounds=YES;
            avatar.layer.cornerRadius=12;
            avatar.contentMode=UIViewContentModeScaleAspectFill;
            avatar.tag=1303;
            [cell.contentView addSubview:avatar];
            
            //add textfield
            instructorname = [[UILabel alloc]initWithFrame:CGRectMake(44, 0, instructortablewidth-30-29, 38)];
            instructorname.font=[UIFont systemFontOfSize:15];
            instructorname.textColor=[UIColor darkGrayColor];
            instructorname.tag=1301;
            [cell.contentView addSubview:instructorname];
            
            instructorselected = [[UIImageView alloc]initWithFrame:CGRectMake(instructortablewidth-45, 7, 24, 24)];
            [instructorselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            instructorselected.tag=1302;
            [cell.contentView addSubview:instructorselected];
        }else{
            instructorname=(UILabel *)[cell.contentView viewWithTag:1301];
            instructorselected=(UIImageView *)[cell.contentView viewWithTag:1302];
            avatar=(UIImageView *)[cell.contentView viewWithTag:1303];
        }
        
        [MyClass downloadImageWithImageview:avatar gender:nil type:@"staff" typekey:((Instructor *)[filteredinstructorarray objectAtIndex:indexPath.row]).username image:@"Yes" async:YES];
        instructorname.text=[MyClass returninstructornamewithusername:((Instructor *)[filteredinstructorarray objectAtIndex:indexPath.row]).username firstorfullname:@"full"];
        instructorselected.hidden=[workingMessage.recipientgroup.instructorarray containsObject:((Instructor *)[filteredinstructorarray objectAtIndex:indexPath.row]).username]?NO:YES;
    }else if (tableView==IndividualTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UILabel *idlabel;
        UIImageView *imageview;
        UIImageView *selected;
        Student *studentobject;
        Lead *leadobject;
        Staff *staffobject;
        //NSURL *url;
        NSString *gender;
        NSString *typekey;
        NSString *image;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(62, 2, 190, 21)];
            name.font=[UIFont systemFontOfSize:12];
            name.textColor=[UIColor blackColor];
            name.tag=701;
            name.numberOfLines=0;
            name.minimumScaleFactor=0.7;
            name.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:name];
            
            idlabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 10, 200, 12)];
            idlabel.font=[UIFont systemFontOfSize:10];
            idlabel.adjustsFontSizeToFitWidth=YES;
            idlabel.textColor=[UIColor grayColor];
            idlabel.tag=702;
            [cell.contentView addSubview:idlabel];
            
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 34, 34)];
            imageview.layer.cornerRadius=17;
            //imageview.backgroundColor=[UIColor lightGrayColor];
            imageview.tag=703;
            imageview.contentMode=UIViewContentModeScaleAspectFill;
            imageview.layer.masksToBounds=YES;
            [cell.contentView addSubview:imageview];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(individualtablewidth-45, 10, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=704;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:701];
            idlabel=(UILabel *)[cell.contentView viewWithTag:702];
            imageview=(UIImageView *)[cell.contentView viewWithTag:703];
            selected=(UIImageView *)[cell.contentView viewWithTag:704];
        }
        
        if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
            studentobject=[filteredindividualarray objectAtIndex:indexPath.row];
            name.text=[MyClass returnStudentnameWithStudentkey:studentobject.studentkey option:@"full"];
            idlabel.text=studentobject.studentid;
            selected.hidden=[workingMessage.recipientgroup.individualarray containsObject:studentobject.studentkey]?NO:YES;
            //url = [NSURL URLWithString:[NSString stringWithFormat:@"%@studentimages/%@/student_%@_%@.jpg",globalvariables.serverpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, studentobject.studentkey]];
            gender=studentobject.gender;
            image=studentobject.image;
            typekey=studentobject.studentkey;
            
        }else if ([workingMessage.recipienttype isEqualToString:@"Lead"]){
            leadobject=[filteredindividualarray objectAtIndex:indexPath.row];
            name.text=[MyClass returnLeadnameWithLeadkey:leadobject.leadkey option:@"full"];
            idlabel.text=leadobject.leadid;
            selected.hidden=[workingMessage.recipientgroup.individualarray containsObject:leadobject.leadkey]?NO:YES;
            //url = [NSURL URLWithString:[NSString stringWithFormat:@"%@leadimages/%@/lead_%@_%@.jpg",globalvariables.serverpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, leadobject.leadkey]];
            gender=leadobject.gender;
            image=leadobject.image;
            typekey=leadobject.leadkey;
        }else if ([workingMessage.recipienttype isEqualToString:@"Staff"]){
            staffobject=[filteredindividualarray objectAtIndex:indexPath.row];
            name.text=[MyClass returnstaffnamewithusername:staffobject.username firstorfullname:@"full"];
            idlabel.text=staffobject.username;
            selected.hidden=[workingMessage.recipientgroup.individualarray containsObject:staffobject.username]?NO:YES;
            //url = [NSURL URLWithString:[NSString stringWithFormat:@"%@staffimages/%@/staff_%@_%@.jpg",globalvariables.serverpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, staffobject.username]];
            gender=nil;
            image=@"Yes";
            typekey=staffobject.username;
        }
        
        if ([idlabel.text isEqualToString:@""]) {
            name.frame=CGRectMake(62,0,150,44);
        }else{
            name.frame=CGRectMake(62, 3, 150, 40);
            [name sizeToFit];
            
            if (name.frame.size.height>38-12-2) {
                name.frame=CGRectMake(62, 3, name.frame.size.width, 38-12-2);
            }else{
                name.frame=CGRectMake(62, (42-name.frame.size.height-2-12)/2, name.frame.size.width, name.frame.size.height);
            }
            
            idlabel.frame=CGRectMake(62, name.frame.origin.y+name.frame.size.height+2, 150, 12);
        }
        
        
        [MyClass downloadImageWithImageview:imageview gender:gender type:[workingMessage.recipienttype lowercaseString] typekey:typekey image:image async:YES];
        
        
        
    }else if (tableView==RecipientListTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UILabel *idlabel;
        UIImageView *imageview;
        Student *studentobject;
        Lead *leadobject;
        Staff *staffobject;
        NSString *gender;
        NSString *typekey;
        NSString *image;
        NSString *avatar;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(62, 2, 190, 21)];
            name.font=[UIFont systemFontOfSize:12];
            name.textColor=[UIColor blackColor];
            name.tag=701;
            name.numberOfLines=0;
            name.minimumScaleFactor=0.7;
            name.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:name];
            
            idlabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 10, 200, 12)];
            idlabel.font=[UIFont systemFontOfSize:10];
            idlabel.adjustsFontSizeToFitWidth=YES;
            idlabel.textColor=[UIColor grayColor];
            idlabel.tag=702;
            [cell.contentView addSubview:idlabel];
            
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 34, 34)];
            imageview.layer.cornerRadius=17;
            //imageview.backgroundColor=[UIColor lightGrayColor];
            imageview.tag=703;
            imageview.contentMode=UIViewContentModeScaleAspectFill;
            imageview.layer.masksToBounds=YES;
            [cell.contentView addSubview:imageview];
            
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:701];
            idlabel=(UILabel *)[cell.contentView viewWithTag:702];
            imageview=(UIImageView *)[cell.contentView viewWithTag:703];
        }
        
        if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
            studentobject=[filteredrecipientlistarray objectAtIndex:indexPath.row];
            Student *student=[MyClass returnstudentwithstudentkey:studentobject.studentkey];
            if (![student.centerkey isEqualToString:@""]) {
                name.text=[MyClass returnStudentnameWithStudentkey:studentobject.studentkey option:@"full"];
                idlabel.text=studentobject.studentid;
                gender=studentobject.gender;
                image=studentobject.image;
                typekey=studentobject.studentkey;
            }else{
                name.text=studentobject.firstname;
                idlabel.text=studentobject.studentid;
                gender=@"";
                image=studentobject.image;
                typekey=studentobject.studentkey;
                avatar=studentobject.avatar;
            }
        }else if ([workingMessage.recipienttype isEqualToString:@"Lead"]){
            leadobject=[filteredrecipientlistarray objectAtIndex:indexPath.row];
            Lead *lead=[MyClass returnleadwithleadkey:leadobject.leadkey];
            if (![lead.centerkey isEqualToString:@""]) {
                name.text=[MyClass returnLeadnameWithLeadkey:leadobject.leadkey option:@"full"];
                idlabel.text=leadobject.leadid;
                gender=leadobject.gender;
                image=leadobject.image;
                typekey=leadobject.leadkey;
            }else{
                name.text=leadobject.firstname;
                idlabel.text=leadobject.leadid;
                gender=nil;
                image=nil;
                typekey=leadobject.leadkey;
                avatar=leadobject.avatar;
            }
        }else if ([workingMessage.recipienttype isEqualToString:@"Staff"]){
            staffobject=[filteredrecipientlistarray objectAtIndex:indexPath.row];
            Staff *staff=[MyClass returnstaffrecordwithusername:staffobject.username];
            if(staff){
                name.text=[MyClass returnstaffnamewithusername:staffobject.username firstorfullname:@"full"];
                idlabel.text=staffobject.username;
                gender=nil;
                image=nil;
                typekey=staffobject.username;
            }else{
                name.text=staffobject.firstname;
                idlabel.text=staffobject.username;
                gender=nil;
                image=nil;
                typekey=staffobject.username;
                avatar=staffobject.avatar;
            }
        }
        
        if ([idlabel.text isEqualToString:@""]) {
            name.frame=CGRectMake(62,0,150,44);
        }else{
            name.frame=CGRectMake(62, 3, 150, 40);
            [name sizeToFit];
            
            if (name.frame.size.height>38-12-2) {
                name.frame=CGRectMake(62, 3, name.frame.size.width, 38-12-2);
            }else{
                name.frame=CGRectMake(62, (42-name.frame.size.height-2-12)/2, name.frame.size.width, name.frame.size.height);
            }
            
            idlabel.frame=CGRectMake(62, name.frame.origin.y+name.frame.size.height+2, 150, 12);
        }
        
        if(image){
            [MyClass downloadImageWithImageview:imageview gender:gender type:[workingMessage.recipienttype lowercaseString] typekey:typekey image:image async:YES];
        }else{
            [MyClass downloadAvatarWithImageview:imageview gender:@"" type:[workingMessage.recipienttype lowercaseString] avatar:avatar async:YES];
        }
        
        
        
        
    }else if (tableView==ClassDateTable) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        CalendarView *calendarview;
        if ([selectedItem isEqualToString:@"ClassDate"]) {
            calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, starttimetablewidth, ((CGRect)[tableView rectForRowAtIndexPath:indexPath]).size.height) Theme:3 CanPickHoliday:NO MultipleSelection:YES ShowTodayButton:NO showclassdot:NO schedulerecord:nil  UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
            [calendarview scrollToSelectedDateWithSelectedDateArray:workingMessage.recipientgroup.classdatearray.count>0?workingMessage.recipientgroup.classdatearray:nil ScrollToDate:workingMessage.recipientgroup.classdatearray.count>0?nil:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] instructorselected:nil];
        }else if ([selectedItem isEqualToString:@"ExpiryDate"]){
            calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, starttimetablewidth, ((CGRect)[tableView rectForRowAtIndexPath:indexPath]).size.height) Theme:3 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil  UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
            if ([workingMessage.hn_expiry_date isEqualToString:@""]) {
                [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]init] ScrollToDate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] instructorselected:nil];
            }else{
                [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:workingMessage.hn_expiry_date FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO], nil] ScrollToDate:nil instructorselected:nil];
            }
        }

        calendarview.delegate=self;

        [cell.contentView addSubview:calendarview];

        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }else if (tableView==GradeTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(gradetablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        name.text=[MyClass returntitlewithtitle:[gradearray objectAtIndex:indexPath.row]];
        selected.hidden=[workingMessage.recipientgroup.gradearray containsObject:[gradearray objectAtIndex:indexPath.row]]?NO:YES;
    }else if (tableView==LeadStatusTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(gradetablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        name.text=[MyClass returntitlewithtitle:[leadstatusarray objectAtIndex:indexPath.row]];
        selected.hidden=[workingMessage.recipientgroup.leadstatusarray containsObject:[leadstatusarray objectAtIndex:indexPath.row]]?NO:YES;
    }else if (tableView==StudentStatusTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(studentstatustablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        name.text=[MyClass returntitlewithtitle:[studentstatusarray objectAtIndex:indexPath.row]];
        selected.hidden=[workingMessage.recipientgroup.studentstatusarray containsObject:[studentstatusarray objectAtIndex:indexPath.row]]?NO:YES;
    }else if (tableView==DropTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(droptablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        name.text=[MyClass returntitlewithtitle:[droparray objectAtIndex:indexPath.row]];
        selected.hidden=[workingMessage.recipientgroup.droparray containsObject:[droparray objectAtIndex:indexPath.row]]?NO:YES;
    }else if (tableView==StaffGroupTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(gradetablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        name.text=((GroupRecord *)[staffgrouparray objectAtIndex:indexPath.row]).groupname;
        selected.hidden=![workingMessage.recipientgroup.staffgrouparray containsObject:((GroupRecord *)[staffgrouparray objectAtIndex:indexPath.row]).groupkey];
    }else if (tableView==StartTimeTable){
        
        selectedItem=@"MessageStartTime";
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        
        CalendarView *calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 40, starttimetablewidth, 200) Theme:0 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil  UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
        [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:[workingMessage.messagestarttime substringToIndex:10]],nil] ScrollToDate:nil instructorselected:nil];
        calendarview.delegate=self;

        [cell.contentView addSubview:calendarview];
        
        
        hourPresetRow=(int)[hourPickerViewMenu indexOfObject:[[workingMessage.messagestarttime substringFromIndex:[workingMessage.messagestarttime length]-8] substringToIndex:2]];
        minutePresetRow=(int)[minutePickerViewMenu indexOfObject:[[workingMessage.messagestarttime substringFromIndex:[workingMessage.messagestarttime length]-5] substringToIndex:2]];
        
        myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 240, starttimetablewidth, 162)];
        myPicker.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.03];
        [myPicker setDataSource:self];
        [myPicker setDelegate:self];
        myPicker.tag=801;
        
        [myPicker selectRow:hourPresetRow inComponent:0 animated:NO];
        [myPicker selectRow:minutePresetRow inComponent:1 animated:NO];
        
        [myPicker setShowsSelectionIndicator:YES];
        myPickerView=myPicker;
        [cell.contentView addSubview:myPicker];
        
        scstarttimetype = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Now"],[MyClass returntitlewithtitle:@"Tomorrow"],nil]];
        scstarttimetype.frame = CGRectMake(20, 6, 279, 29);
        scstarttimetype.selectedSegmentIndex = UISegmentedControlNoSegment;
        [scstarttimetype addTarget:self action:@selector(selectstarttimetype:) forControlEvents: UIControlEventValueChanged];
        [cell.contentView addSubview:scstarttimetype];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else if (tableView==ReadStatusContactTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UILabel *idlabel;
        UIImageView *imageview;
        UILabel *readstatuslabel;
        UIImageView *readstatusimage;
        UIImageView *ccimage;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(62, 2, 190, 21)];
            name.font=[UIFont systemFontOfSize:12];
            name.textColor=[UIColor blackColor];
            name.tag=701;
            name.numberOfLines=0;
            name.minimumScaleFactor=0.7;
            name.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:name];
            
            idlabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 10, 200, 12)];
            idlabel.font=[UIFont systemFontOfSize:10];
            idlabel.adjustsFontSizeToFitWidth=YES;
            idlabel.textColor=[UIColor grayColor];
            idlabel.tag=702;
            [cell.contentView addSubview:idlabel];
            
            ccimage=[[UIImageView alloc]initWithFrame:CGRectMake(62, (34-18)/2, 15, 10)];
            ccimage.layer.cornerRadius=3;
            ccimage.tag=706;
            ccimage.contentMode=UIViewContentModeScaleAspectFill;
            ccimage.layer.masksToBounds=YES;
            [cell.contentView addSubview:ccimage];
            
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 34, 34)];
            imageview.layer.cornerRadius=17;
            imageview.backgroundColor=[UIColor lightGrayColor];
            imageview.tag=703;
            imageview.contentMode=UIViewContentModeScaleAspectFill;
            imageview.layer.masksToBounds=YES;
            [cell.contentView addSubview:imageview];
            
            readstatuslabel = [[UILabel alloc]initWithFrame:CGRectMake(readstatuscontacttablewidth-100-15-15, 22, 100, 15)];
            readstatuslabel.font=[UIFont systemFontOfSize:10];
            readstatuslabel.textColor=[UIColor grayColor];
            readstatuslabel.textAlignment=NSTextAlignmentRight;
            readstatuslabel.tag=704;
            [cell.contentView addSubview:readstatuslabel];
            
            readstatusimage=[[UIImageView alloc]initWithFrame:CGRectMake(readstatuscontacttablewidth-15-10, 22, 15, 15)];
            readstatusimage.tag=705;
            [cell.contentView addSubview:readstatusimage];
            
            
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:701];
            idlabel=(UILabel *)[cell.contentView viewWithTag:702];
            imageview=(UIImageView *)[cell.contentView viewWithTag:703];
            readstatuslabel=(UILabel *)[cell.contentView viewWithTag:704];
            readstatusimage=(UIImageView *)[cell.contentView viewWithTag:705];
            ccimage=(UIImageView *)[cell.contentView viewWithTag:706];
        }
        
        
        readstatusobject=[readstatuscontactarray objectAtIndex:indexPath.row];
        name.text=[MyClass returntitlewithtitle:readstatusobject.relationship];
        //idlabel.text=readstatusobject.recipientkey;
        idlabel.text=[MyClass returnLocalNumberWithContact:readstatusobject.recipientkey ISOCode:readstatusobject.iso_code];
        
        [MyClass downloadImageWithImageview:ccimage gender:nil type:@"flag" typekey:readstatusobject.iso_code image:@"Yes" async:YES];
        
        
        if ([idlabel.text isEqualToString:@""]) {
            name.frame=CGRectMake(62,0,150,44);
            ccimage.hidden=YES;
            idlabel.hidden=YES;
        }else{
            ccimage.hidden=NO;
            idlabel.hidden=NO;
            
            name.frame=CGRectMake(62, 3, 150, 40);
            [name sizeToFit];
            
            if (name.frame.size.height>38-12-2) {
                name.frame=CGRectMake(62, 3, name.frame.size.width, 38-12-2);
            }else{
                name.frame=CGRectMake(62, (42-name.frame.size.height-2-12)/2, name.frame.size.width, name.frame.size.height);
            }
            
            idlabel.frame=CGRectMake(62+15+2, name.frame.origin.y+name.frame.size.height+2, 150, 12);
            ccimage.frame=CGRectMake(62, idlabel.frame.origin.y+6-5, 15, 10);
        }
        
        if (![readstatusobject.channel isEqualToString:@"A"] ) {
            readstatuslabel.text=[NSString stringWithFormat:@"%@(SMS)",[MyClass returntitlewithtitle:@"NA"]];
            readstatusimage.hidden=YES;
        }else if ([readstatusobject.readtime isEqualToString:@""]){
            readstatusimage.hidden=NO;
            readstatuslabel.text=[MyClass returntitlewithtitle:@"Unread"];
            [readstatusimage setImage:[UIImage imageNamed:@"singlegraycheck_icon.png"]];
        }else{
            readstatusimage.hidden=NO;
            [readstatusimage setImage:[UIImage imageNamed:@"singlebluecheck_icon.png"]];
            readstatuslabel.text=[MyClass convertDateFormatWithDate:[readstatusobject.readtime substringToIndex:10] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
        }
        

        [imageview setImage:globalvariables.boyimage];
        

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }else if (tableView==ReadStatusTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UILabel *idlabel;
        UIImageView *imageview;
        Student *studentobject;
        //NSURL *url;
        UILabel *readstatuslabel;
        UIImageView *readstatusimage;
        UIImageView *disclosureimage;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(62, 2, 190, 21)];
            name.font=[UIFont systemFontOfSize:12];
            name.textColor=[UIColor blackColor];
            name.tag=701;
            name.numberOfLines=0;
            name.minimumScaleFactor=0.7;
            name.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:name];
            
            idlabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 10, 200, 12)];
            idlabel.font=[UIFont systemFontOfSize:10];
            idlabel.adjustsFontSizeToFitWidth=YES;
            idlabel.textColor=[UIColor grayColor];
            idlabel.tag=702;
            [cell.contentView addSubview:idlabel];
            
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 34, 34)];
            imageview.layer.cornerRadius=17;
            imageview.backgroundColor=[UIColor lightGrayColor];
            imageview.tag=703;
            imageview.contentMode=UIViewContentModeScaleAspectFill;
            imageview.layer.masksToBounds=YES;
            [cell.contentView addSubview:imageview];
            
            readstatuslabel = [[UILabel alloc]initWithFrame:CGRectMake(readstatustablewidth-100-15-15, 22, 100, 15)];
            readstatuslabel.font=[UIFont systemFontOfSize:10];
            readstatuslabel.textColor=[UIColor grayColor];
            readstatuslabel.textAlignment=NSTextAlignmentRight;
            readstatuslabel.tag=704;
            [cell.contentView addSubview:readstatuslabel];
            
            readstatusimage=[[UIImageView alloc]initWithFrame:CGRectMake(readstatustablewidth-18-10, 22, 17, 17)];
            readstatusimage.tag=705;
            [cell.contentView addSubview:readstatusimage];
            
            disclosureimage=[[UIImageView alloc]initWithFrame:CGRectMake(readstatustablewidth-8-10, 10, 8, 8)];
            [disclosureimage setImage:[UIImage imageNamed:@"openbutton_black.png"]];
            disclosureimage.alpha=0.4;
            disclosureimage.tag=706;
            [cell.contentView addSubview:disclosureimage];
            
            
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:701];
            idlabel=(UILabel *)[cell.contentView viewWithTag:702];
            imageview=(UIImageView *)[cell.contentView viewWithTag:703];
            readstatuslabel=(UILabel *)[cell.contentView viewWithTag:704];
            readstatusimage=(UIImageView *)[cell.contentView viewWithTag:705];
            disclosureimage=(UIImageView *)[cell.contentView viewWithTag:706];
        }
        
        
        readstatusobject=[filteredreadstatusarray objectAtIndex:indexPath.row];
        name.text=readstatusobject.recipientname;
        
        if ([OMessageRecordObject.recipienttype isEqualToString:@"Student"]) {
            idlabel.text=readstatusobject.recipientid;
            
            NSString *readstatus=[self returnreadstatussummarywithcontactgrouparray:readstatusobject.contactgroup];
            
            if ([readstatus isEqualToString:@"NA"] ) {
                readstatuslabel.text=[NSString stringWithFormat:@"%@(SMS)",[MyClass returntitlewithtitle:@"NA"]];
                readstatuslabel.hidden=NO;
                readstatusimage.hidden=YES;
            }else if ([readstatus isEqualToString:@"NR"]){
                readstatusimage.hidden=NO;
                [readstatusimage setImage:[UIImage imageNamed:@"doublegraycheck_icon.png"]];
                readstatuslabel.hidden=YES;
            }else if ([readstatus isEqualToString:@"SR"]){
                readstatusimage.hidden=NO;
                [readstatusimage setImage:[UIImage imageNamed:@"graybluecheck_icon.png"]];
                readstatuslabel.hidden=YES;
            }else{
                readstatusimage.hidden=NO;
                [readstatusimage setImage:[UIImage imageNamed:@"doublebluecheck_icon.png"]];
                readstatuslabel.hidden=YES;
            }
            
            studentobject=[MyClass returnstudentwithstudentkey:readstatusobject.recipientkey];
            
            
            [MyClass downloadImageWithImageview:imageview gender:studentobject.gender type:@"student" typekey:studentobject.studentkey image:studentobject.image async:YES];

            
        }else if ([OMessageRecordObject.recipienttype isEqualToString:@"Staff"]){
            idlabel.text=readstatusobject.recipientkey;
            if ([readstatusobject.readtime isEqualToString:@""]){
                readstatusimage.hidden=NO;
                [readstatusimage setImage:[UIImage imageNamed:@"singlegraycheck_icon.png"]];
                readstatuslabel.text=[MyClass returntitlewithtitle:@"Unread"];
            }else{
                readstatusimage.hidden=NO;
                [readstatusimage setImage:[UIImage imageNamed:@"singlebluecheck_icon.png"]];
                readstatuslabel.text=[MyClass convertDateFormatWithDate:[readstatusobject.readtime substringToIndex:10] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
            }
            [imageview setImage:globalvariables.boyimage];
        }
        
        
        
        
        if ([idlabel.text isEqualToString:@""]) {
            name.frame=CGRectMake(62,0,150,44);
        }else{
            name.frame=CGRectMake(62, 3, 150, 40);
            [name sizeToFit];
            
            if (name.frame.size.height>38-12-2) {
                name.frame=CGRectMake(62, 3, name.frame.size.width, 38-12-2);
            }else{
                name.frame=CGRectMake(62, (42-name.frame.size.height-2-12)/2, name.frame.size.width, name.frame.size.height);
            }
            
            idlabel.frame=CGRectMake(62, name.frame.origin.y+name.frame.size.height+2, 150, 12);
            
            
        }

        
        if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
            disclosureimage.hidden=NO;
        }else{
            disclosureimage.hidden=YES;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
    }

    return cell;

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==MessagePopoverTable) {
        if (![MessageTableMode isEqualToString:@"View"]) {
            if (indexPath.section==0) {
                if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Center"]) {
                    [self showsidewindowwithwindow:@"Center"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"MessageType"]) {
                    [self showsidewindowwithwindow:@"MessageType"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"RecipientType"]) {
                    if ([CallingSource isEqualToString:@"MessageView"]) {
                        [self showsidewindowwithwindow:@"Target"];
                        [MessagePopoverTable reloadData];
                        [self adjusttablesize];
                    }
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Individual"]) {
                    [self showsidewindowwithwindow:@"Individual"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Subject"]) {
                    [self showsidewindowwithwindow:@"Subject"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Instructor"]) {
                    [self showsidewindowwithwindow:@"Instructor"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"ClassDate"]) {
                    selectedItem=@"ClassDate";
                    [self showsidewindowwithwindow:@"ClassDate"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Grade"]) {
                    [self showsidewindowwithwindow:@"Grade"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"StudentStatus"]) {
                    [self showsidewindowwithwindow:@"StudentStatus"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Drop"]) {
                    [self showsidewindowwithwindow:@"Drop"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"LeadStatus"]) {
                    [self showsidewindowwithwindow:@"LeadStatus"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"StaffGroup"]) {
                    [self showsidewindowwithwindow:@"StaffGroup"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }
            }else{
                if (indexPath.section==3 && indexPath.row==0) {
                    selectedItem=@"MessageStartTime";
                    
                    if ([workingMessage.messagestarttime isEqualToString:@""]) {
                        //set to now
                        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        workingMessage.messagestarttime=[df stringFromDate:[NSDate date]];
                    }
                    [self showsidewindowwithwindow:@"StartTime"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if (indexPath.section==1 && indexPath.row==0) {
                    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self getmessagerecipientlist];
                        [self showsidewindowwithwindow:@"RecipientList"];
                        [MessagePopoverTable reloadData];
                        [self adjusttablesize];
                    });
                }else if (indexPath.section==7 && indexPath.row==1){
                    selectedItem=@"ExpiryDate";
                    [self showsidewindowwithwindow:@"ExpiryDate"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }
            }
        }else if ([MessageTableMode isEqualToString:@"View"]){
            if (indexPath.section==7 && indexPath.row==0) {
                [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self retrieveReadStatusWithOutboxMessageKey:OMessageRecordObject.outboxmessagekey];
                    [self showsidewindowwithwindow:@"ReadStatus"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                    [MyClass loadingindicatorwithoption:@"stop" color:nil];
                });
                
                
            }else if (indexPath.section==6 && indexPath.row==1){
                selectedItem=@"ExpiryDate";
                [self showsidewindowwithwindow:@"ExpiryDate"];
                [MessagePopoverTable reloadData];
                [self adjusttablesize];
            }
        }
    }else if (tableView==MessageTypeTable){
        if (![workingMessage.messagetype isEqualToString:[messagetypearray objectAtIndex:indexPath.row]]) {
            workingMessage.messagetype=[messagetypearray objectAtIndex:indexPath.row];
            
            //[self storeTmpField];
            [self updateTableRowArray];
            [MessagePopoverTable reloadData];
            [MessageTypeTable reloadData];
            
            [self adjusttablesize];
        }
    }else if (tableView==TargetTable){
        if (![workingMessage.recipienttype isEqualToString:[targetarray objectAtIndex:indexPath.row]]) {
            workingMessage.recipienttype=[targetarray objectAtIndex:indexPath.row];
            //tmpMessageChannel=0;
            workingMessage.recipientgroup.individualarray=[[NSMutableArray alloc]init];
            
            
            if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
                [self retrievemessagerecipientwithcallingsource:@"Student"];
                individualimagebutton.hidden=NO;
                workingMessage.recipientgroup.droparray=[[NSMutableArray alloc]initWithObjects:@"Non Drop", nil];
                workingMessage.recipientgroup.leadstatusarray=[[NSMutableArray alloc]init];
                //tmpMessageChannel=[[MyClass getlocaldbwithparameter:@"defaultstudentmessagechannel"] integerValue];
                workingMessage.channel=globalvariables.centerrecord.defaultstudentmessagechannel;//[self returnChannelCodeWithIndex:[MyClass getlocaldbwithparameter:@"defaultstudentmessagechannel"]];
            }else if ([workingMessage.recipienttype isEqualToString:@"Lead"]){
                [self retrievemessagerecipientwithcallingsource:@"Lead"];
                workingMessage.recipientgroup.subjectarray=[[NSMutableArray alloc]init];
                workingMessage.recipientgroup.instructorarray=[[NSMutableArray alloc]init];
                workingMessage.recipientgroup.classdatearray=[[NSMutableArray alloc]init];
                workingMessage.recipientgroup.droparray=[[NSMutableArray alloc]init];
                individualimagebutton.hidden=NO;
                workingMessage.recipientgroup.studentstatusarray=[[NSMutableArray alloc]init];
                workingMessage.channel=globalvariables.centerrecord.defaultleadmessagechannel;//[self returnChannelCodeWithIndex:[MyClass getlocaldbwithparameter:@"defaultleadmessagechannel"]];
                //tmpMessageChannel=[[MyClass getlocaldbwithparameter:@"defaultleadmessagechannel"] integerValue];
            }else{
                [self retrievemessagerecipientwithcallingsource:@"Staff"];
                individualimagebutton.hidden=YES;
                workingMessage.recipientgroup.subjectarray=[[NSMutableArray alloc]init];
                workingMessage.recipientgroup.instructorarray=[[NSMutableArray alloc]init];
                workingMessage.recipientgroup.classdatearray=[[NSMutableArray alloc]init];
                workingMessage.recipientgroup.droparray=[[NSMutableArray alloc]init];
                workingMessage.recipientgroup.leadstatusarray=[[NSMutableArray alloc]init];
                workingMessage.recipientgroup.studentstatusarray=[[NSMutableArray alloc]init];
                workingMessage.channel=@"A";
            }
            
            //[self storeTmpField];
            [self updateTableRowArray];
            [MessagePopoverTable reloadData];
            [TargetTable reloadData];
            
            [self adjusttablesize];
        }
    }else if (tableView==IndividualTable){
        if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
            if ([workingMessage.recipientgroup.individualarray containsObject:((Student *)[filteredindividualarray objectAtIndex:indexPath.row]).studentkey]) {
                [workingMessage.recipientgroup.individualarray removeObject:((Student *)[filteredindividualarray objectAtIndex:indexPath.row]).studentkey];
            }else{
                [workingMessage.recipientgroup.individualarray addObject:((Student *)[filteredindividualarray objectAtIndex:indexPath.row]).studentkey];
            }
        }else if ([workingMessage.recipienttype isEqualToString:@"Lead"]){
            if ([workingMessage.recipientgroup.individualarray containsObject:((Lead *)[filteredindividualarray objectAtIndex:indexPath.row]).leadkey]) {
                [workingMessage.recipientgroup.individualarray removeObject:((Lead *)[filteredindividualarray objectAtIndex:indexPath.row]).leadkey];
            }else{
                [workingMessage.recipientgroup.individualarray addObject:((Lead *)[filteredindividualarray objectAtIndex:indexPath.row]).leadkey];
            }
        }else if ([workingMessage.recipienttype isEqualToString:@"Staff"]){
            if ([workingMessage.recipientgroup.individualarray containsObject:((Staff *)[filteredindividualarray objectAtIndex:indexPath.row]).username]) {
                [workingMessage.recipientgroup.individualarray removeObject:((Staff *)[filteredindividualarray objectAtIndex:indexPath.row]).username];
            }else{
                [workingMessage.recipientgroup.individualarray addObject:((Staff *)[filteredindividualarray objectAtIndex:indexPath.row]).username];
            }
        }
        

        
        if (workingMessage.recipientgroup.individualarray.count>0) {
            workingMessage.recipientgroup.subjectarray=[[NSMutableArray alloc]init];
            workingMessage.recipientgroup.instructorarray=[[NSMutableArray alloc]init];
            workingMessage.recipientgroup.classdatearray=[[NSMutableArray alloc]init];
            workingMessage.recipientgroup.gradearray=[[NSMutableArray alloc]init];
            workingMessage.recipientgroup.droparray=[[NSMutableArray alloc]init];
            workingMessage.recipientgroup.studentstatusarray=[[NSMutableArray alloc]init];
            workingMessage.recipientgroup.leadstatusarray=[[NSMutableArray alloc]init];
        }
        
        
        
        //[self storeTmpField];
        [self updateTableRowArray];
        [MessagePopoverTable reloadData];
        [IndividualTable reloadData];
            
        [self adjusttablesize];
    }else if (tableView==SubjectTable){
        if ([workingMessage.recipientgroup.subjectarray containsObject:((SubjectRecord *)[filteredsubjectarray objectAtIndex:indexPath.row]).subject_shortname]) {
            [workingMessage.recipientgroup.subjectarray removeObject:((SubjectRecord *)[filteredsubjectarray objectAtIndex:indexPath.row]).subject_shortname];
        }else{
            [workingMessage.recipientgroup.subjectarray addObject:((SubjectRecord *)[filteredsubjectarray objectAtIndex:indexPath.row]).subject_shortname];
        }

        //[self storeTmpField];
        [self updateTableRowArray];
        [MessagePopoverTable reloadData];
        [SubjectTable reloadData];
        
        [self adjusttablesize];
        
    }else if (tableView==InstructorTable){
        if ([workingMessage.recipientgroup.instructorarray containsObject:((Instructor *)[filteredinstructorarray objectAtIndex:indexPath.row]).username]) {
            [workingMessage.recipientgroup.instructorarray removeObject:((Instructor *)[filteredinstructorarray objectAtIndex:indexPath.row]).username];
        }else{
            [workingMessage.recipientgroup.instructorarray addObject:((Instructor *)[filteredinstructorarray objectAtIndex:indexPath.row]).username];
        }
        
        //[self storeTmpField];
        [self updateTableRowArray];
        [MessagePopoverTable reloadData];
        [InstructorTable reloadData];
        
        [self adjusttablesize];
    }/*else if (tableView==ClassDateTable){
        if ([workingMessage.recipientgroup.classdatearray containsObject:[MyClass returnDateFromBaseDateWithOffset:indexPath.row]]) {
            [workingMessage.recipientgroup.classdatearray removeObject:[MyClass returnDateFromBaseDateWithOffset:indexPath.row]];
        }else{
            [workingMessage.recipientgroup.classdatearray addObject:[MyClass returnDateFromBaseDateWithOffset:indexPath.row]];
        }
        
        //[self storeTmpField];
        [MessagePopoverTable reloadData];
        [ClassDateTable reloadData];
        
        [self adjusttablesize];
    }*/else if (tableView==GradeTable){
        if ([workingMessage.recipientgroup.gradearray containsObject:[gradearray objectAtIndex:indexPath.row]]) {
            [workingMessage.recipientgroup.gradearray removeObject:[gradearray objectAtIndex:indexPath.row]];
        }else{
            [workingMessage.recipientgroup.gradearray addObject:[gradearray objectAtIndex:indexPath.row]];
        }
        
        //[self storeTmpField];
        [self updateTableRowArray];
        [MessagePopoverTable reloadData];
        [GradeTable reloadData];
        
        [self adjusttablesize];
    }else if (tableView==LeadStatusTable){
        if ([workingMessage.recipientgroup.leadstatusarray containsObject:[leadstatusarray objectAtIndex:indexPath.row]]) {
            [workingMessage.recipientgroup.leadstatusarray removeObject:[leadstatusarray objectAtIndex:indexPath.row]];
        }else{
            [workingMessage.recipientgroup.leadstatusarray addObject:[leadstatusarray objectAtIndex:indexPath.row]];
        }
        
        //[self storeTmpField];
        [self updateTableRowArray];
        [MessagePopoverTable reloadData];
        [LeadStatusTable reloadData];
        
        [self adjusttablesize];
    }else if (tableView==StudentStatusTable){
        if ([workingMessage.recipientgroup.studentstatusarray containsObject:[studentstatusarray objectAtIndex:indexPath.row]]) {
            [workingMessage.recipientgroup.studentstatusarray removeObject:[studentstatusarray objectAtIndex:indexPath.row]];
        }else{
            [workingMessage.recipientgroup.studentstatusarray addObject:[studentstatusarray objectAtIndex:indexPath.row]];
        }
        
        //[self storeTmpField];
        [self updateTableRowArray];
        [MessagePopoverTable reloadData];
        [StudentStatusTable reloadData];
        
        [self adjusttablesize];
    }else if (tableView==DropTable){
        [workingMessage.recipientgroup.droparray removeAllObjects];

        [workingMessage.recipientgroup.droparray addObject:[droparray objectAtIndex:indexPath.row]];
        
        
        //[self storeTmpField];
        [self updateTableRowArray];
        [MessagePopoverTable reloadData];
        [DropTable reloadData];
        
        [self adjusttablesize];
    }else if (tableView==StaffGroupTable){
        if ([workingMessage.recipientgroup.staffgrouparray containsObject:((GroupRecord *)[staffgrouparray objectAtIndex:indexPath.row]).groupkey]) {
            [workingMessage.recipientgroup.staffgrouparray removeObject:((GroupRecord *)[staffgrouparray objectAtIndex:indexPath.row]).groupkey];
        }else{
            [workingMessage.recipientgroup.staffgrouparray addObject:((GroupRecord *)[staffgrouparray objectAtIndex:indexPath.row]).groupkey];
        }
        
        //[self storeTmpField];
        [self updateTableRowArray];
        [MessagePopoverTable reloadData];
        [StaffGroupTable reloadData];
        
        [self adjusttablesize];
    }else if (tableView==ReadStatusTable){
        if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
            readstatuscontactarray=((ReadStatusRecord *)[filteredreadstatusarray objectAtIndex:indexPath.row]).contactgroup;
            
            [self showsidewindowwithwindow:@"ReadStatusContact"];
            //[ReadStatusContactTable reloadData];
            [self adjusttablesize];
        }

    }else if (tableView==centertable){
        
        NSString *selecteditem=((CenterRecord *)[filteredCenterArray objectAtIndex:indexPath.row]).centerkey;
        if (selectedCenters && selectedCenters.count==0) {
            for (int i=0; i<allcenterarray.count; i++) {
                if (![selecteditem isEqualToString:((CenterRecord *)[allcenterarray objectAtIndex:i]).centerkey]) {
                    [selectedCenters addObject:((CenterRecord *)[allcenterarray objectAtIndex:i]).centerkey];
                }
            }
        }else{
            if(!selectedCenters){
                selectedCenters=[[NSMutableArray alloc]init];
            }
            if ([selectedCenters containsObject:selecteditem]) {
                [selectedCenters removeObject:selecteditem];
                if(selectedCenters.count==0){
                    selectedCenters=nil;
                }
            }else{
                [selectedCenters addObject:selecteditem];
                if(selectedCenters.count==allcenterarray.count){
                    selectedCenters=[[NSMutableArray alloc]init];
                }
            }
        }
        
        [centertable reloadData];
        [MessagePopoverTable reloadData];
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    if([selectedItem isEqualToString:@"MessageStartTime"]){
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if([selectedItem isEqualToString:@"MessageStartTime"]){
        if (component==0){
            return [hourPickerViewMenu count];
        }else{
            return [minutePickerViewMenu count];
        }
    }
    return 0;
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
    
    
    if([selectedItem isEqualToString:@"MessageStartTime"]){
        if (component==0){
            tView.text= [hourPickerViewMenu objectAtIndex:row];
        }else{
            tView.text= [minutePickerViewMenu objectAtIndex:row];
        }
    }
    return tView;
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if([selectedItem isEqualToString:@"MessageStartTime"]){
        if (component==0){
            return 40;
        }else{
            return 40;
        }
    }/*else{
        return 250;
    }*/
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([selectedItem isEqualToString:@"MessageStartTime"]){
        if (![workingMessage.messagestarttime isEqualToString:[NSString stringWithFormat:@"%@ %@:%@:00",[workingMessage.messagestarttime substringToIndex:10],[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]]]) {
            workingMessage.messagestarttime=[NSString stringWithFormat:@"%@ %@:%@:00",[workingMessage.messagestarttime substringToIndex:10],[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
            //MessageStartTimeLabel.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:workingMessage.messagestarttime];
            
            
            //[self storeTmpField];
            [MessagePopoverTable reloadData];
            
            [self adjusttablesize];
            
        }
    }
}


-(void) deletemessage
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
        [dictionary setValue:@"updateoutboxmessage2" forKey:@"postaction"];
        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
        //[dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dictionary setValue:@"Delete" forKey:@"action"];
        [dictionary setValue:@"Yes" forKey:@"removeinboxmessage"];
        
        [dictionary setValue:OMessageRecordObject.outboxmessagekey forKey:@"outboxmessagekey"];
        
        __block BOOL result=FALSE;
        [MyClass callMultipartPOSTwithDict:dictionary photoArray:workingMessage.photoarray completionBlock:^(id responseObject, NSError *error) {
            if (!error) {
                result=TRUE;
            }
        }];
        
        if (result) {
            [self.delegate dismissMessagePopoverVC];
        }
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        
    });
        
}


-(IBAction) deleteButtonPressed:(id)sender
{
    UIAlertController *deletemessagealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Message Record"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the message record?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self deletemessage];
        
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [deletemessagealert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [deletemessagealert addAction:OKAction];
    [deletemessagealert addAction:CancelAction];
    
    //[self presentViewController:deletemessagealert animated:YES completion:nil];
    [MyClass presentViewController:deletemessagealert View:self];
}

-(IBAction) editButtonPressed:(id)sender{
    
    MessageTableMode=@"Edit";
    if (![self InitializeField]) {
        MessageTableMode=@"View";
        return;
    }
    
    [MessagePopoverTable reloadData];
    
    [self adjusttablesize];
    
    
}

-(IBAction) copyButtonPressed:(id)sender{
    
    //if ([self loadstudentsubjectarray]) {
        //[self.delegate copyMessage];
    //}
    
    
    MessageTableMode=@"Copy";
    CallingSource=@"MessageView";
    [self InitializeField];
    [MessagePopoverTable reloadData];
    
    [self adjusttablesize];
    
}

-(IBAction) doneButtonPressed:(id)sender
{
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }
    //[self storeTmpField];
    
    keyboardheight=0;
    [self adjusttablesize];
    
    [df setDateFormat:@"dd-MMM-yyyy HH:mm"];

    if ([workingMessage.messagechinese isEqualToString:@""] && [workingMessage.messageenglish isEqualToString:@""] && workingMessage.photoarray.count==0){
        
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Message Record"] message:[MyClass returntitlewithtitle:@"Please either input text or attach file"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if (selectedCenters.count>1 && ![self isAllUploadFilesNotExceedSize]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Image"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(minMaxUploadFileSize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else{
        UIAlertController *resetalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Message Record"] message:[MyClass returntitlewithtitle:[NSString stringWithFormat:@"Are you sure to send the message via %@?",[self returnChannelNameWithChannelCode:workingMessage.channel]]] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //[self.delegate startloadingindicator];
            //[self showsidewindowwithwindow:@"none"];
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self updatemessagewithdraft2:NO];
            });
        }];
        

        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [resetalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [resetalert addAction:OKAction];
        [resetalert addAction:CancelAction];
        
        //[self presentViewController:resetalert animated:YES completion:nil];
        [MyClass presentViewController:resetalert View:self];
        
    }
}

-(IBAction) draftButtonPressed:(id)sender
{
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }
    //[self storeTmpField];
    
    keyboardheight=0;
    [self adjusttablesize];
    
    [df setDateFormat:@"dd-MMM-yyyy HH:mm"];

    if ([workingMessage.messagechinese isEqualToString:@""] && [workingMessage.messageenglish isEqualToString:@""] && workingMessage.photoarray.count==0){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Message Record"] message:[MyClass returntitlewithtitle:@"Please either input text or attach file"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else{
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updatemessagewithdraft2:YES];
            
        });
        

    }
}

-(void) getmessagerecipientlist
{
    
    NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *recipientgrouparray=[[NSArray alloc]init];

    keys=[NSArray arrayWithObjects:@"group",@"recipient",nil];
    
    for (int i=0; i<workingMessage.recipientgroup.individualarray.count; i++) {
        if([workingMessage.recipienttype isEqualToString:@"Student"]){
            values=[NSArray arrayWithObjects:@"student",[workingMessage.recipientgroup.individualarray objectAtIndex:i], nil];
        }else if([workingMessage.recipienttype isEqualToString:@"Lead"]) {
            values=[NSArray arrayWithObjects:@"lead",[workingMessage.recipientgroup.individualarray objectAtIndex:i], nil];
        }else{
            values=[NSArray arrayWithObjects:@"staff",[workingMessage.recipientgroup.individualarray objectAtIndex:i], nil];
        }
        
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.subjectarray.count; i++) {
        values=[NSArray arrayWithObjects:@"subject",[workingMessage.recipientgroup.subjectarray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.instructorarray.count; i++) {
        values=[NSArray arrayWithObjects:@"instructor",[workingMessage.recipientgroup.instructorarray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.classdatearray.count; i++) {
        values=[NSArray arrayWithObjects:@"classdate",[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:[workingMessage.recipientgroup.classdatearray objectAtIndex:i]], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.gradearray.count; i++) {
        values=[NSArray arrayWithObjects:@"grade",[workingMessage.recipientgroup.gradearray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.studentstatusarray.count; i++) {
        values=[NSArray arrayWithObjects:@"studentstatus",[workingMessage.recipientgroup.studentstatusarray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.droparray.count; i++) {
        values=[NSArray arrayWithObjects:@"drop",[workingMessage.recipientgroup.droparray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    
    for (int i=0; i<workingMessage.recipientgroup.leadstatusarray.count; i++) {
        values=[NSArray arrayWithObjects:@"leadstatus",[workingMessage.recipientgroup.leadstatusarray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.staffgrouparray.count; i++) {
        values=[NSArray arrayWithObjects:@"staffgroup",[workingMessage.recipientgroup.staffgrouparray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    recipientgrouparray = [NSArray arrayWithArray:arrayOfDicts];
    
    [dictionary setValue:@"getmessagerecipientlist" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
//    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:[selectedCenters componentsJoinedByString:@","] forKey:@"centerkey"];
    [dictionary setValue:workingMessage.recipienttype forKey:@"recipienttype"];
    [dictionary setValue:workingMessage.messagetype forKey:@"messagetype"];
    [dictionary setValue:workingMessage.channel forKey:@"channel"];
    [dictionary setValue:recipientgrouparray forKey:@"recipientgroup"];

    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            recipientlistarray=[[NSMutableArray alloc]init];
            for (int i=0; i<JSONArray.count; i++) {
                NSString * typekey=[[JSONArray objectAtIndex:i] objectForKey:@"typekey"];
                NSString * recipientname=[[JSONArray objectAtIndex:i] objectForKey:@"recipientname"];
                NSString * recipientid=[[JSONArray objectAtIndex:i] objectForKey:@"recipientid"];
                NSString * avatar=[[JSONArray objectAtIndex:i] objectForKey:@"avatar"];
                NSString * centerkey=[[JSONArray objectAtIndex:i] objectForKey:@"centerkey"];
                if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
                    Student *object=[MyClass returnstudentwithstudentkey:typekey];
                    if([object.centerkey isEqualToString:@""]){
                        object=[[Student alloc]init];
                        object.studentkey=typekey;
                        object.centerkey=centerkey;
                        object.displayfullname=recipientname;
                        object.studentid=recipientid;
                        object.avatar=avatar;
                        object.firstname=recipientname;
                        object.lastname=@"";
                    }
                    [recipientlistarray addObject:object];
                }else if ([workingMessage.recipienttype isEqualToString:@"Lead"]) {
                    Lead *object=[MyClass returnleadwithleadkey:typekey];
                    if([object.centerkey isEqualToString:@""]){
                        object=[[Lead alloc]init];
                        object.leadkey=typekey;
                        object.centerkey=centerkey;
                        object.leadid=recipientid;
                        object.avatar=avatar;
                        object.firstname=recipientname;
                        object.lastname=@"";
                    }
                    [recipientlistarray addObject:object];
                }else{
                    Staff *object=[MyClass returnstaffrecordwithusername:typekey];
                    if(!object){
                        object=[[Staff alloc]init];
                        object.centerkey=centerkey;
                        object.username=recipientid;
                        object.avatar=avatar;
                        object.firstname=recipientname;
                        object.lastname=@"";
                    }
                    [recipientlistarray addObject:object];
                }
                
            }
            
            if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
                recipientlistarray = [NSMutableArray arrayWithArray:[recipientlistarray sortedArrayUsingDescriptors:[MyClass returnstudentnamesortdescriptorarray]]];
            }else if ([workingMessage.recipienttype isEqualToString:@"Lead"]) {
                recipientlistarray = [NSMutableArray arrayWithArray:[recipientlistarray sortedArrayUsingDescriptors:[MyClass returnleadnamesortdescriptorarray]]];
            }else{
                NSSortDescriptor *sortbyfirstname = [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES selector:@selector(localizedStandardCompare:)];
                NSSortDescriptor *sortbylastname = [NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES selector:@selector(localizedStandardCompare:)];
                NSArray *sortDescriptors = @[sortbyfirstname,sortbylastname];
                recipientlistarray = [NSMutableArray arrayWithArray:[recipientlistarray sortedArrayUsingDescriptors:sortDescriptors]];
            }
            filteredrecipientlistarray=[[NSMutableArray alloc]initWithArray:recipientlistarray];
        }
    }];
    
    
    if (result) {
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        //[MyClass showconnectionlostdialogbox];
    }
    
    
}


-(void) updatemessagewithdraft2:(BOOL)draft
{
    
    
    NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *recipientgrouparray=[[NSArray alloc]init];
    
    NSString *action;

    
    keys=[NSArray arrayWithObjects:@"group",@"recipient",nil];
    
    for (int i=0; i<workingMessage.recipientgroup.individualarray.count; i++) {
        if([workingMessage.recipienttype isEqualToString:@"Student"]){
            values=[NSArray arrayWithObjects:@"student",[workingMessage.recipientgroup.individualarray objectAtIndex:i], nil];
        }else if([workingMessage.recipienttype isEqualToString:@"Lead"]) {
            values=[NSArray arrayWithObjects:@"lead",[workingMessage.recipientgroup.individualarray objectAtIndex:i], nil];
        }else{
            values=[NSArray arrayWithObjects:@"staff",[workingMessage.recipientgroup.individualarray objectAtIndex:i], nil];
        }
        
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.subjectarray.count; i++) {
        values=[NSArray arrayWithObjects:@"subject",[workingMessage.recipientgroup.subjectarray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.instructorarray.count; i++) {
        values=[NSArray arrayWithObjects:@"instructor",[workingMessage.recipientgroup.instructorarray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.classdatearray.count; i++) {
        values=[NSArray arrayWithObjects:@"classdate",[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:[workingMessage.recipientgroup.classdatearray objectAtIndex:i]], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.gradearray.count; i++) {
        values=[NSArray arrayWithObjects:@"grade",[workingMessage.recipientgroup.gradearray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.studentstatusarray.count; i++) {
        values=[NSArray arrayWithObjects:@"studentstatus",[workingMessage.recipientgroup.studentstatusarray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.droparray.count; i++) {
        values=[NSArray arrayWithObjects:@"drop",[workingMessage.recipientgroup.droparray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    
    for (int i=0; i<workingMessage.recipientgroup.leadstatusarray.count; i++) {
        values=[NSArray arrayWithObjects:@"leadstatus",[workingMessage.recipientgroup.leadstatusarray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    for (int i=0; i<workingMessage.recipientgroup.staffgrouparray.count; i++) {
        values=[NSArray arrayWithObjects:@"staffgroup",[workingMessage.recipientgroup.staffgrouparray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    recipientgrouparray = [NSArray arrayWithArray:arrayOfDicts];
    
    [dictionary setValue:@"updateoutboxmessage2" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    //[dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:workingMessage.composer?workingMessage.composer:globalvariables.username forKey:@"composer"];
    [dictionary setValue:workingMessage.sender?workingMessage.sender:@"center" forKey:@"sender"];
    [dictionary setValue:workingMessage.recipienttype forKey:@"recipienttype"];
    [dictionary setValue:workingMessage.messagetype forKey:@"messagetype"];
    [dictionary setValue:workingMessage.messageenglish forKey:@"messageenglish"];
    [dictionary setValue:workingMessage.messagechinese forKey:@"messagechinese"];
    if ([[MyClass convertToNSDateWithDate:workingMessage.messagestarttime DateFormat:@"yyyy-MM-dd HH:mm:ss"] compare:[NSDate date]]==NSOrderedAscending) {
        workingMessage.messagestarttime=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    [dictionary setValue:workingMessage.messagestarttime forKey:@"messagestarttime"];
    [dictionary setValue:@"" forKey:@"notificationqueuedflag"];
    [dictionary setValue:@"N" forKey:@"automessageflag"];
    [dictionary setValue:workingMessage.channel forKey:@"channel"];
    [dictionary setValue:draft?@"D":@"" forKey:@"status"];
    [dictionary setValue:recipientgrouparray.count>0?recipientgrouparray:@"" forKey:@"recipientgroup"];
    [dictionary setValue:photoimagechanged?@"Yes":@"No" forKey:@"imagechanged"];
    [dictionary setValue:workingMessage.hotnews?@"Yes":@"No" forKey:@"hotnews"];
    [dictionary setValue:workingMessage.hn_expiry_date forKey:@"hn_expiry_date"];
    [dictionary setValue:automessage?@"N":@"Y" forKey:@"broadcastmessageflag"];
    [dictionary setValue:globalvariables.deviceToken forKey:@"devicetoken"];
    if (outboxDocumentKeyCenterkey && outboxDocumentKeyCenterkey.count>0) {
        [dictionary setValue:outboxDocumentKeyCenterkey[@"centerkey"] forKey:@"centerkey"];
        [dictionary setValue:outboxDocumentKeyCenterkey[@"outboxdocumentkey"] forKey:@"outboxdocumentkey"];
    }else{
//        [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dictionary setValue:[selectedCenters componentsJoinedByString:@","] forKey:@"centerkey"];
    }
    
    if ([MessageTableMode isEqualToString:@"Add"] || [MessageTableMode isEqualToString:@"Copy"]|| [MessageTableMode isEqualToString:@"RemoteAdd"]) {
        action=@"Add";
        if (([MessageTableMode isEqualToString:@"Add"] && OMessageRecordObject && ![CallingSource isEqualToString:@"NotificationView"]) || automessage) {
            [dictionary setValue:@"Y" forKey:@"automessageflag"];
            automessage=NO;
        }
    }else{
        action=@"Edit";
        [dictionary setValue:OMessageRecordObject.outboxmessagekey forKey:@"outboxmessagekey"];
    }
    [dictionary setValue:action forKey:@"action"];
    
    __block BOOL result=FALSE;
    __block NSData *returndata;
    
    [MyClass callMultipartPOSTwithDict:dictionary photoArray:photoimagechanged?workingMessage.photoarray:nil completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            result=TRUE;
            returndata=responseObject;
        }
    }];
    outboxDocumentKeyCenterkey=[[NSMutableDictionary alloc]init];
    if (result) {
        //NSString *resString = [[NSString alloc] initWithData:returndata encoding:NSUTF8StringEncoding];
        //NSLog(@"%@",resString);
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:returndata options:kNilOptions error:nil];
        NSString * status=json[@"status"];
        if ([status isEqualToString:@"success"]) {
            //[MyClass loadingindicatorwithoption:@"stop" color:nil];
            [MyClass clearTmpDirectoryContent];
            [self.delegate dismissMessagePopoverVC];
        }else{
            NSDictionary *jsoncontent=json[@"content"];
            NSString *reason=jsoncontent[@"reason"];
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Message"] message:[MyClass returntitlewithtitle:reason] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
        }
        

    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        //[MyClass showconnectionlostdialogbox];
        NSLog(@"failed parent receipt");
    }
    
    
}



-(void) selectstarttimetype:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex==0) {
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        workingMessage.messagestarttime=[df stringFromDate:[NSDate date]];
    }else if (sender.selectedSegmentIndex==1){
        [df setDateFormat:@"yyyy-MM-dd"];
        workingMessage.messagestarttime=[NSString stringWithFormat:@"%@ 00:00:00", [df stringFromDate:[[NSDate date] dateByAddingTimeInterval:60*60*24]]];
        

        
    }

    
    [StartTimeTable reloadData];
    [MessagePopoverTable reloadData];
}

-(BOOL) isAllUploadFilesNotExceedSize
{
    BOOL result=YES;
    NSData *videoData;
    NSInteger maxUploadFileSize;
    minMaxUploadFileSize=0;
    for (int p=0; p<workingMessage.photoarray.count; p++) {
        MessagePhotoRecord *obj=[workingMessage.photoarray objectAtIndex:p];
        for (int c=0; c<selectedCenters.count; c++) {
            maxUploadFileSize=[MyClass getMaxUploadFileSizeWithCenterkey:selectedCenters[c]];
            if (maxUploadFileSize<minMaxUploadFileSize) {
                minMaxUploadFileSize=maxUploadFileSize;
            }
            
            if (result) {
                videoData = [[NSData alloc]initWithContentsOfURL:obj.internalurl];
                if (videoData.length>maxUploadFileSize) {
                    result=NO;
                }
            }
        }
    }
    return result;
}

- (IBAction)saveButtonPressed:(id)sender
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
        
        [dictionary setValue:@"updateoutboxmessage2" forKey:@"postaction"];
        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
        [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dictionary setValue:workingMessage.hotnews?@"Yes":@"No" forKey:@"hotnews"];
        [dictionary setValue:workingMessage.hn_expiry_date forKey:@"hn_expiry_date"];
        [dictionary setValue:OMessageRecordObject.outboxmessagekey forKey:@"outboxmessagekey"];
        [dictionary setValue:@"Edit" forKey:@"action"];
        
        __block BOOL result=FALSE;
        __block NSData *returndata;
        
        [MyClass callMultipartPOSTwithDict:dictionary photoArray:workingMessage.photoarray completionBlock:^(id responseObject, NSError *error) {
            if (!error) {
                result=TRUE;
                returndata=responseObject;
            }
        }];
        
        if (result) {
            //NSString *resString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            //NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            [self.delegate dismissMessagePopoverVC];
        }else{
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            [MyClass showconnectionlostdialogbox];
        }

    });
    
}


-(void) selectmessagechannel:(UISegmentedControl *)sender
{
    if ([workingMessage.recipienttype isEqualToString:@"Staff"]) {
        if (sender.selectedSegmentIndex ==0){
            workingMessage.channel=@"A";
        }else if (sender.selectedSegmentIndex ==1){
            workingMessage.channel=@"S";
        }else{
            workingMessage.channel=@"E";
        }
    }else if ([workingMessage.recipienttype isEqualToString:@"Student"]){
        if (sender.selectedSegmentIndex==0) {
            workingMessage.channel=@"AS";
        }else if (sender.selectedSegmentIndex ==1){
            workingMessage.channel=@"A";
        }else if (sender.selectedSegmentIndex ==2){
            workingMessage.channel=@"S";
        }else{
            workingMessage.channel=@"E";
        }
    }else{
        if (sender.selectedSegmentIndex==0) {
            workingMessage.channel=@"S";
        }else{
            workingMessage.channel=@"E";
        }
    }
}



-(BOOL) retrievemessagerecipientwithcallingsource:(NSString *)callingsource
{
    
    //create string contains url address for php file
    
    //NSString *strURL;
    
    if ([callingsource isEqualToString:@"Student"]) {
        allindividualarray=[[NSMutableArray alloc]initWithArray:allstudentarray];
        filteredindividualarray=[[NSMutableArray alloc]initWithArray:allstudentarray];
        
    }else if ([callingsource isEqualToString:@"Lead"]){
        allindividualarray=[[NSMutableArray alloc]initWithArray:allleadarray];
        filteredindividualarray=[[NSMutableArray alloc]initWithArray:allleadarray];
    }else{
        allindividualarray=[[NSMutableArray alloc]initWithArray:allstaffarray];
        filteredindividualarray=[[NSMutableArray alloc]initWithArray:allstaffarray];
    }
    
    return TRUE;
    

}



-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint point = [textView.superview convertPoint:CGPointZero toView:MessagePopoverTable];
    NSIndexPath *indexpath =[MessagePopoverTable indexPathForRowAtPoint:point];
    CGRect rectInTableView = [MessagePopoverTable rectForRowAtIndexPath:indexpath];
    CGFloat offset=rectInTableView.origin.y+rectInTableView.size.height-MessagePopoverTable.frame.size.height+(keyboardshow?0:keyboardheight);
    
    
    if(offset>0){
        [MessagePopoverTable setContentOffset:CGPointMake(0, offset) animated:YES];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    CGPoint rootViewPoint = [textView.superview convertPoint:CGPointZero toView:MessagePopoverTable];
    NSIndexPath *indexPath = [MessagePopoverTable indexPathForRowAtPoint:rootViewPoint];
    
    MyTableViewCell *newcell=[MessagePopoverTable cellForRowAtIndexPath:indexPath];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    if (size.height>400) {
        newcell.layoutconstraint1.constant=400;
        textView.scrollEnabled=YES;
    }else{
        newcell.layoutconstraint1.constant=size.height;
        textView.scrollEnabled=NO;
    }
    
    if (textView.tag==0) {
        workingMessage.messageenglish=textView.text;
    }else if (textView.tag==1){
        workingMessage.messagechinese=textView.text;
    }
    [MessagePopoverTable beginUpdates];
    [MessagePopoverTable endUpdates];
}

- (void)ImageButtonPressed:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *CallingFor;
    
    
    if ([CallingSource isEqualToString:@"StudentView"]) {
        CallingFor=@"Student";
    }else if ([CallingSource isEqualToString:@"LeadView"]){
        CallingFor=@"Lead";
    }else{
        if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
            CallingFor=@"Student";
        }else{
            CallingFor=@"Lead";
        }
    }
    
    if ([CallingFor isEqualToString:@"Student"]) {
        
        
        
        
        studentimagepopover = (StudentImageGridViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"StudentImageGridViewController"];
        studentimagepopover.delegate=self;
        studentimagepopover.studentArray=allindividualarray;
        studentimagepopover.studentcategory=@"All Students";
        studentimagepopover.source=@"message";
        studentimagepopover.mode=@"multiple";
        /*if ([MessageTableMode isEqualToString:@"Add"] && resettmpcallingkey) {
            studentimagepopover.tmpcallingkey=[[NSMutableArray alloc]init];
        }else{*/
            studentimagepopover.tmpcallingkey=[[NSMutableArray alloc]initWithArray:workingMessage.recipientgroup.individualarray];
        //}
        
        studentimagepopover.modalPresentationStyle = UIModalPresentationFormSheet;
        //[self presentViewController:studentimagepopover animated:YES completion:nil];
        [MyClass presentViewController:studentimagepopover View:self];
    }else{
        
        
        leadimagepopover = (LeadImageGridViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"LeadImageGridViewController"];
        leadimagepopover.delegate=self;
        leadimagepopover.leadArray=allindividualarray;
        leadimagepopover.leadcategory=@"All Leads";
        leadimagepopover.source=@"message";
        leadimagepopover.mode=@"multiple";
        /*if ([MessageTableMode isEqualToString:@"Add"] && resettmpcallingkey) {
            leadimagepopover.tmpcallingkey=[[NSMutableArray alloc]init];
        }else{*/
            leadimagepopover.tmpcallingkey=[[NSMutableArray alloc]initWithArray:workingMessage.recipientgroup.individualarray];
        //}
        
        leadimagepopover.modalPresentationStyle = UIModalPresentationFormSheet;
        //[self presentViewController:leadimagepopover animated:YES completion:nil];
        [MyClass presentViewController:leadimagepopover View:self];
    }
}


-(void)dismissstudentgridview
{
    [studentimagepopover dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)dismissleadgridview
{
    [leadimagepopover dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) dismissimagepopover
{
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) passstudentarrayfromgrid:(NSMutableArray *)studentarray
{
    [studentimagepopover dismissViewControllerAnimated:YES completion:nil];
    
    workingMessage.recipientgroup.individualarray=[[NSMutableArray alloc]initWithArray:studentarray];

    
    [MessagePopoverTable reloadData];
    [IndividualTable reloadData];
    [self adjusttablesize];
    
    //resettmpcallingkey=FALSE;
}

-(void) passstudentinformation:(NSString *)studentkey
{
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    
    workingMessage.recipientgroup.individualarray=[[NSMutableArray alloc]initWithObjects:studentkey, nil];
    [MessagePopoverTable reloadData];
    [IndividualTable reloadData];
    [self adjusttablesize];
    
}

-(void) passstudentfromgrid:(NSString *)studentkey
{
    //not used
}

-(void) passleadfromgrid:(NSString *)leadkey
{
    //not used
}

-(void) passleadarrayfromgrid:(NSMutableArray *)leadarray
{
    [leadimagepopover dismissViewControllerAnimated:YES completion:nil];
    
    workingMessage.recipientgroup.individualarray=[[NSMutableArray alloc]initWithArray:leadarray];

    
    [MessagePopoverTable reloadData];
    [IndividualTable reloadData];
    [self adjusttablesize];
    
    //resettmpcallingkey=FALSE;
    
}

-(void) passleadinformation:(NSString *)leadkey
{
    
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    
    workingMessage.recipientgroup.individualarray=[[NSMutableArray alloc]initWithObjects:leadkey, nil];

    
    //showReceipientPicker=NO;
    //[self storeTmpField];
    [MessagePopoverTable reloadData];
    [IndividualTable reloadData];
    [self adjusttablesize];
    
    
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    if ([windowname isEqualToString:@"MessageType"]) {
        showMessageTypeTable=YES;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [MessageTypeTable reloadData];
    }else if ([windowname isEqualToString:@"Target"]) {
        showMessageTypeTable=NO;
        showTargetTable=YES;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [TargetTable reloadData];
    }else if ([windowname isEqualToString:@"Individual"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=YES;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [IndividualTable reloadData];
    }else if ([windowname isEqualToString:@"RecipientList"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=YES;
        showCenterTable=NO;
        [RecipientListTable reloadData];
    }else if ([windowname isEqualToString:@"Subject"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=YES;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [SubjectTable reloadData];
    }else if ([windowname isEqualToString:@"Instructor"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=YES;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [InstructorTable reloadData];
    }else if ([windowname isEqualToString:@"ClassDate"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=YES;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
//        [self createClassDateTableToolBar];
        [ClassDateTable reloadData];
    }else if ([windowname isEqualToString:@"ExpiryDate"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=YES;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [ClassDateTable reloadData];
    }else if ([windowname isEqualToString:@"Grade"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=YES;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showReadStatusContactTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [GradeTable reloadData];
    }else if ([windowname isEqualToString:@"LeadStatus"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=YES;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showReadStatusContactTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [LeadStatusTable reloadData];
    }else if ([windowname isEqualToString:@"StudentStatus"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=YES;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showReadStatusContactTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [StudentStatusTable reloadData];
    }else if ([windowname isEqualToString:@"Drop"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=YES;
        showReadStatusTable=NO;
        showReadStatusContactTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [DropTable reloadData];
    }else if ([windowname isEqualToString:@"StaffGroup"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=YES;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showReadStatusContactTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [StaffGroupTable reloadData];
    }else if ([windowname isEqualToString:@"StartTime"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=YES;
        showDropTable=NO;
        showReadStatusTable=NO;
        showReadStatusContactTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [StartTimeTable reloadData];
    }else if ([windowname isEqualToString:@"ReadStatus"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=YES;
        showReadStatusContactTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [ReadStatusTable reloadData];
    }else if ([windowname isEqualToString:@"ReadStatusContact"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=YES;
        showReadStatusContactTable=YES;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [ReadStatusContactTable reloadData];
    }else if ([windowname isEqualToString:@"MessagePhoto"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showReadStatusContactTable=NO;
        showMessagePhoto=YES;
        showRecipientListTable=NO;
        showCenterTable=NO;
        [self createMessagePhotoToolBar];
    }else if ([windowname isEqualToString:@"Center"]) {
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showReadStatusContactTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=YES;
        [centertable reloadData];
    }else{
        showMessageTypeTable=NO;
        showTargetTable=NO;
        showIndividualTable=NO;
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showLeadStatusTable=NO;
        showStudentStatusTable=NO;
        showStaffGroupTable=NO;
        showStartTimeTable=NO;
        showDropTable=NO;
        showReadStatusTable=NO;
        showReadStatusContactTable=NO;
        showReadStatusContactTable=NO;
        showMessagePhoto=NO;
        showRecipientListTable=NO;
        showCenterTable=NO;
    }
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==subjectsearchbar) {
        if ([searchText isEqualToString:@""]) {
            filteredsubjectarray=[[NSMutableArray alloc]initWithArray:allsubjectarray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.subject_shortname contains[c] %@ or self.subject_englishname contains[c] %@ or self.subject_chinesename contains[c] %@",searchText,searchText,searchText];
            filteredsubjectarray=[[NSMutableArray alloc]initWithArray:[allsubjectarray filteredArrayUsingPredicate:predicate]];
        }
        [SubjectTable reloadData];
        [SubjectTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==instructorsearchbar){
        if ([searchText isEqualToString:@""]) {
            filteredinstructorarray=[[NSMutableArray alloc]initWithArray:allinstructorarray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or self.username contains[c] %@",searchText,searchText,searchText];
            filteredinstructorarray=[[NSMutableArray alloc]initWithArray:[allinstructorarray filteredArrayUsingPredicate:predicate]];
        }
        [InstructorTable reloadData];
        [InstructorTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==individualsearchbar){
        if ([searchText isEqualToString:@""]) {
            filteredindividualarray=[[NSMutableArray alloc]initWithArray:allindividualarray];
        }else{
            NSPredicate *predicate;
            if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
                predicate = [NSPredicate predicateWithFormat:@"self.firstname contains[c] %@ or self.lastname contains[c] %@ or self.othername contains[c] %@ or self.studentid contains[c] %@",searchText,searchText,searchText,searchText];
            }else if ([workingMessage.recipienttype isEqualToString:@"Lead"]){
                predicate = [NSPredicate predicateWithFormat:@"self.firstname contains[c] %@ or self.lastname contains[c] %@ or self.othername contains[c] %@ or self.leadid contains[c] %@",searchText,searchText,searchText,searchText];
            }else{
                predicate = [NSPredicate predicateWithFormat:@"self.firstname contains[c] %@ or self.lastname contains[c] %@ or self.username contains[c] %@",searchText,searchText,searchText];
            }
            filteredindividualarray=[[NSMutableArray alloc]initWithArray:[allindividualarray filteredArrayUsingPredicate:predicate]];
            
        }
        [IndividualTable reloadData];
        [IndividualTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==RecipientListsearchbar){
        if ([searchText isEqualToString:@""]) {
            filteredrecipientlistarray=[[NSMutableArray alloc]initWithArray:recipientlistarray];
        }else{
            NSPredicate *predicate;
            if ([workingMessage.recipienttype isEqualToString:@"Student"]) {
                predicate = [NSPredicate predicateWithFormat:@"self.firstname contains[c] %@ or self.lastname contains[c] %@ or self.othername contains[c] %@ or self.studentid contains[c] %@",searchText,searchText,searchText,searchText];
            }else if ([workingMessage.recipienttype isEqualToString:@"Lead"]){
                predicate = [NSPredicate predicateWithFormat:@"self.firstname contains[c] %@ or self.lastname contains[c] %@ or self.othername contains[c] %@ or self.leadid contains[c] %@",searchText,searchText,searchText,searchText];
            }else{
                predicate = [NSPredicate predicateWithFormat:@"self.firstname contains[c] %@ or self.lastname contains[c] %@ or self.username contains[c] %@",searchText,searchText,searchText];
            }
            filteredrecipientlistarray=[[NSMutableArray alloc]initWithArray:[recipientlistarray filteredArrayUsingPredicate:predicate]];
            
        }
        [RecipientListTable reloadData];
        [RecipientListTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==readstatussearchbar){
        if ([searchText isEqualToString:@""]) {
            filteredreadstatusarray=[[NSMutableArray alloc]initWithArray:allreadstatusarray];
        }else{
            NSPredicate *predicate;

            predicate = [NSPredicate predicateWithFormat:@"self.recipientname contains[c] %@ or self.recipientid contains[c] %@ or self.recipientkey contains[c] %@",searchText,searchText,searchText];
            filteredreadstatusarray=[[NSMutableArray alloc]initWithArray:[allreadstatusarray filteredArrayUsingPredicate:predicate]];
            
        }
        [ReadStatusTable reloadData];
        [ReadStatusTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==centersearchbar){
        if ([searchText isEqualToString:@""]) {
            filteredCenterArray=[[NSMutableArray alloc]initWithArray:allcenterarray];
        }else{
            NSPredicate *predicate;

            predicate = [NSPredicate predicateWithFormat:@"SELF.centername contains[c] %@ or SELF.centershortname_english contains[c] %@ or self.centershortname_chinese contains[c] %@ or self.centercontact contains[c] %@ or self.centeraddress contains[c] %@ or self.centeraddress_chinese contains[c]  %@ or self.centerkey contains[c]  %@",searchText,searchText,searchText,searchText,searchText,searchText,searchText];
            filteredCenterArray=[[NSMutableArray alloc]initWithArray:[allcenterarray filteredArrayUsingPredicate:predicate]];
            
        }
        [centertable reloadData];
        [centertable setContentOffset:CGPointZero animated:YES];
    }
}

-(void) retrieveReadStatusWithOutboxMessageKey:(NSString *)outboxmessagekey
{
    
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&action=retrievereadmessagestatus2&outboxmessagekey=%@&recipienttype=%@&centerkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,outboxmessagekey,OMessageRecordObject.recipienttype,globalvariables.centerrecord.centerkey];
    
     __block BOOL result=FALSE;
     [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
         if (succeeded) {
             result=TRUE;
             NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
             JSONArray = jsonreturned[@"content"];
             
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
                     
                     
                     [allreadstatusarray addObject:[[ReadStatusRecord alloc]initReadStatusRecordwithRecipientName:crecipientname RecipientID:crecipientid Channel:nil ReadTime:nil Image:cimage Gender:cgender Centerkey:ccenterkey Recipientkey:crecipientkey Contactgroup:[[NSMutableArray alloc]init] Relationship:nil iso_code:nil]];
                     
                     
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
                     
                     
                     [allreadstatusarray addObject:[[ReadStatusRecord alloc]initReadStatusRecordwithRecipientName:crecipientname RecipientID:crecipientid Channel:nil ReadTime:nil Image:cimage Gender:cgender Centerkey:ccenterkey Recipientkey:crecipientkey Contactgroup:[[NSMutableArray alloc]init] Relationship:nil iso_code:nil]];
                     
                 }else{
                     crecipientkey=[[JSONArray objectAtIndex:i] objectForKey:@"recipient"];
                     crecipientname=[MyClass returnstaffnamewithusername:crecipientkey firstorfullname:@"full"];
                     crecipientid=nil;
                     cgender=nil;
                     cimage=nil;
                     ccenterkey=nil;
                     
                     [allreadstatusarray addObject:[[ReadStatusRecord alloc]initReadStatusRecordwithRecipientName:crecipientname RecipientID:crecipientid Channel:cchannel ReadTime:creadtime Image:cimage Gender:cgender Centerkey:ccenterkey Recipientkey:crecipientkey Contactgroup:nil Relationship:nil iso_code:nil]];
                     
                 }
                 
             }
             
             //sort
             NSSortDescriptor *sortbyname = [NSSortDescriptor sortDescriptorWithKey:@"recipientname" ascending:YES selector:@selector(localizedStandardCompare:)];
             NSArray *sortDescriptors = @[sortbyname];
             allreadstatusarray = [NSMutableArray arrayWithArray:[allreadstatusarray sortedArrayUsingDescriptors:sortDescriptors]];
             
             filteredreadstatusarray=[[NSMutableArray alloc]initWithArray:allreadstatusarray];
         }
     }];
    
}

-(NSString *) returnreadstatussummarywithcontactgrouparray:(NSMutableArray *)contactgrouparray
{
    BOOL NA=TRUE;
    BOOL AR=TRUE;
    BOOL NR=TRUE;
    
    for (int i=0; i<contactgrouparray.count; i++) {
        if ([((ReadStatusRecord *)[contactgrouparray objectAtIndex:i]).channel isEqualToString:@"A"]) {
            NA=FALSE;
            if ([((ReadStatusRecord *)[contactgrouparray objectAtIndex:i]).readtime isEqualToString:@""]) {
                AR=FALSE;
                if (!NR) {
                    break;
                }
            }else{
                NR=FALSE;
                if (!AR) {
                    break;
                }
            }
        }
    }
    
    if (NA) {
        return @"NA";
    }else{
        if (NR) {
            return @"NR";
        }else if (AR) {
            return @"AR";
        }else{
            return @"SR";
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([MessageTableMode isEqualToString:@"View"]) {
        return [workingMessage.photoarray count];
    }else{
        return [workingMessage.photoarray count]+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak MessagePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
    cell.layer.borderColor=[UIColor lightTextColor].CGColor;
    cell.layer.borderWidth=1;

    if ([MessageTableMode isEqualToString:@"View"]) {
        MessagePhotoRecord *obj=[workingMessage.photoarray objectAtIndex:indexPath.item];
        
        [cell.photoimageView setImage:obj.imageview.image];
        cell.addimagebutton.hidden=YES;
        cell.deleteimagebutton.hidden=YES;
        cell.videoplayicon.hidden=![obj.filetype isEqualToString:@"video"];
    }else{
        if (indexPath.item==workingMessage.photoarray.count) {
            [cell.photoimageView setImage:nil];
            cell.addimagebutton.hidden=NO;
            cell.deleteimagebutton.hidden=YES;
            cell.videoplayicon.hidden=YES;
            [cell.addimagebutton addTarget:self action:@selector(addMessagePhoto:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            MessagePhotoRecord *obj=[workingMessage.photoarray objectAtIndex:indexPath.item];
            [cell.photoimageView setImage:obj.imageview.image];
            cell.addimagebutton.hidden=YES;
            cell.deleteimagebutton.hidden=NO;
            cell.deleteimagebutton.tag=indexPath.item;
            cell.videoplayicon.hidden=![obj.filetype isEqualToString:@"video"];
            [cell.deleteimagebutton addTarget:self action:@selector(deleteMessagePhoto:) forControlEvents:UIControlEventTouchUpInside];
        }
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
    if ([MessageTableMode isEqualToString:@"View"] || (![MessageTableMode isEqualToString:@"View"] && indexPath.row<workingMessage.photoarray.count)) {
        messagephotoobject=[workingMessage.photoarray objectAtIndex:indexPath.row];
        [self showsidewindowwithwindow:@"MessagePhoto"];
        [self showFullScreenMessagePhoto];
        [self adjusttablesize];
    }
}

-(void) addMessagePhoto:(UIButton *)sender
{
    [self addphotobuttonpressed:sender];
}

-(void) deleteMessagePhoto:(UIButton *)sender
{

    if ([[workingMessage.photoarray objectAtIndex:sender.tag] isEqual:messagephotoobject]) {
        [avplayerviewcontroller.player pause];
        [self showsidewindowwithwindow:@"none"];
        [self adjusttablesize];
    }
 
    photoimagechanged=TRUE;
    [workingMessage.photoarray removeObjectAtIndex:sender.tag];
    NSRange range = NSMakeRange(6,1);
    NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
    [MessagePopoverTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
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
    photoimagechanged=TRUE;
    
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
                                        photoimagechanged=TRUE;
                                        UIImage *image=[[UIImage alloc]initWithData:imageData];
                                        imageData = UIImageJPEGRepresentation(image, 1.0);
                                        NSURL *imageURL=[MyClass returnInternalURLforNSData:imageData Filename:@"image"];
                                        //UIImage *image=[[UIImage alloc]initWithData:imageData];
                                        [workingMessage.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.width Height:image.size.height FileType:@"image" InternalURL:imageURL FileName:@"" ThumbnailURL:@""]];
                                    }
                                }
                            }];
                        }
                        
                        
                        NSRange range = NSMakeRange(6,1);
                        NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
                        [MessagePopoverTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
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
    photoimagechanged=TRUE;
    [self.delegate donotrunviewdidappear];
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
                NSRange range = NSMakeRange(6,1);
                NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
                [MessagePopoverTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
                
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
                NSRange range = NSMakeRange(6,1);
                NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
                [MessagePopoverTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
                [MyClass loadingindicatorwithoption:@"stop" color:@""];
            });
        }
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate donotrunviewdidappear];
    [imagepicker dismissViewControllerAnimated:YES completion:nil];
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    photoimagechanged=TRUE;
    [self.delegate donotrunviewdidappear];
    
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
                
                NSRange range = NSMakeRange(6,1);
                NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
                [MessagePopoverTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }
        }
        
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

-(void) showFullScreenMessagePhoto
{
    if ([messagephotoobject.filetype isEqualToString:@"image"]) {
        webView.hidden=YES;
        videoView.hidden=YES;
        [avplayerviewcontroller.player pause];
        [fullscreen_messageimageview setImage:messagephotoobject.imageview.image];
        
        float imageheight;
        float imagewidth;
        
        if (fullscreen_messageimageview.image.size.height/fullscreen_messageimageview.image.size.width*fullscreen_scrollview.frame.size.width>fullscreen_scrollview.frame.size.height) {
            imageheight=fullscreen_scrollview.frame.size.height;
            imagewidth=fullscreen_messageimageview.image.size.width*fullscreen_scrollview.frame.size.height/fullscreen_messageimageview.image.size.height;
            fullscreen_messageimageview.frame=CGRectMake((fullscreen_scrollview.frame.size.width-imagewidth)/2, 0, imagewidth, imageheight);
        }else{
            imageheight=fullscreen_messageimageview.image.size.height*fullscreen_scrollview.frame.size.width/fullscreen_messageimageview.image.size.width;
            imagewidth=fullscreen_scrollview.frame.size.width;;
            fullscreen_messageimageview.frame=CGRectMake(0, (fullscreen_scrollview.frame.size.height-imageheight)/2, imagewidth, imageheight);
        }
        fullscreen_scrollview.contentSize=CGSizeMake(fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    }else if ([messagephotoobject.filetype isEqualToString:@"pdf"]){
        webView.hidden=NO;
        videoView.hidden=YES;
        [avplayerviewcontroller.player pause];
        
        NSURL *pdfURL;
        if (![MessageTableMode isEqualToString:@"View"]) {
            pdfURL=messagephotoobject.internalurl;
        }else{
            NSString *strURL=[NSString stringWithFormat:@"%@messageimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,messagephotoobject.messagephotourl];
            pdfURL=[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        }

        [webView loadRequest:[NSURLRequest requestWithURL:pdfURL]];

    }else if ([messagephotoobject.filetype isEqualToString:@"video"]){
        webView.hidden=YES;
        videoView.hidden=NO;
        
        NSURL *videoURL;
        if (![MessageTableMode isEqualToString:@"View"]) {
            videoURL=messagephotoobject.internalurl;
        }else{
            NSString *strURL=[NSString stringWithFormat:@"%@messageimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,messagephotoobject.messagephotourl];
            videoURL=[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        }
        
        avplayerviewcontroller.player=[AVPlayer playerWithURL:videoURL];
    }
}

-(void) closefullscreen
{
    [avplayerviewcontroller.player pause];
    MessagePhotoMasterView.hidden=YES;
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([MessageTableMode isEqualToString:@"View"] || [MessageTableMode isEqualToString:@"Add"] || [MessageTableMode isEqualToString:@"Edit"]) {
        return fullscreen_messageimageview;
    }
    return nil;
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    if (fullscreen_messageimageview.frame.size.width<MessagePhotoMasterView.frame.size.width) {
        fullscreen_messageimageview.frame=CGRectMake((MessagePhotoMasterView.frame.size.width-fullscreen_messageimageview.frame.size.width)/2, fullscreen_messageimageview.frame.origin.y, fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    }else{
        fullscreen_messageimageview.frame=CGRectMake(0, fullscreen_messageimageview.frame.origin.y, fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    }
    
    if (fullscreen_messageimageview.frame.size.height<MessagePhotoMasterView.frame.size.height-44) {
        fullscreen_messageimageview.frame=CGRectMake(fullscreen_messageimageview.frame.origin.x, (MessagePhotoMasterView.frame.size.height-44-fullscreen_messageimageview.frame.size.height)/2, fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    }else{
        fullscreen_messageimageview.frame=CGRectMake(fullscreen_messageimageview.frame.origin.x, 0, fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    }
    
    //fullscreen_messageimageview.transform = CGAffineTransformMakeRotation(messagephotoobject.imagerotation90angle*M_PI_2);

}

-(void) rotateimage
{
    photoimagechanged=TRUE;
    [messagephotoobject.imageview setImage:[MyClass imageRotatedOnDegrees:90 Image:messagephotoobject.imageview.image]];
    messagephotoobject.internalurl=[MyClass returnInternalURLforNSData:UIImageJPEGRepresentation(messagephotoobject.imageview.image, 0.7) Filename:@"image"];
    [self showFullScreenMessagePhoto];
    [MessagePopoverTable reloadData];
}


-(void) shareimage:(UIButton *)sender
{
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *strURL=[NSString stringWithFormat:@"%@messageimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,messagephotoobject.messagephotourl];
            
        NSURL *url =[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        
        if ([messagephotoobject.filetype isEqualToString:@"image"]) {
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
            NSURL *fileUrl=[MyClass returnInternalURLforNSData:pdfdata Filename:messagephotoobject.filename];

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


-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    
    
    if([selectedItem isEqualToString:@"MessageStartTime"]){
        NSString *selecteddatestring=[selecteddatearray firstObject];
        if (![workingMessage.messagestarttime isEqualToString:[NSString stringWithFormat:@"%@ %@",[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:selecteddatestring],[workingMessage.messagestarttime substringFromIndex:11]]]) {
            workingMessage.messagestarttime=[NSString stringWithFormat:@"%@ %@",[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:selecteddatestring],[workingMessage.messagestarttime substringFromIndex:11]];

            [MessagePopoverTable reloadData];
            
            [self adjusttablesize];
            
        }
    }else if ([selectedItem isEqualToString:@"ClassDate"]){
        workingMessage.recipientgroup.classdatearray=[[NSMutableArray alloc]initWithArray:selecteddatearray];
        [MessagePopoverTable reloadData];
    }else if ([selectedItem isEqualToString:@"ExpiryDate"]){
        workingMessage.hn_expiry_date=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:[selecteddatearray firstObject]];
        if ([MessageTableMode isEqualToString:@"View"]) {
            [self createViewBarButton];
        }
        [MessagePopoverTable reloadData];
    }
}

-(void) sendMessageWithOutBoxMessage:(OutboxMessageRecord *)outboxmessage
{
    globalvariables=[GlobalVariables singleObj];
    MessageTableMode=@"Add";
    workingMessage=outboxmessage;
    workingMessage.messagestarttime=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];

    workingMessage.recipienttype=@"Student";
    workingMessage.channel=@"A";


    automessage=YES;
    photoimagechanged=YES;
    [self updatemessagewithdraft2:NO];
}

-(void) hotnewspressed:(UISwitch *)sender
{
    workingMessage.hotnews=sender.on;
    [MessagePopoverTable reloadData];
    
    if ([MessageTableMode isEqualToString:@"View"]) {
        [self createViewBarButton];
    }
}

-(void) returnCalendarYear:(NSString *)year
{
//    yearButton.title=year;
    [yearButton setTitle:year forState:UIControlStateNormal];
}

-(void) sendAssessmentReport
{
    if (!globalvariables) {
        globalvariables=[GlobalVariables singleObj];
    }
    
    NSMutableDictionary *assessmentReportDict=[MyClass retrieveAssessmentReportWithSendOutboxDocument:@"Yes" studentkey:@"" formkey:@"" periodstart:@"" periodend:@"" classkey:@""];
    NSString *centerkey=assessmentReportDict[@"centerkey"];
    NSString *outboxdocumentkey=assessmentReportDict[@"outboxdocumentkey"];
    NSString *studentkey=assessmentReportDict[@"studentkey"];
    NSString *formname=assessmentReportDict[@"formname"];

    outboxDocumentKeyCenterkey=[[NSMutableDictionary alloc]init];
    if (centerkey && outboxdocumentkey) {
        [outboxDocumentKeyCenterkey setValue:outboxdocumentkey forKey:@"outboxdocumentkey"];
        [outboxDocumentKeyCenterkey setValue:centerkey forKey:@"centerkey"];

        NSData *pdfData=[MyClass generateAssessmentReportWithAssessmentReportDict:assessmentReportDict sendAssessmentReport:YES];
        NSString *filename=formname;
        
        OutboxMessageRecord *object=[[OutboxMessageRecord alloc]init];
        object.photoarray=[[NSMutableArray alloc]init];
        object.messageenglish=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"Assessment Report" language:@"English"],filename];
        object.messagechinese=[NSString stringWithFormat:@"%@%@",[MyClass returntitlewithtitle:@"Assessment Report" language:@"Chinese"],filename];
        object.recipienttype=@"Student";
        object.recipientgroup=[[RecipientGroupRecord alloc]init];
        object.recipientgroup.individualarray=[[NSMutableArray alloc]initWithArray:@[studentkey]];
        object.messagetype=@"Assessment";
        object.composer=@"System";
        
        NSURL *interalurl=[MyClass returnInternalURLforNSData:pdfData Filename:[NSString stringWithFormat:@"%@.pdf", object.messageenglish]];
        [object.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:nil Width:0 Height:0 FileType:@"pdf" InternalURL:interalurl FileName:[NSString stringWithFormat:@"%@.pdf", object.messageenglish] ThumbnailURL:@""]];
        [self sendMessageWithOutBoxMessage:object];
        
    }
    
}

-(void) sendOutboxDocument
{
    if (!globalvariables) {
        globalvariables=[GlobalVariables singleObj];
    }
        
    NSMutableArray *studentkeys=[[NSMutableArray alloc]init];
    NSMutableDictionary *documentfolderarray=[MyClass retrieveDocumentFolderRecordWithSendOutboxDocument:@"Yes"];
    
    NSMutableArray *classreceiptarray=documentfolderarray[@"classreceiptarray"];
    NSMutableArray *salesreceiptarray=documentfolderarray[@"salesreceiptarray"];
    NSMutableArray *classinvoicearray=documentfolderarray[@"classinvoicearray"];
    NSMutableArray *salesinvoicearray=documentfolderarray[@"salesinvoicearray"];
    NSString *centerkey=documentfolderarray[@"centerkey"];
    NSString *outboxdocumentkey=documentfolderarray[@"outboxdocumentkey"];
    NSString *documenttype=documentfolderarray[@"documenttype"];
    
    outboxDocumentKeyCenterkey=[[NSMutableDictionary alloc]init];
    if (centerkey && outboxdocumentkey) {
        [outboxDocumentKeyCenterkey setValue:outboxdocumentkey forKey:@"outboxdocumentkey"];
        [outboxDocumentKeyCenterkey setValue:centerkey forKey:@"centerkey"];
        
        if([documenttype isEqualToString:@"Receipt"]){
            for (int i=0; i<classreceiptarray.count; i++) {
                ClassReceiptRecord *record=[classreceiptarray objectAtIndex:i];
                if (![studentkeys containsObject:record.studentkey]) {
                    [studentkeys addObject:record.studentkey];
                }
            }
            
            for (int i=0; i<salesreceiptarray.count; i++) {
                SalesReceiptRecord *record=[salesreceiptarray objectAtIndex:i];
                if (![studentkeys containsObject:record.studentkey]) {
                    [studentkeys addObject:record.studentkey];
                }
            }
            
            if (classreceiptarray.count+salesreceiptarray.count>0) {
                globalvariables.documentfolderdict=documentfolderarray;
                
                NSData *pdfData=[MyClass generateReceiptWithClassReceiptArray:classreceiptarray SalesReceiptArray:salesreceiptarray papersizeoverride:YES combinedocument:YES centerkey:centerkey];
                    NSString *filename=[MyClass returnreceiptnumberwithclassreceiptarray:classreceiptarray salesreceiptarray:salesreceiptarray];
                    
                OutboxMessageRecord *object=[[OutboxMessageRecord alloc]init];
                object.photoarray=[[NSMutableArray alloc]init];
                object.messageenglish=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"Receipt" language:@"English"],filename];
                object.messagechinese=[NSString stringWithFormat:@"%@%@",[MyClass returntitlewithtitle:@"Receipt" language:@"Chinese"],filename];
                object.recipienttype=@"Student";
                object.recipientgroup=[[RecipientGroupRecord alloc]init];
                object.recipientgroup.individualarray=[[NSMutableArray alloc]initWithArray:studentkeys];
                object.messagetype=@"eReceipt";
                object.composer=@"System";
                
                NSURL *interalurl=[MyClass returnInternalURLforNSData:pdfData Filename:[NSString stringWithFormat:@"%@.pdf", object.messageenglish]];
                [object.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:nil Width:0 Height:0 FileType:@"pdf" InternalURL:interalurl FileName:[NSString stringWithFormat:@"%@.pdf", object.messageenglish] ThumbnailURL:@""]];
                [self sendMessageWithOutBoxMessage:object];
                
            }
        }else if ([documenttype isEqualToString:@"Invoice"]){
            for (int i=0; i<classinvoicearray.count; i++) {
                ClassInvoiceRecord *record=[classinvoicearray objectAtIndex:i];
                if (![studentkeys containsObject:record.studentkey]) {
                    [studentkeys addObject:record.studentkey];
                }
            }
            
            for (int i=0; i<salesinvoicearray.count; i++) {
                SalesInvoiceRecord *record=[salesinvoicearray objectAtIndex:i];
                if (![studentkeys containsObject:record.studentkey]) {
                    [studentkeys addObject:record.studentkey];
                }
            }
            
            if (classinvoicearray.count+salesinvoicearray.count>0) {
                globalvariables.documentfolderdict=documentfolderarray;
                
                NSData *pdfData=[MyClass generateInvoiceWithClassInvoiceArray:classinvoicearray SalesInvoiceArray:salesinvoicearray papersizeoverride:YES combinedocument:YES centerkey:centerkey];
                
                NSString *filename=[MyClass returninvoicenumberwithclassinvoicearray:classinvoicearray salesinvoicearray:salesinvoicearray updateinvoicelog:NO];
                
                OutboxMessageRecord *object=[[OutboxMessageRecord alloc]init];
                object.photoarray=[[NSMutableArray alloc]init];
                object.messageenglish=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"Invoice" language:@"English"],filename];
                object.messagechinese=[NSString stringWithFormat:@"%@%@",[MyClass returntitlewithtitle:@"Invoice" language:@"Chinese"],filename];
                object.recipienttype=@"Student";
                object.recipientgroup=[[RecipientGroupRecord alloc]init];
                object.recipientgroup.individualarray=[[NSMutableArray alloc]initWithArray:studentkeys];
                object.messagetype=@"eInvoice";
                object.composer=@"System";
                
                NSURL *interalurl=[MyClass returnInternalURLforNSData:pdfData Filename:[NSString stringWithFormat:@"%@.pdf", object.messageenglish]];
                [object.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:nil Width:0 Height:0 FileType:@"pdf" InternalURL:interalurl FileName:[NSString stringWithFormat:@"%@.pdf", object.messageenglish] ThumbnailURL:@""]];
                [self sendMessageWithOutBoxMessage:object];
            }
        }
        
    }
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"attachment"]){
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

- (IBAction)backbuttonpressed:(id)sender {
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@""];
    [self adjusttablesize];
    [MessagePopoverTable deselectRowAtIndexPath:[MessagePopoverTable indexPathForSelectedRow] animated:YES];
    
}

- (IBAction)centernonebuttonpressed:(id)sender {
    selectedCenters=nil;
    [self backbuttonpressed:nil];
    [MessagePopoverTable reloadData];
}

- (IBAction)centerallbuttonpressed:(id)sender {
    selectedCenters=[[NSMutableArray alloc]init];
    [self backbuttonpressed:nil];
    [MessagePopoverTable reloadData];
}

@end
