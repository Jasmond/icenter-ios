//
//  TimeTableFilterViewController.m
//  iCenter
//
//  Created by Jasmond Luk on 16/2/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import "TimeTableFilterViewController.h"
#import "MyTableViewCell.h"

@interface TimeTableFilterViewController ()

@end

#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]

@implementation TimeTableFilterViewController
@synthesize selectedItems,headertype;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalvariables=[GlobalVariables singleObj];
    
    [selectallbutton setTitle:[MyClass returntitlewithtitle:@"Select all"] forState:UIControlStateNormal];
    [deselectallbutton setTitle:[MyClass returntitlewithtitle:@"Deselect all"] forState:UIControlStateNormal];
    [updatebutton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    title_showinactiveitems.text=[MyClass returntitlewithtitle:@"Show inactive items"];
    swShowInactiveItems.on=FALSE;
    
    swShowInactiveItems.onTintColor=themecolor;
    
    subjectArray=[MyClass returnsortedsubjectlistwithsubjectrecordarray:[MyClass retrievesubjectinformationwithstatus:@"All" category:@"All" flushcachedata:NO]];
    classroomArray=[MyClass retrieveClassroomListwithstatus:@"All" withTBD:YES flushcachedata:NO];
    instructorArray=[MyClass returnsortedstafflistarraywithstafflistarray:[MyClass retrieveInstructorListwithvalid:@"All" addTBD:YES flushcachedata:NO]];
    selectedSubjects=[selectedItems valueForKey:@"subject"]?[[NSMutableArray alloc]initWithArray:[selectedItems valueForKey:@"subject"]]:nil;
    selectedClassrooms=[selectedItems valueForKey:@"classroom"]?[[NSMutableArray alloc]initWithArray:[selectedItems valueForKey:@"classroom"]]:nil;
    selectedInstructors=[selectedItems valueForKey:@"instructor"]?[[NSMutableArray alloc]initWithArray:[selectedItems valueForKey:@"instructor"]]:nil;
    typeSC.selectedSegmentIndex=0;
    
    filteredItemArray=[[NSMutableArray alloc]initWithArray:subjectArray];
    [self returnFilteredItemArray];
    
    [itemtable reloadData];
    [self updateTypeSCTitle];
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}

-(void) updateTypeSCTitle
{
    [typeSC setTitle:[NSString stringWithFormat:@"%@(%@)",[MyClass returntitlewithtitle:@"Subject"],selectedSubjects?[NSString stringWithFormat:@"%lu", (unsigned long)selectedSubjects.count]:[MyClass returntitlewithtitle:@"All"]] forSegmentAtIndex:0];
    [typeSC setTitle:[NSString stringWithFormat:@"%@(%@)",[MyClass returntitlewithtitle:@"Instructor"],selectedInstructors?[NSString stringWithFormat:@"%lu", (unsigned long)selectedInstructors.count]:[MyClass returntitlewithtitle:@"All"]] forSegmentAtIndex:1];
    [typeSC setTitle:[NSString stringWithFormat:@"%@(%@)",[MyClass returntitlewithtitle:@"Classroom"],selectedClassrooms?[NSString stringWithFormat:@"%lu", (unsigned long)selectedClassrooms.count]:[MyClass returntitlewithtitle:@"All"]] forSegmentAtIndex:2];
    
}

-(void) returnFilteredItemArray
{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    
    if (!swShowInactiveItems.on) {
        if (typeSC.selectedSegmentIndex==1) {
            newCondition = [NSPredicate predicateWithFormat:@"SELF.valid==%@",@"Yes"];
        }else if (typeSC.selectedSegmentIndex==2){
            newCondition = [NSPredicate predicateWithFormat:@"SELF.status==%@",@"In Service"];
        }else if (typeSC.selectedSegmentIndex==0){
            newCondition = [NSPredicate predicateWithFormat:@"SELF.status==%@",@"Active"];
        }
        [nsPredicatearray addObject:newCondition];
    }
    
    NSMutableArray *itemArray;
    if (typeSC.selectedSegmentIndex==1) {
        itemArray=instructorArray;
    }else if (typeSC.selectedSegmentIndex==2){
        itemArray=classroomArray;
    }else if (typeSC.selectedSegmentIndex==0){
        itemArray=subjectArray;
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredItemArray= [[NSMutableArray alloc]initWithArray:[itemArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredItemArray= [[NSMutableArray alloc]initWithArray:itemArray];
    }
    
}

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
    return filteredItemArray.count;
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
    
    if (typeSC.selectedSegmentIndex==1) {
        Instructor *object=[filteredItemArray objectAtIndex:indexPath.row];
        cell.label1.text=[MyClass returninstructornamewithusername:object.username firstorfullname:@"full"];
        cell.label2.hidden=NO;
        cell.label2.text=object.username;
        cell.imageview1.layer.opacity=!selectedInstructors || [selectedInstructors containsObject:object.username]?1:0.3;
    }else if (typeSC.selectedSegmentIndex==2){
        ClassroomRecord *object=[filteredItemArray objectAtIndex:indexPath.row];
        cell.label1.text=object.classroom;
        cell.imageview1.layer.opacity=!selectedClassrooms || [selectedClassrooms containsObject:object.classroom]?1:0.3;
        cell.label2.hidden=YES;
    }else if (typeSC.selectedSegmentIndex==0){
        SubjectRecord *object=[filteredItemArray objectAtIndex:indexPath.row];
        cell.label1.text=[MyClass returnsubjectnamewithsubject_shortname:object.subject_shortname centerkey:globalvariables.centerrecord.centerkey];
        cell.imageview1.layer.opacity=!selectedSubjects || [selectedSubjects containsObject:object.subject_shortname]?1:0.3;
        cell.label2.hidden=NO;
        cell.label2.text=object.subject_shortname;
    }
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedItem;
    if (typeSC.selectedSegmentIndex==1) {
        selectedItem=((Instructor *)[filteredItemArray objectAtIndex:indexPath.row]).username;
        if (!selectedInstructors) {
            //remove
            selectedInstructors=[[NSMutableArray alloc]init];
            for (int i=0; i<instructorArray.count; i++) {
                Instructor *obj=[instructorArray objectAtIndex:i];
                if(![obj.username isEqualToString:selectedItem]){
                    [selectedInstructors addObject:obj.username];
                }
            }
        }else{
            if ([selectedInstructors containsObject:selectedItem]) {
                //remove
                [selectedInstructors removeObject:selectedItem];
            }else{
                //add
                [selectedInstructors addObject:selectedItem];
                if(selectedInstructors.count==instructorArray.count){
                    selectedInstructors=nil;
                }
            }
        }
    }else if (typeSC.selectedSegmentIndex==2){
        selectedItem=((ClassroomRecord *)[filteredItemArray objectAtIndex:indexPath.row]).classroom;
        if (!selectedClassrooms) {
            //remove
            selectedClassrooms=[[NSMutableArray alloc]init];
            for (int i=0; i<classroomArray.count; i++) {
                ClassroomRecord *obj=[classroomArray objectAtIndex:i];
                if(![obj.classroom isEqualToString:selectedItem]){
                    [selectedClassrooms addObject:obj.classroom];
                }
            }
        }else{
            if ([selectedClassrooms containsObject:selectedItem]) {
                //remove
                [selectedClassrooms removeObject:selectedItem];
            }else{
                //add
                [selectedClassrooms addObject:selectedItem];
                if(selectedClassrooms.count==classroomArray.count){
                    selectedClassrooms=nil;
                }
            }
        }
    }else if (typeSC.selectedSegmentIndex==0){
        selectedItem=((SubjectRecord *)[filteredItemArray objectAtIndex:indexPath.row]).subject_shortname;
        if (!selectedSubjects) {
            //remove
            selectedSubjects=[[NSMutableArray alloc]init];
            for (int i=0; i<subjectArray.count; i++) {
                SubjectRecord *obj=[subjectArray objectAtIndex:i];
                if(![obj.subject_shortname isEqualToString:selectedItem]){
                    [selectedSubjects addObject:obj.subject_shortname];
                }
            }
        }else{
            if ([selectedSubjects containsObject:selectedItem]) {
                //remove
                [selectedSubjects removeObject:selectedItem];
            }else{
                //add
                [selectedSubjects addObject:selectedItem];
                if(selectedSubjects.count==subjectArray.count){
                    selectedSubjects=nil;
                }
            }
        }
    }
    [self updateTypeSCTitle];
    [itemtable reloadData];
    
}

- (IBAction)updateshowinactiveitems:(UISwitch *)sender {
    [self returnFilteredItemArray];
    
    [itemtable reloadData];
    if (filteredItemArray.count>0) {
        [itemtable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}


- (IBAction)updatebuttonpressed:(id)sender {
    
    NSMutableDictionary *result=[[NSMutableDictionary alloc]init];
    [result setValue:selectedSubjects forKey:@"subject"];
    [result setValue:selectedClassrooms forKey:@"classroom"];
    [result setValue:selectedInstructors forKey:@"instructor"];
    
    [self.delegate returnTimeTableFilterSelectedItems:result];
}

- (IBAction)deselectallbuttonpressed:(id)sender {
    
    if (typeSC.selectedSegmentIndex==1) {
        selectedInstructors=[[NSMutableArray alloc]init];
    }else if (typeSC.selectedSegmentIndex==2){
        selectedClassrooms=[[NSMutableArray alloc]init];
    }else if (typeSC.selectedSegmentIndex==0){
        selectedSubjects=[[NSMutableArray alloc]init];
    }
    [self updateTypeSCTitle];
    [itemtable reloadData];
    
    
}

- (IBAction)selectallbuttonpressed:(id)sender {
    if (typeSC.selectedSegmentIndex==0) {
        selectedSubjects=nil;
    }else if (typeSC.selectedSegmentIndex==2){
        selectedClassrooms=nil;
    }else{
        selectedInstructors=nil;
    }
    [self updateTypeSCTitle];
    [itemtable reloadData];
}


- (IBAction)selectType:(id)sender {
//    searchField.stringValue=@"";
    [self returnFilteredItemArray];
    [itemtable reloadData];
}

@end
