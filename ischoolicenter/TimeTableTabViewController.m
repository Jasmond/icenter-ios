//
//  TimeTableTabViewController.m
//  
//
//  Created by Jasmond Luk on 17/9/2020.
//

#import "TimeTableTabViewController.h"
#import "MyTableViewCell.h"

@interface TimeTableTabViewController ()

@end

#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]

@implementation TimeTableTabViewController
@synthesize headerArray,headertype,TimeTableMode,buttontag,selectedHeaderArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    
    self.preferredContentSize=CGSizeMake(400, 600);
    [selectallbutton setTitle:[MyClass returntitlewithtitle:@"Select all"] forState:UIControlStateNormal];
    [deselectallbutton setTitle:[MyClass returntitlewithtitle:@"Deselect all"] forState:UIControlStateNormal];
    [updatebutton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    title_showinactiveitems.text=[MyClass returntitlewithtitle:@"Show inactive items"];
    swShowInactiveItems.on=FALSE;
    
    swShowInactiveItems.onTintColor=themecolor;
    
    if (buttontag==99) {
        deselectallbutton.hidden=NO;
        selectallbutton.enabled=YES;
        deselectallbutton.enabled=NO;
    }else{
        if (![TimeTableMode isEqualToString:@"PopoverWeekly"] && ![TimeTableMode isEqualToString:@"PopoverConsolidated"]) {
            deselectallbutton.hidden=NO;
            deselectallbutton.enabled=YES;
        }else{
            deselectallbutton.hidden=YES;
        }

        selectallbutton.enabled=YES;
    }
    
    filteredHeaderArray=[[ NSMutableArray alloc]initWithArray:headerArray];
    t_selectedHeaderArray=[[NSMutableArray alloc]initWithArray:selectedHeaderArray];
    
    [self sortFilteredHeaderArray];
    [self updateshowinactiveitems:swShowInactiveItems];
    
    
    [itemtable reloadData];
}

-(void) sortFilteredHeaderArray
{
    NSArray *sortDescriptors=[[NSArray alloc]init];
    if ([headertype isEqualToString:@"Subject"]) {
        if ([globalvariables.language isEqualToString:@"English"]) {
            NSSortDescriptor *sortbyname = [NSSortDescriptor sortDescriptorWithKey:@"subject_englishname" ascending:YES selector:@selector(localizedStandardCompare:)];
            sortDescriptors = @[sortbyname];
        }else{
            NSSortDescriptor *sortbyname = [NSSortDescriptor sortDescriptorWithKey:@"subject_chinesename" ascending:YES selector:@selector(localizedStandardCompare:)];
            sortDescriptors = @[sortbyname];
        }
    }else if ([headertype isEqualToString:@"Classroom"]){
        NSSortDescriptor *sortbyname = [NSSortDescriptor sortDescriptorWithKey:@"classroom" ascending:YES selector:@selector(localizedStandardCompare:)];
        sortDescriptors = @[sortbyname];
    }else{
        NSSortDescriptor *sortbyfirstname = [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSSortDescriptor *sortbylastname = [NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES selector:@selector(localizedStandardCompare:)];
        sortDescriptors = @[sortbyfirstname,sortbylastname];
    }
        
    filteredHeaderArray = [NSMutableArray arrayWithArray:[filteredHeaderArray sortedArrayUsingDescriptors:sortDescriptors]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return filteredHeaderArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *blankcell = @"itemcell";
    MyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:blankcell];
    
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blankcell];
    }
    
    if ([headertype isEqualToString:@"Subject"]) {
        cell.label2.hidden=NO;
        
        SubjectRecord *subjectobj=[filteredHeaderArray objectAtIndex:indexPath.row];
        
        cell.label1.text=[MyClass returnsubjectnamewithsubject_shortname:subjectobj.subject_shortname centerkey:globalvariables.centerrecord.centerkey];
        cell.label2.text=subjectobj.subject_shortname;
        
        if (![t_selectedHeaderArray containsObject:subjectobj.subject_shortname]) {
            cell.imageview1.layer.opacity=0.3;
        }else{
            cell.imageview1.layer.opacity=1;
        }
    }else if ([headertype isEqualToString:@"Classroom"]){
        cell.label2.hidden=YES;
        
        ClassroomRecord *classroomobj=[filteredHeaderArray objectAtIndex:indexPath.row];
        
        cell.label1.text=classroomobj.classroom;
        
        if (![t_selectedHeaderArray containsObject:classroomobj.classroom]) {
            cell.imageview1.layer.opacity=0.3;
        }else{
            cell.imageview1.layer.opacity=1;
        }
    }else if ([headertype isEqualToString:@"Instructor"]){
        cell.label2.hidden=NO;
        
        Staff *staffobj=[filteredHeaderArray objectAtIndex:indexPath.row];
        
        cell.label1.text=[MyClass returnstaffnamewithusername:staffobj.username firstorfullname:@"full"];
        cell.label2.text=staffobj.username;
        
        if (![t_selectedHeaderArray containsObject:staffobj.username]) {
            cell.imageview1.layer.opacity=0.3;
        }else{
            cell.imageview1.layer.opacity=1;
        }
    }
    
    return cell;
    
}

- (IBAction)updatebuttonpressed:(id)sender {
    [self.delegate updateClassTimeTableWithSelectedHeaderArray:t_selectedHeaderArray];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)updateshowinactiveitems:(UISwitch *)sender {
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (!sender.on) {
        if ([headertype isEqualToString:@"Subject"]) {
            newCondition = [NSPredicate predicateWithFormat:@"SELF.status = %@",@"Active"];
        }else if ([headertype isEqualToString:@"Classroom"]){
            newCondition = [NSPredicate predicateWithFormat:@"SELF.status = %@",@"In Service"];
        }else{
            newCondition = [NSPredicate predicateWithFormat:@"SELF.status = %@",@"Yes"];
        }
        
        [nsPredicatearray addObject:newCondition];
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredHeaderArray= [[NSMutableArray alloc]initWithArray:[headerArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredHeaderArray=[[ NSMutableArray alloc]initWithArray:headerArray];
    }
    [self sortFilteredHeaderArray];
    
    [itemtable reloadData];
}

- (IBAction)deselectallbuttonpressed:(id)sender {
    
    [t_selectedHeaderArray removeAllObjects];
    [itemtable reloadData];
    deselectallbutton.enabled=NO;
    selectallbutton.enabled=YES;
    
}

- (IBAction)selectallbuttonpressed:(id)sender {
    
    [t_selectedHeaderArray removeAllObjects];
    NSString *item;
    for (int i=0; i<headerArray.count; i++) {
        if ([headertype isEqualToString:@"Subject"]) {
            item=((SubjectRecord *)[headerArray objectAtIndex:i]).subject_shortname;
        }else if ([headertype isEqualToString:@"Classroom"]){
            item=((ClassroomRecord *)[headerArray objectAtIndex:i]).classroom;
        }else{
            item=((Staff *)[headerArray objectAtIndex:i]).username;
        }
        
        [t_selectedHeaderArray addObject:item];
    }
    
    if ([headertype isEqualToString:@"Instructor"]) {
        t_selectedHeaderArray=[MyClass returnsortedstaffusernamewithstaffusernamearray:t_selectedHeaderArray];
    }else{
        NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES selector:@selector(localizedStandardCompare:)];
        t_selectedHeaderArray=[NSMutableArray arrayWithArray:[t_selectedHeaderArray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
    }
    deselectallbutton.enabled=YES;
    selectallbutton.enabled=NO;
    
    [itemtable reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selecteditem;
    if ([headertype isEqualToString:@"Subject"]) {
        selecteditem=((SubjectRecord *)[filteredHeaderArray objectAtIndex:indexPath.row]).subject_shortname;
    }else if ([headertype isEqualToString:@"Classroom"]){
        selecteditem=((ClassroomRecord *)[filteredHeaderArray objectAtIndex:indexPath.row]).classroom;
    }else{
        selecteditem=((Staff *)[filteredHeaderArray objectAtIndex:indexPath.row]).username;
    }
    
    if ([t_selectedHeaderArray containsObject:selecteditem]) {
        [t_selectedHeaderArray removeObject:selecteditem];
        
        if (t_selectedHeaderArray.count==0) {
            deselectallbutton.enabled=NO;
        }
        
        if (t_selectedHeaderArray.count<headerArray.count) {
            selectallbutton.enabled=YES;
        }
    }else{
        [t_selectedHeaderArray addObject:selecteditem];
        
        if ([headertype isEqualToString:@"Instructor"]) {
            t_selectedHeaderArray=[MyClass returnsortedstaffusernamewithstaffusernamearray:t_selectedHeaderArray];
        }else{
            NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES selector:@selector(localizedStandardCompare:)];
            t_selectedHeaderArray=[NSMutableArray arrayWithArray:[t_selectedHeaderArray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
        }
        

        deselectallbutton.enabled=YES;
            if (selectedHeaderArray.count==filteredHeaderArray.count) {
                selectallbutton.enabled=NO;
            }
    }
    
    /*
    if ([TimeTableMode isEqualToString:@"PopoverWeekly"] || [TimeTableMode isEqualToString:@"PopoverConsolidated"]){
        filteredHeaderArray=[[NSMutableArray alloc]initWithArray:selectedHeaderArray copyItems:YES];
    }*/
    
    [itemtable reloadData];
    
}


@end
