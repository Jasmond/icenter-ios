//
//  PointViewController.m
//  ischoolicenter
//
//  Created by Jasmond Luk on 14/7/2023.
//  Copyright © 2023 DreamHigh Company Limited. All rights reserved.
//

#import "PointViewController.h"
#import "MyTableViewCell.h"

@interface PointViewController ()

@end

@implementation PointViewController
@synthesize studentkey;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
//    UIBarButtonItem* donebutton= [[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Issue Point"] style:UIBarButtonItemStylePlain target:self action:@selector(issuePointButtonPressed:)];
//    self.navigationItem.rightBarButtonItem=donebutton;
    issueButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).issuepoint;
    
//    UIBarButtonItem* cancelbutton= [[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Close"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
//    self.navigationItem.leftBarButtonItem=cancelbutton;
    
    typeSC.tintColor=[UIColor whiteColor];
    [typeSC setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
    [typeSC setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    typeArray=[[NSMutableArray alloc]initWithObjects:@"All",@"Spending",@"Granted",@"Redemption",@"Adjustment", nil];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor systemGroupedBackgroundColor];
    [tablerefresh addTarget:self action:@selector(getStudentPointHistory) forControlEvents:UIControlEventValueChanged];
    [PointHistoryTable addSubview:tablerefresh];
    
    
    [self refreshlanguage];
}

-(void) refreshlanguage
{
    for (int i=0; i<typeArray.count; i++) {
        [typeSC setTitle:[MyClass returntitlewithtitle:[typeArray objectAtIndex:i]] forSegmentAtIndex:i];
    }
    searchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    
    issuedatetitle.text=[MyClass returntitlewithtitle:@"Issue Date"];
    typetitle.text=[MyClass returntitlewithtitle:@"Type"];
    detailstitle.text=[MyClass returntitlewithtitle:@"Details"];
    pointtitle.text=[MyClass returntitlewithtitle:@"Point"];
    unusedpointtitle.text=[MyClass returntitlewithtitle:@"Unused Point"];
    expirydatetitle.text=[MyClass returntitlewithtitle:@"Expiry Date"];
    remarkstitle.text=[MyClass returntitlewithtitle:@"Remarks"];
    
    [closeButton setTitle:[MyClass returntitlewithtitle:@"Close"] forState:UIControlStateNormal];
 }

-(IBAction) cancelButtonPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate dismissPointViewWithReload:NO];
}

-(IBAction) issuePointButtonPressed:(id)sender{
    [self.delegate issuePointToStudents:[[NSMutableArray alloc]initWithObjects:studentkey, nil] multipleStudents:NO];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getStudentPointHistory];
    });
    
}

-(void) getStudentPointHistory
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievestudentpointandreward&studentkey=%@&language=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,studentkey,[MyClass returnlanguagecode]];
    
    __block BOOL result=FALSE;
    __block NSDictionary *jsonreturned;

    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
        }
    }];
    
    if(result){
        NSMutableArray *JSON_pointrecords = jsonreturned[@"content"][@"pointrecords"];
        pointbalance=jsonreturned[@"content"][@"pointbalance"];
        expirypointdict=jsonreturned[@"content"][@"expirypoint"];
        
        PointRecordArray=[[NSMutableArray alloc]init];
        for (int i=0; i<JSON_pointrecords.count; i++) {
            
            //Create our ClassRecord object
            NSString * pointkey=[[JSON_pointrecords objectAtIndex:i] objectForKey:@"pointkey"];
            NSString * issuedatetime=[[JSON_pointrecords objectAtIndex:i] objectForKey:@"issuedatetime"];
            NSString * type=[[JSON_pointrecords objectAtIndex:i] objectForKey:@"type"];
            NSString * subtype=[[JSON_pointrecords objectAtIndex:i] objectForKey:@"subtype"];
            NSString * point=[[JSON_pointrecords objectAtIndex:i] objectForKey:@"point"];
            NSString * unusedpoint=[[JSON_pointrecords objectAtIndex:i] objectForKey:@"unusedpoint"];
            NSString * expirydate=[[JSON_pointrecords objectAtIndex:i] objectForKey:@"expirydate"];
            NSString * remarks=[[JSON_pointrecords objectAtIndex:i] objectForKey:@"remarks"];
            
            [PointRecordArray addObject:[[PointRecord alloc]initPointRecordWithpointkey:pointkey issuedatetime:issuedatetime type:type subtype:subtype point:point expirydate:expirydate remarks:remarks unusedpoint:unusedpoint]];
        }
        [self returnFilteredArray];
    }
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    for (id object in [PointHistoryTable subviews]) {
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
    
    if (typeSC.selectedSegmentIndex!=0) {
        if(typeSC.selectedSegmentIndex==1){
            newCondition = [NSPredicate predicateWithFormat:@"self.type = %@ or self.type=%@", @"Sales purchase",@"Course enrollment"];
        }else if(typeSC.selectedSegmentIndex==2){
            newCondition = [NSPredicate predicateWithFormat:@"self.type = %@", @"Granted by center"];
        }else if(typeSC.selectedSegmentIndex==3){
            newCondition = [NSPredicate predicateWithFormat:@"self.type = %@", @"Reward redeemed"];
        }else if(typeSC.selectedSegmentIndex==4){
            newCondition = [NSPredicate predicateWithFormat:@"self.type = %@", @"Adjustment"];
        }
        
        [nsPredicatearray addObject:newCondition];
    }


    
    if (![searchbar.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithBlock:^BOOL(PointRecord *object, NSDictionary *bindings) {
            return [object.pointkey rangeOfString:searchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.type rangeOfString:searchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.subtype rangeOfString:searchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.point rangeOfString:searchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.expirydate rangeOfString:searchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.remarks rangeOfString:searchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound;
        }];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredPointRecordArray= [[NSMutableArray alloc]initWithArray:[PointRecordArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredPointRecordArray= [[NSMutableArray alloc]initWithArray:PointRecordArray];
    }
    
    [PointHistoryTable reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return filteredPointRecordArray.count;
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

    static NSString *CellIdentifier = @"pointCell";
    cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cellView == nil) {
        cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    PointRecord *obj = [filteredPointRecordArray objectAtIndex:indexPath.row];
    
    cellView.imageview1.hidden=YES;
    cellView.imageview2.hidden=YES;
    cellView.imageview3.hidden=YES;
    cellView.imageview4.hidden=YES;
    if([obj.type isEqualToString:@"Reward redeemed"]){
        //redeem
        cellView.imageview1.hidden=NO;
    }else if ([obj.type isEqualToString:@"Course enrollment"] || [obj.type isEqualToString:@"Sales purchase"]){
        //spending
        cellView.imageview2.hidden=NO;
    }else if ([obj.type isEqualToString:@"Granted by center"] && [obj.point floatValue]>0){
        //grant
        cellView.imageview4.hidden=NO;
    }else{
        //adjust
        cellView.imageview3.hidden=NO;
    }
    
    cellView.label1.text = [MyClass convertDateFormatWithDate:obj.issuedatetime FromDateFormat:@"yyyy-MM-dd HH:mm:ss" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
    cellView.label2.text = [MyClass convertDateFormatWithDate:obj.issuedatetime FromDateFormat:@"yyyy-MM-dd HH:mm:ss" ToDateFormat:@"HH:mm:ss" Translate:YES];
    cellView.label3.text = [obj.type isEqualToString:@"Course enrollment"]?[MyClass returntitlewithtitle:@"point_Course enrollment"]:[MyClass returntitlewithtitle:obj.type];
    cellView.label4.text = obj.subtype;
    cellView.label5.text = obj.point;
    cellView.label6.text = obj.unusedpoint;
    cellView.label7.text = [obj.expirydate isEqualToString:@"Never expire"]?[MyClass returntitlewithtitle:obj.expirydate]:[MyClass convertDateFormatWithDate:obj.expirydate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
    cellView.label8.text=obj.remarks;
    
    return cellView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PointRecord *obj=[filteredPointRecordArray objectAtIndex:indexPath.row];
    [self.delegate editStudentPoint:obj];
    
}

-(void) reloadPointHistoryTable
{
    [PointHistoryTable reloadData];
    
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self returnFilteredArray];
}

- (IBAction)typeupdated:(id)sender {
    [self returnFilteredArray];
}
@end
