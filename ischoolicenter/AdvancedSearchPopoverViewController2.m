//
//  AdvancedSearchPopoverViewController2.m
//  iCenter
//
//  Created by Jasmond Luk on 3/12/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import "AdvancedSearchPopoverViewController2.h"
#import "MyClass.h"
#import "MyTableViewCell.h"

@interface AdvancedSearchPopoverViewController2 ()

@end

@implementation AdvancedSearchPopoverViewController2
#define maxPopupHeight self.view.frame.size.height
#define popoverwidth 320
#define subjecttablewidth 450
#define instructortablewidth 300
#define classdatetablewidth 320
#define gradetablewidth 300
#define studentstatustablewidth 300
#define droptablewidth 300
#define producttablewidth 400
#define paymentstatustablewidth 300

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    
    [self createsidetables];
    [self adjusttablesize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    workingMessage=[[OutboxMessageRecord alloc]init];
    workingMessage.recipientgroup=[[RecipientGroupRecord alloc]init];
    workingMessage.recipientgroup.subjectarray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.instructorarray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.classdatearray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.gradearray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.studentstatusarray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.droparray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.productarray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.paymentstatusarray=[[NSMutableArray alloc]init];
    
    
    UIBarButtonItem *resetButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset"] style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonPressed:)];
    UIBarButtonItem *searchButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonPressed:)];
    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *buttons =[NSArray arrayWithObjects:resetButton,flexibleSpaceBarButton,searchButton,nil];
    [MessageToolbar setItems:buttons animated:NO];
    
    productsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    producttitle.text=[[MyClass returntitlewithtitle:@"Product"] uppercaseString];
    paymentstatustitle.text=[[MyClass returntitlewithtitle:@"Payment Status"] uppercaseString];
    [paymentstatusresettoanybutton setTitle:[MyClass returntitlewithtitle:@"Reset to Any"] forState:UIControlStateNormal];
    [productresetotanybutton setTitle:[MyClass returntitlewithtitle:@"Reset to Any"] forState:UIControlStateNormal];
    
    [self updateTableRowArray];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) returnCalendarYear:(NSString *)year
{
//    yearButton.title=year;
}

-(void) updateTableRowArray
{
    recipientRowDataArray=[[NSMutableArray alloc]init];
    [recipientRowDataArray addObject:@"Subject"];
    [recipientRowDataArray addObject:@"Instructor"];
    [recipientRowDataArray addObject:@"ClassDate"];
    [recipientRowDataArray addObject:@"Grade"];
    [recipientRowDataArray addObject:@"StudentStatus"];
    [recipientRowDataArray addObject:@"Drop"];
    [recipientRowDataArray addObject:@"Product"];
    [recipientRowDataArray addObject:@"PaymentStatus"];
}

-(void) createsidetables
{
    studentstatusarray=[[NSMutableArray alloc]initWithObjects:@"Attending",@"Future",@"No Scheduled Class",nil];
    //staffgrouparray=[MyClass returnStaffGroupArrayIncludeAll:NO];
    
    allsubjectarray=[MyClass retrievesubjectinformationwithstatus:@"Active" category:@"All" flushcachedata:NO];
    filteredsubjectarray=[[NSMutableArray alloc]initWithArray:allsubjectarray];
    
    allinstructorarray=[MyClass filterInstructorArrayWithInstructorArray:[MyClass retrieveInstructorListwithvalid:@"All" flushcachedata:NO] Valid:@"Yes"];
    filteredinstructorarray=[[NSMutableArray alloc]initWithArray:allinstructorarray];
    
    gradearray=[[NSMutableArray alloc]initWithArray:[((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).grade componentsSeparatedByString:@","]];
    
    allproductarray=[MyClass retrieveproductinformationwithcategory:@"All" status:@"Active" flushcachedata:NO];
    filteredproductarray=[[NSMutableArray alloc]initWithArray:allproductarray];
    
    droparray=[[NSMutableArray alloc]initWithObjects:@"Non Drop",@"Dropped",nil];
    
    paymentstatusarray=[[NSMutableArray alloc]initWithObjects:@"Overdue",@"Reminder",@"Credit",nil];
    
    
//    activearray=[[NSMutableArray alloc]initWithObjects:@"Active",@"Inactive",nil];
    
    
    
    //instructor table
    InstructorTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, instructortablewidth, self.view.frame.size.height)];
    [self.view addSubview:InstructorTableMasterView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, InstructorTableMasterView.frame.size.width,84)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [InstructorTableMasterView addSubview:headerView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
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
    StudentStatusTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, studentstatustablewidth, self.view.frame.size.height)];
    [self.view addSubview:StudentStatusTableMasterView];
    StudentStatusTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, studentstatustablewidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    StudentStatusTable.dataSource=self;
    StudentStatusTable.delegate=self;
    [StudentStatusTable reloadData];
    
    [StudentStatusTableMasterView addSubview:StudentStatusTable];
    StudentStatusTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, studentstatustablewidth, 44)];
    StudentStatusTableToolBar.clipsToBounds=YES;
    [StudentStatusTableMasterView addSubview:StudentStatusTableToolBar];
    [self createStudentStatusTableToolBar];
    
    
    
    
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
    
    //add separator
    UILabel *separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth, 20, 0.6, self.view.frame.size.height-44)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
    
    
}

-(void) createInstructorTableToolBar
{
    NSMutableArray *barItems=[[NSMutableArray alloc]init];
    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
    
    
    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,anyButton, nil];
    [InstructorTableToolBar setItems:barItems];
}

-(void) createClassDateTableToolBar
{
    NSMutableArray *barItems=[[NSMutableArray alloc]init];
    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
    
    yearButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,yearButton,flexSpace,anyButton, nil];
    [ClassDateTableToolBar setItems:barItems];
}


-(void) createGradeTableToolBar
{
    NSMutableArray *barItems=[[NSMutableArray alloc]init];
    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
    
    
    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,anyButton, nil];
    [GradeTableToolBar setItems:barItems];
}

-(void) createStudentStatusTableToolBar
{
    NSMutableArray *barItems=[[NSMutableArray alloc]init];
    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
    
    
    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,anyButton, nil];
    [StudentStatusTableToolBar setItems:barItems];
}

-(void) createSubjectTableToolBar
{
    NSMutableArray *barItems=[[NSMutableArray alloc]init];
    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];

    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
    
    
    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,anyButton, nil];
    [SubjectTableToolBar setItems:barItems];
}

-(void) createDropTableToolBar
{
    NSMutableArray *barItems=[[NSMutableArray alloc]init];
    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *anyButton = [[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset to Any"] style:UIBarButtonItemStylePlain target:self action:@selector(anybuttonpressed)];
    
    
    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,anyButton, nil];
    [DropTableToolBar setItems:barItems];
}

-(void) adjusttablesize
{
    tablebottomconstraint.constant=keyboardheight;
    paymentstatustablebottomconstraint.constant=keyboardheight;
    producttablebottomconstraint.constant=keyboardheight;
    
    float tableheight;
    float tablewidth;
    
    tableheight=maxPopupHeight-keyboardheight;
    
    
    if (showSubjectTable){
        tablewidth=popoverwidth+subjecttablewidth;
    }else if (showInstructorTable){
        tablewidth=popoverwidth+instructortablewidth;
    }else if (showClassDateTable){
        tablewidth=popoverwidth+classdatetablewidth;
    }else if (showGradeTable){
        tablewidth=popoverwidth+gradetablewidth;
    }else if (showStudentStatusTable){
        tablewidth=popoverwidth+studentstatustablewidth;
    }else if (showDropTable){
        tablewidth=popoverwidth+droptablewidth;
    }else if (showProductTable){
        tablewidth=popoverwidth+producttablewidth;
    }else if (showPaymentStatusTable){
        tablewidth=popoverwidth+paymentstatustablewidth;
    }else{
        tablewidth=popoverwidth;
    }
    
    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    
    self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
    
    
    if (showSubjectTable){
        [SubjectTable setFrame:CGRectMake(0, 44+84+20, subjecttablewidth, tableheight-44-84-20)];
        SubjectTableMasterView.hidden=NO;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ProductTableMasterView.hidden=YES;
        PaymentStatusTableMasterView.hidden=YES;
    }else if (showInstructorTable){
        [InstructorTable setFrame:CGRectMake(0, 44+84+20, instructortablewidth, tableheight-44-84-20)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=NO;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ProductTableMasterView.hidden=YES;
        PaymentStatusTableMasterView.hidden=YES;
    }else if (showClassDateTable){
        [ClassDateTable setFrame:CGRectMake(0, 44+20, classdatetablewidth, tableheight-44-20)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=NO;
        GradeTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ProductTableMasterView.hidden=YES;
        PaymentStatusTableMasterView.hidden=YES;
    }else if (showGradeTable){
        [GradeTable setFrame:CGRectMake(0, 44+20, gradetablewidth, tableheight-44-20)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=NO;
        StudentStatusTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ProductTableMasterView.hidden=YES;
        PaymentStatusTableMasterView.hidden=YES;
    }else if (showStudentStatusTable){
        [StudentStatusTable setFrame:CGRectMake(0, 44+20, studentstatustablewidth, tableheight-44-20)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=NO;
        DropTableMasterView.hidden=YES;
        ProductTableMasterView.hidden=YES;
        PaymentStatusTableMasterView.hidden=YES;
    }else if (showDropTable){
        [DropTable setFrame:CGRectMake(0, 44+20, droptablewidth, tableheight-44-20)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        DropTableMasterView.hidden=NO;
        ProductTableMasterView.hidden=YES;
        PaymentStatusTableMasterView.hidden=YES;
    }else if (showProductTable){
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ProductTableMasterView.hidden=NO;
        PaymentStatusTableMasterView.hidden=YES;
    }else if (showPaymentStatusTable){
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ProductTableMasterView.hidden=YES;
        PaymentStatusTableMasterView.hidden=NO;
    }else{
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassDateTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        StudentStatusTableMasterView.hidden=YES;
        DropTableMasterView.hidden=YES;
        ProductTableMasterView.hidden=YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==MessagePopoverTable) {
        if (section==0) {
            return recipientRowDataArray.count;
        }
        return 1;
    }else if (tableView==SubjectTable){
        return filteredsubjectarray.count;
    }else if (tableView==InstructorTable){
        return filteredinstructorarray.count;
    }else if (tableView==ClassDateTable){
        return showClassDateTable?1:0;
    }else if (tableView==GradeTable){
        return gradearray.count;
    }else if (tableView==StudentStatusTable){
        return studentstatusarray.count;
    }else if (tableView==DropTable){
        return droparray.count;
    }else if (tableView==ProductTable){
        return filteredproductarray.count;
    }else if (tableView==PaymentStatusTable){
        return paymentstatusarray.count;
    }
    return 0;

}

-(NSString *) returnconditionnamewitharray:(NSMutableArray *)array condition:(NSString *)condition
{
    NSMutableArray *tmparray=[[NSMutableArray alloc]init];
    
    if (array.count==0) {
        return [MyClass returntitlewithtitle:@"Any"];
    }/*else if (array.count>1){
      return [NSString stringWithFormat:@"%@(%lu)",[MyClass returntitlewithtitle:@"Multiple"],(unsigned long)array.count];
      }*/else{
          if ([condition isEqualToString:@"Subject"]) {
              for (int i=0; i<array.count; i++) {
                  [tmparray addObject:[MyClass returnsubjectnamewithsubject_shortname:[array objectAtIndex:i] centerkey:globalvariables.centerrecord.centerkey]];
              }
              return [tmparray componentsJoinedByString:@" | "];
          }else if ([condition isEqualToString:@"Instructor"]) {
              for (int i=0; i<array.count; i++) {
                  [tmparray addObject:[MyClass returnstaffnamewithusername:[array objectAtIndex:i] firstorfullname:@"full"]];
              }
              return [tmparray componentsJoinedByString:@" | "];
          }else if ([condition isEqualToString:@"ClassDate"]) {
              for (int i=0; i<array.count; i++) {
                  [tmparray addObject:[MyClass returndateformatwithdate:[array objectAtIndex:i]]];
              }
              return [tmparray componentsJoinedByString:@" | "];
          }else if ([condition isEqualToString:@"Grade"]) {
              for (int i=0; i<array.count; i++) {
                  [tmparray addObject:[MyClass returntitlewithtitle:[array objectAtIndex:i]]];
              }
              return [tmparray componentsJoinedByString:@" | "];
          }else if ([condition isEqualToString:@"StudentStatus"]) {
              for (int i=0; i<array.count; i++) {
                  [tmparray addObject:[MyClass returntitlewithtitle:[array objectAtIndex:i]]];
              }
              return [tmparray componentsJoinedByString:@" | "];
          }else if ([condition isEqualToString:@"Drop"]) {
              for (int i=0; i<array.count; i++) {
                  [tmparray addObject:[MyClass returntitlewithtitle:[array objectAtIndex:i]]];
              }
              return [tmparray componentsJoinedByString:@" | "];
          }else if ([condition isEqualToString:@"PaymentStatus"]) {
              for (int i=0; i<array.count; i++) {
                  [tmparray addObject:[MyClass returntitlewithtitle:[array objectAtIndex:i]]];
              }
              return [tmparray componentsJoinedByString:@" | "];
          }else if ([condition isEqualToString:@"Product"]) {
              for (int i=0; i<array.count; i++) {
                  [tmparray addObject:[MyClass returnproductnamewithproductcode:[array objectAtIndex:i] centerkey:globalvariables.centerrecord.centerkey]];
              }
              return [tmparray componentsJoinedByString:@" | "];
          }else if ([condition isEqualToString:@"PaymentStatus"]) {
              for (int i=0; i<array.count; i++) {
                  [tmparray addObject:[MyClass returntitlewithtitle:[array objectAtIndex:i]]];
              }
              return [tmparray componentsJoinedByString:@" | "];
          }
      }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==MessagePopoverTable) {
        return UITableViewAutomaticDimension;
    }else if (tableView==ClassDateTable){
        return ClassDateTableMasterView.frame.size.height-64;
    }else if (tableView==ProductTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==PaymentStatusTable){
        return UITableViewAutomaticDimension;
    }
    return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==SubjectTable) {
        return CGFLOAT_MIN;
    }else if (tableView==InstructorTable) {
        return CGFLOAT_MIN;
    }else if (tableView==ProductTable) {
        return CGFLOAT_MIN;
    }else if (tableView==PaymentStatusTable) {
        return CGFLOAT_MIN;
    }
    return 38;
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
    
    if (tableView==MessagePopoverTable) {
        MyTableViewCell *myCell;
        
        
            if (indexPath.section==0) {
                if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Subject"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Subject"];
                    myCell.label2.text=[self returnconditionnamewitharray:workingMessage.recipientgroup.subjectarray condition:@"Subject"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Instructor"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Instructor"];
                    myCell.label2.text=[self returnconditionnamewitharray:workingMessage.recipientgroup.instructorarray condition:@"Instructor"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"ClassDate"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Class Date"];
                    myCell.label2.text=[self returnconditionnamewitharray:workingMessage.recipientgroup.classdatearray condition:@"ClassDate"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Grade"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Grade"];
                    myCell.label2.text=[self returnconditionnamewitharray:workingMessage.recipientgroup.gradearray condition:@"Grade"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"StudentStatus"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Status"];
                    myCell.label2.text=[self returnconditionnamewitharray:workingMessage.recipientgroup.studentstatusarray condition:@"StudentStatus"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Drop"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Drop"];
                    myCell.label2.text=[self returnconditionnamewitharray:workingMessage.recipientgroup.droparray condition:@"Drop"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Product"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Product"];
                    myCell.label2.text=[self returnconditionnamewitharray:workingMessage.recipientgroup.productarray condition:@"Product"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"PaymentStatus"]){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Payment Status"];
                    myCell.label2.text=[self returnconditionnamewitharray:workingMessage.recipientgroup.paymentstatusarray condition:@"PaymentStatus"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
            }
            
            
            return myCell;
            
        
        
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
    }else if (tableView==ClassDateTable) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        CalendarView *calendarview;

        calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, classdatetablewidth, ((CGRect)[tableView rectForRowAtIndexPath:indexPath]).size.height) Theme:3 CanPickHoliday:NO MultipleSelection:YES ShowTodayButton:NO showclassdot:NO schedulerecord:nil  UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
        [calendarview scrollToSelectedDateWithSelectedDateArray:workingMessage.recipientgroup.classdatearray.count>0?workingMessage.recipientgroup.classdatearray:nil ScrollToDate:workingMessage.recipientgroup.classdatearray.count>0?nil:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] instructorselected:nil];
        

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
    }else if (tableView==ProductTable){
        MyTableViewCell *myCell;
        static NSString *CellIdentifier = @"productcell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        ProductRecord *obj=[filteredproductarray objectAtIndex:indexPath.row];
        [MyClass downloadImageWithImageview:myCell.imageview1 gender:nil type:@"product" typekey:obj.code image:@"Yes" async:YES];
        myCell.label1.text=[MyClass returnproductnamewithproductcode:obj.code centerkey:globalvariables.centerrecord.centerkey];
        myCell.label2.text=obj.code;
        myCell.imageview2.hidden=[workingMessage.recipientgroup.productarray containsObject:obj.code]?NO:YES;
        
//        myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        return myCell;
    }else if (tableView==PaymentStatusTable){
        MyTableViewCell *myCell;
        static NSString *CellIdentifier = @"paymentstatuscell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        myCell.label1.text=[MyClass returntitlewithtitle:paymentstatusarray[indexPath.row]];
        myCell.imageview2.layer.opacity=[workingMessage.recipientgroup.paymentstatusarray containsObject:paymentstatusarray[indexPath.row]]?1.0:0.0;
        
//        myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        return myCell;
    }

    return cell;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==MessagePopoverTable) {
        
        if(section==0){
            return [MyClass returntitlewithtitle:@"Advanced Student Search"];
        }

    }if (tableView==ClassDateTable){
        return [MyClass returntitlewithtitle:@"Class Date"];
    }else if (tableView==GradeTable){
        return [MyClass returntitlewithtitle:@"Grade"];
    }else if (tableView==StudentStatusTable){
        return [MyClass returntitlewithtitle:@"Status"];
    }else if (tableView==DropTable){
        return [MyClass returntitlewithtitle:@"Drop"];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==MessagePopoverTable) {
            if (indexPath.section==0) {
                if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Subject"]) {
                    [self showsidewindowwithwindow:@"Subject"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Instructor"]) {
                    [self showsidewindowwithwindow:@"Instructor"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"ClassDate"]) {
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
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"PaymentStatus"]) {
                    [self showsidewindowwithwindow:@"PaymentStatus"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }else if ([[recipientRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Product"]) {
                    [self showsidewindowwithwindow:@"Product"];
                    [MessagePopoverTable reloadData];
                    [self adjusttablesize];
                }
            }
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
    }else if (tableView==GradeTable){
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
    }else if (tableView==ProductTable){
        if ([workingMessage.recipientgroup.productarray containsObject:((ProductRecord *)[filteredproductarray objectAtIndex:indexPath.row]).code]) {
            [workingMessage.recipientgroup.productarray removeObject:((ProductRecord *)[filteredproductarray objectAtIndex:indexPath.row]).code];
        }else{
            [workingMessage.recipientgroup.productarray addObject:((ProductRecord *)[filteredproductarray objectAtIndex:indexPath.row]).code];
        }

        //[self storeTmpField];
        [self updateTableRowArray];
        [MessagePopoverTable reloadData];
        [ProductTable reloadData];
        
        [self adjusttablesize];
        
    }else if (tableView==PaymentStatusTable){
        if ([workingMessage.recipientgroup.paymentstatusarray containsObject:[paymentstatusarray objectAtIndex:indexPath.row]]) {
            [workingMessage.recipientgroup.paymentstatusarray removeObject:[paymentstatusarray objectAtIndex:indexPath.row]];
        }else{
            [workingMessage.recipientgroup.paymentstatusarray addObject:[paymentstatusarray objectAtIndex:indexPath.row]];
        }

        //[self storeTmpField];
        [self updateTableRowArray];
        [MessagePopoverTable reloadData];
        [PaymentStatusTable reloadData];
        
        [self adjusttablesize];
        
    }
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    if ([windowname isEqualToString:@"Subject"]) {
        showSubjectTable=YES;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showStudentStatusTable=NO;
        showDropTable=NO;
        showPaymentStatusTable=NO;
        showProductTable=NO;
        [SubjectTable reloadData];
    }else if ([windowname isEqualToString:@"Instructor"]) {
        showSubjectTable=NO;
        showInstructorTable=YES;
        showClassDateTable=NO;
        showGradeTable=NO;
        showStudentStatusTable=NO;
        showDropTable=NO;
        showPaymentStatusTable=NO;
        showProductTable=NO;
        [InstructorTable reloadData];
    }else if ([windowname isEqualToString:@"ClassDate"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=YES;
        showGradeTable=NO;
        showStudentStatusTable=NO;
        showDropTable=NO;
        showPaymentStatusTable=NO;
        showProductTable=NO;
        [self createClassDateTableToolBar];
        [ClassDateTable reloadData];
    }else if ([windowname isEqualToString:@"Grade"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=YES;
        showStudentStatusTable=NO;
        showDropTable=NO;
        showPaymentStatusTable=NO;
        showProductTable=NO;
        [GradeTable reloadData];
    }else if ([windowname isEqualToString:@"StudentStatus"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showStudentStatusTable=YES;
        showDropTable=NO;
        showPaymentStatusTable=NO;
        showProductTable=NO;
        [StudentStatusTable reloadData];
    }else if ([windowname isEqualToString:@"Drop"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showStudentStatusTable=NO;
        showDropTable=YES;
        showPaymentStatusTable=NO;
        showProductTable=NO;
        [DropTable reloadData];
    }else if ([windowname isEqualToString:@"PaymentStatus"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showStudentStatusTable=NO;
        showDropTable=NO;
        showPaymentStatusTable=YES;
        showProductTable=NO;
        [PaymentStatusTable reloadData];
    }else if ([windowname isEqualToString:@"Product"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showStudentStatusTable=NO;
        showDropTable=NO;
        showPaymentStatusTable=NO;
        showProductTable=YES;
        [ProductTable reloadData];
    }else{
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassDateTable=NO;
        showGradeTable=NO;
        showStudentStatusTable=NO;
        showDropTable=NO;
        showPaymentStatusTable=NO;
        showProductTable=NO;
    }
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    workingMessage.recipientgroup.classdatearray=[[NSMutableArray alloc]initWithArray:selecteddatearray];
    [MessagePopoverTable reloadData];
}

- (IBAction)paymentstatus_resettoanybuttonpressed:(id)sender {
    workingMessage.recipientgroup.paymentstatusarray=[[NSMutableArray alloc]init];
    [MessagePopoverTable reloadData];
    [self showsidewindowwithwindow:@"none"];
    [self adjusttablesize];
}

- (IBAction)product_resettoanybuttonpressed:(id)sender {
    workingMessage.recipientgroup.productarray=[[NSMutableArray alloc]init];
    [MessagePopoverTable reloadData];
    [self showsidewindowwithwindow:@"none"];
    [self adjusttablesize];
}

- (IBAction)closesidewindow:(id)sender {
    [self closesidewindow];
}

-(void) closesidewindow
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [MessagePopoverTable deselectRowAtIndexPath:[MessagePopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) anybuttonpressed
{
    if (showSubjectTable){
        workingMessage.recipientgroup.subjectarray=[[NSMutableArray alloc]init];
        subjectsearchbar.text=@"";
        filteredsubjectarray=[[NSMutableArray alloc]initWithArray:allsubjectarray];
    }else if (showInstructorTable){
        workingMessage.recipientgroup.instructorarray=[[NSMutableArray alloc]init];
        instructorsearchbar.text=@"";
        filteredinstructorarray=[[NSMutableArray alloc]initWithArray:allinstructorarray];
    }else if (showClassDateTable){
        workingMessage.recipientgroup.classdatearray=[[NSMutableArray alloc]init];
    }else if (showGradeTable){
        workingMessage.recipientgroup.gradearray=[[NSMutableArray alloc]init];
    }else if (showStudentStatusTable){
        workingMessage.recipientgroup.studentstatusarray=[[NSMutableArray alloc]init];
    }else if (showDropTable){
        workingMessage.recipientgroup.droparray=[[NSMutableArray alloc]init];
    }
    
    [self closesidewindow];
    [self updateTableRowArray];
    [MessagePopoverTable reloadData];
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

-(BOOL) checkifclassdate:(NSString *)value
{
    if ([value length]>=11) {
        NSDate *date=[MyClass convertToNSDateWithDate:[value substringToIndex:11] DateFormat:@"dd-MMM-yyyy"];
        if (date) {
            return TRUE;
        }else{
            return FALSE;
        }
    }else{
        return FALSE;
    }
}

-(void) resetButtonPressed:(UIBarButtonItem *)sender
{
    workingMessage.recipientgroup=[[RecipientGroupRecord alloc]init];
    workingMessage.recipientgroup.subjectarray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.instructorarray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.classdatearray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.gradearray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.studentstatusarray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.droparray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.productarray=[[NSMutableArray alloc]init];
    workingMessage.recipientgroup.paymentstatusarray=[[NSMutableArray alloc]init];
    [MessagePopoverTable reloadData];
    [self showsidewindowwithwindow:@"none"];
    [self adjusttablesize];
}

-(void) searchButtonPressed:(UIBarButtonItem *)sender
{
    [self.delegate dismissAdvancedSearchWithLoading:YES];
    
//    [MyClass loadingindicatorwithoption:@"Start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
            values=[NSArray arrayWithObjects:@"classdate",[MyClass convertDateFormatWithDate:[workingMessage.recipientgroup.classdatearray objectAtIndex:i] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO], nil];
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
        
        for (int i=0; i<workingMessage.recipientgroup.paymentstatusarray.count; i++) {
            values=[NSArray arrayWithObjects:@"paymentstatus",[workingMessage.recipientgroup.paymentstatusarray objectAtIndex:i], nil];
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
        
        for (int i=0; i<workingMessage.recipientgroup.productarray.count; i++) {
            values=[NSArray arrayWithObjects:@"product",[workingMessage.recipientgroup.productarray objectAtIndex:i], nil];
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
        
        recipientgrouparray = [NSArray arrayWithArray:arrayOfDicts];
        
        [dictionary setValue:@"getstudentsearchlist" forKey:@"postaction"];
        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
        [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dictionary setValue:recipientgrouparray forKey:@"recipientgroup"];

        __block BOOL result=FALSE;
        __block NSMutableArray *studentArray;
        [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                NSMutableArray * JSONArray = jsonreturned[@"content"];
                 studentArray=[[NSMutableArray alloc]init];
                for (int i=0; i<JSONArray.count; i++) {
                    NSString * typekey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                    Student *object=[MyClass returnstudentwithstudentkey:typekey];
                    [studentArray addObject:object];
                }
            }
        }];
        
        if (result) {
            [self.delegate returnSearchResult:studentArray];
        }else{
            [self.delegate dismissAdvancedSearchWithLoading:NO];
        }
    });
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
    }else if (searchBar==productsearchbar){
        if ([searchText isEqualToString:@""]) {
            filteredproductarray=[[NSMutableArray alloc]initWithArray:allproductarray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.chinesename contains[c] %@ or self.englishname contains[c] %@ or self.remarks contains[c] %@ or self.code contains[c] %@ or self.category contains[c] %@",searchText,searchText,searchText,searchText,searchText];
            filteredproductarray=[[NSMutableArray alloc]initWithArray:[allproductarray filteredArrayUsingPredicate:predicate]];
        }
        [ProductTable reloadData];
        [ProductTable setContentOffset:CGPointZero animated:YES];
    }
}

@end
