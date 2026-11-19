//
//  AssessmentPrintView.m
//  iCenter
//
//  Created by Jasmond Luk on 3/8/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import "AssessmentPrintView.h"
#import "MyTableViewCell.h"
#import "AssessReportTableViewCell.h"
#import "AssessReportShortAnswerTableViewCell.h"
#import "afCheckBoxTextCViewCell.h"
#import "afMultipleChoiceCViewCell.h"
#import "afTextMCCViewCell.h"

#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]

@implementation AssessmentPrintView
@synthesize view;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame assessmentformarray:(NSMutableArray *)_assessmentformarray classrecord:(nonnull ClassScheduleRecord *)_classrecord assessmentformobject:(AssessmentFormListObject *)assessmentformobject tableheight:(CGFloat)_tableheight
{
    NSString* nibName = NSStringFromClass([self class]);
    self = [super initWithFrame:frame];
    if (self) {
        if ([[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]) {
            
            globalvariables=[GlobalVariables singleObj];
            assessmentColorArray=[[NSArray alloc]initWithObjects:[UIColor blackColor],[UIColor blueColor],[UIColor systemPinkColor],[UIColor orangeColor],themecolor,[UIColor purpleColor],[UIColor systemGreenColor], [UIColor brownColor], [UIColor systemRedColor], nil];
            
            assessmentformarray=[self returnFilteredAssessmentFormArray:_assessmentformarray];
            
            [MyClass downloadImageWithImageview:logo gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.printlogoimage image:@"Yes" async:NO];

            UINib *nib = [UINib nibWithNibName:@"AssessReportTableViewCell" bundle:nil];
            [reportTable registerNib:nib forCellReuseIdentifier:@"Cell"];
            
            UINib *nibshortanswer = [UINib nibWithNibName:@"AssessReportShortAnswerTableViewCell" bundle:nil];
            [reportTable registerNib:nibshortanswer forCellReuseIdentifier:@"shortAnswerCell"];
            
            formLabel.text=assessmentformobject.formname;
            studentLabel.text=[MyClass returnStudentnameWithStudentkey:_classrecord.studentkey option:@"All"];
            dobLabel.text=((Student *)[MyClass returnstudentwithstudentkey:_classrecord.studentkey]).dateofbirth;
//            dateLabel.text=_classrecord.startdate;
            
            instructorLabel.text=[MyClass returnstaffnamewithusername:_classrecord.instructor firstorfullname:@"full"];
            dateLabel.text=[[MyClass returndateformatYYYYMMDDHHMMSSwithdate:assessmentformobject.lastsubmittedtime] substringToIndex:10];
            
            [reportTable reloadData];
            [reportTable layoutIfNeeded];

            CGFloat rowheight=0;
            for (int i=0; i<assessmentformarray.count; i++) {
                for (int j=0; j<[((AssessmentFormSectionObject *)assessmentformarray[i]).questionarray count]; j++) {
                    [self tableView: reportTable cellForRowAtIndexPath: [NSIndexPath indexPathForRow:j inSection:i]];
                    CGRect rect=[reportTable rectForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                    rowheight+=rect.size.height;
                }
            }

            reportTableHeight.constant=rowheight+30*(assessmentformarray.count+1)+20;
            [self.view layoutIfNeeded];
            self.frame=viewstack.bounds;
            [self addSubview:self.view];
        }
    }
    return self;
    
    
}

-(NSMutableArray *) returnFilteredAssessmentFormArray:(NSMutableArray *)assessmentformarray
{
    return assessmentformarray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return assessmentformarray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [((AssessmentFormSectionObject *)assessmentformarray[section]).questionarray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [MyClass returntitlewithtitle:((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:section]).title];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([tableView numberOfSections]-1==section) {
        return 30;
    }else{
        return CGFLOAT_MIN;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:indexPath.section]).questionarray objectAtIndex:indexPath.row];
    
    if ([assessmentformrowobject.questiontype isEqualToString:@"shortanswer2"]) {
        AssessReportShortAnswerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"shortAnswerCell"];

        cell.label1.text=assessmentformrowobject.title;
        
        cell.gctextview1.textContainer.lineFragmentPadding=0;
        cell.gctextview1.textContainerInset=UIEdgeInsetsMake(0, 5, 0, 5);
        cell.gctextview1.placeholder=@"";
        NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"RMK" disabled:NO];
        if(index>=0){
            NSRange range=[assessmentformrowobject.responsearray[index] rangeOfString:@"RMK|"];
            if(range.location!=NSNotFound){
                cell.gctextview1.text=[assessmentformrowobject.responsearray[index] substringFromIndex:range.location+range.length];
            }else{
                cell.gctextview1.text=@"";
                cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            }
        }else{
            cell.gctextview1.text=@"";
            cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
        }
        cell.gctextview1.tag=100;
        cell.button1.tag=0;
        
        cell.button1.hidden=NO;
        [cell.button1 setTitleColor:assessmentColorArray[0] forState:UIControlStateNormal];
        [cell.button1 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[0]] forState:UIControlStateNormal];
        cell.button1.hidden=[cell.button1.titleLabel.text isEqualToString:[MyClass returntitlewithtitle:@"Score"]];
        cell.gctextview2.textContainer.lineFragmentPadding=0;
        cell.gctextview2.textContainerInset=UIEdgeInsetsMake(0, 5, 0, 5);
        cell.gctextview2.text=[self returnshortanswer2text:assessmentformrowobject.responsearray[0]];
        cell.gctextview2.textColor=[UIColor blackColor];
        if([cell.gctextview2.text isEqualToString:@""]){
            cell.gctextview2.placeholderColor=[UIColor lightGrayColor];
        }
        cell.gctextview2.tag=200;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([assessmentformrowobject.questiontype isEqualToString:@"multiplechoice2"]) {
        AssessReportTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        cell.button1.hidden=YES;
        cell.button2.hidden=YES;
        cell.button3.hidden=YES;
        cell.button4.hidden=YES;
        cell.button5.hidden=YES;
        cell.button6.hidden=YES;
        cell.button7.hidden=YES;
        cell.button8.hidden=YES;
        cell.button9.hidden=YES;
        
        cell.collectionview1.tag=indexPath.section*1000+indexPath.row;
        cell.collectionview1.delegate=self;
        cell.collectionview1.dataSource=self;
        cell.label1.text=assessmentformrowobject.title;

        UINib *cellNib;
        [cell.collectionview1 registerClass:[afMultipleChoiceCViewCell class] forCellWithReuseIdentifier:@"afMultipleChoiceCViewCell"];
        cellNib = [UINib nibWithNibName:@"afMultipleChoiceCViewCell" bundle:nil];
        [cell.collectionview1 registerNib:cellNib forCellWithReuseIdentifier:@"afMultipleChoiceCViewCell"];
        [cell.collectionview1 reloadData];
        cell.collectionviewheightconstraint.constant=cell.collectionview1.collectionViewLayout.collectionViewContentSize.height;
        
        
        cell.gctextview1.textContainer.lineFragmentPadding=0;
        cell.gctextview1.textContainerInset=UIEdgeInsetsMake(0, 5, 0, 5);
        cell.gctextview1.placeholder=@"";
        NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"RMK" disabled:NO];
        if(index>=0){
            NSRange range=[assessmentformrowobject.responsearray[index] rangeOfString:@"RMK|"];
            if(range.location!=NSNotFound){
                cell.gctextview1.text=[assessmentformrowobject.responsearray[index] substringFromIndex:range.location+range.length];
            }else{
                cell.gctextview1.text=@"";
                cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            }
        }else{
            cell.gctextview1.text=@"";
            cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
        }
        cell.gctextview1.tag=100;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([assessmentformrowobject.questiontype isEqualToString:@"textmultiplechoiceremarks"] || [assessmentformrowobject.questiontype isEqualToString:@"textremarks"]) {
        AssessReportTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        cell.collectionview1.tag=indexPath.section*1000+indexPath.row;
        cell.collectionview1.delegate=self;
        cell.collectionview1.dataSource=self;
        cell.label1.text=assessmentformrowobject.title;

        UINib *cellNib;
        [cell.collectionview1 registerClass:[afTextMCCViewCell class] forCellWithReuseIdentifier:@"afTextMCCViewCell"];
        cellNib = [UINib nibWithNibName:@"afTextMCCViewCell" bundle:nil];
        [cell.collectionview1 registerNib:cellNib forCellWithReuseIdentifier:@"afTextMCCViewCell"];
        [cell.collectionview1 reloadData];
        cell.collectionviewheightconstraint.constant=cell.collectionview1.collectionViewLayout.collectionViewContentSize.height;
        
        cell.button1.hidden=YES;
        cell.button2.hidden=YES;
        cell.button3.hidden=YES;
        cell.button4.hidden=YES;
        cell.button5.hidden=YES;
        cell.button6.hidden=YES;
        cell.button7.hidden=YES;
        cell.button8.hidden=YES;
        cell.button9.hidden=YES;

        cell.gctextview1.textContainer.lineFragmentPadding=0;
        cell.gctextview1.textContainerInset=UIEdgeInsetsMake(0, 5, 0, 5);
//        cell.gctextview1.placeholder=[MyClass returntitlewithtitle:@"Remarks"];
        cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
        NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"RMK" disabled:NO];
        if(index>=0){
            NSRange range=[assessmentformrowobject.responsearray[index] rangeOfString:@"RMK|"];
            if(range.location!=NSNotFound){
                cell.gctextview1.text=[assessmentformrowobject.responsearray[index] substringFromIndex:range.location+range.length];
            }else{
                cell.gctextview1.text=@"";
                cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            }
        }else{
            cell.gctextview1.text=@"";
            cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
        }
        cell.gctextview1.tag=100;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        AssessReportTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];

        cell.collectionview1.tag=indexPath.section*1000+indexPath.row;
        cell.collectionview1.delegate=self;
        cell.collectionview1.dataSource=self;
        cell.label1.text=assessmentformrowobject.title;

        UINib *cellNib;
        [cell.collectionview1 registerClass:[afCheckBoxTextCViewCell class] forCellWithReuseIdentifier:@"afCheckBoxTextCViewCell"];
        cellNib = [UINib nibWithNibName:@"afCheckBoxTextCViewCell" bundle:nil];
        [cell.collectionview1 registerNib:cellNib forCellWithReuseIdentifier:@"afCheckBoxTextCViewCell"];
        [cell.collectionview1 reloadData];
        cell.collectionviewheightconstraint.constant=cell.collectionview1.collectionViewLayout.collectionViewContentSize.height;
        
        cell.button1.tag=0;
        
        cell.button1.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[0] disabled:NO]<0 || [assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"];
        [cell.button1 setTitleColor:assessmentColorArray[0] forState:UIControlStateNormal];
        [cell.button1 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[0]] forState:UIControlStateNormal];
        
        if (assessmentformrowobject.valuearray.count>1) {
            cell.button2.tag=1;
            cell.button2.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[1] disabled:NO]<0|| [assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"];
            [cell.button2 setTitleColor:assessmentColorArray[1] forState:UIControlStateNormal];
            [cell.button2 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[1]] forState:UIControlStateNormal];
        }else{
            cell.button2.hidden=YES;
        }
        
        if (assessmentformrowobject.valuearray.count>2) {
            cell.button3.tag=2;
            cell.button3.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[2] disabled:NO]<0|| [assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"];
            [cell.button3 setTitleColor:assessmentColorArray[2] forState:UIControlStateNormal];
            [cell.button3 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[2]] forState:UIControlStateNormal];
        }else{
            cell.button3.hidden=YES;
        }
        
        if (assessmentformrowobject.valuearray.count>3) {
            cell.button4.tag=3;
            cell.button4.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[3] disabled:NO]<0|| [assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"];
            [cell.button4 setTitleColor:assessmentColorArray[3] forState:UIControlStateNormal];
            [cell.button4 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[3]] forState:UIControlStateNormal];
        }else{
            cell.button4.hidden=YES;
        }
        
        if (assessmentformrowobject.valuearray.count>4) {
            cell.button5.tag=4;
            cell.button5.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[4] disabled:NO]<0|| [assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"];
            [cell.button5 setTitleColor:assessmentColorArray[4] forState:UIControlStateNormal];
            [cell.button5 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[4]] forState:UIControlStateNormal];
        }else{
            cell.button5.hidden=YES;
        }
        
        if (assessmentformrowobject.valuearray.count>5) {
            cell.button6.tag=5;
            cell.button6.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[5] disabled:NO]<0|| [assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"];
            [cell.button6 setTitleColor:assessmentColorArray[5] forState:UIControlStateNormal];
            [cell.button6 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[5]] forState:UIControlStateNormal];
        }else{
            cell.button6.hidden=YES;
        }
        
        if (assessmentformrowobject.valuearray.count>6) {
            cell.button7.tag=6;
            cell.button7.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[6] disabled:NO]<0|| [assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"];
            [cell.button7 setTitleColor:assessmentColorArray[6] forState:UIControlStateNormal];
            [cell.button7 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[6]] forState:UIControlStateNormal];
        }else{
            cell.button7.hidden=YES;
        }
        
        if (assessmentformrowobject.valuearray.count>7) {
            cell.button8.tag=7;
            cell.button8.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[7] disabled:NO]<0|| [assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"];
            [cell.button8 setTitleColor:assessmentColorArray[7] forState:UIControlStateNormal];
            [cell.button8 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[7]] forState:UIControlStateNormal];
        }else{
            cell.button8.hidden=YES;
        }
        
        if (assessmentformrowobject.valuearray.count>8) {
            cell.button9.tag=8;
            cell.button9.hidden=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:assessmentformrowobject.valuearray[8] disabled:NO]<0|| [assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"];
            [cell.button9 setTitleColor:assessmentColorArray[8] forState:UIControlStateNormal];
            [cell.button9 setTitle:[self returnMarkWithResponseArray:assessmentformrowobject.responsearray  Value:assessmentformrowobject.valuearray[8]] forState:UIControlStateNormal];
        }else{
            cell.button9.hidden=YES;
        }
        
        cell.gctextview1.textContainer.lineFragmentPadding=0;
        cell.gctextview1.textContainerInset=UIEdgeInsetsMake(0, 5, 0, 5);
        cell.gctextview1.placeholder=@"";
        NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"RMK" disabled:NO];
        if(index>=0){
            NSRange range=[assessmentformrowobject.responsearray[index] rangeOfString:@"RMK|"];
            if(range.location!=NSNotFound){
                cell.gctextview1.text=[assessmentformrowobject.responsearray[index] substringFromIndex:range.location+range.length];
            }else{
                cell.gctextview1.text=@"";
                cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
            }
        }else{
            cell.gctextview1.text=@"";
            cell.gctextview1.placeholderColor=[UIColor lightGrayColor];
        }
        cell.gctextview1.tag=100;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

-(NSString *) returnshortanswer2text:(NSString *)value
{
    if ([value isEqualToString:@""]) {
        return @"";
    }else{
        NSRange scorerange=[value rangeOfString:@"|"];
        return [value substringToIndex:scorerange.location];
    }
}

-(NSString *) returnValueFromValue:(NSString *)value questiontype:(NSString *)questiontype
{
    NSRange andrange=[value rangeOfString:@"&&"];
    NSRange percentagerange=[value rangeOfString:@"%%"];
    if (andrange.location!=NSNotFound) {
        if([questiontype isEqualToString:@"textmultiplechoiceremarks"]){
            value=[value substringFromIndex:andrange.location+2];
        }else{
            value=[value substringToIndex:andrange.location];
        }
    }else if (percentagerange.location!=NSNotFound){
        value=[value substringToIndex:percentagerange.location];
    }
    return value;
}

//-(NSInteger) returnResponseArrayindexWithArray:(NSMutableArray *)array Value:(NSString *)value disabled:(BOOL)disabled
//{
//    NSString *newvalue =[self returnValueFromValue:value];
//
//    if(disabled){
//        for (int i=0; i<array.count; i++) {
//            NSRange range=[array[i] rangeOfString:[NSString stringWithFormat:@"<>%@",newvalue]];
//            if(range.location!=NSNotFound){
//                return i;
//            }
//        }
//    }else{
//        for (int i=0; i<array.count; i++) {
//            NSRange range=[array[i] rangeOfString:[NSString stringWithFormat:@"%@%@",newvalue,![value isEqualToString:newvalue]?@"&&":@"|"]];
//            NSRange scorerange=[array[i] rangeOfString:[NSString stringWithFormat:@"%@",@"|"]];
//            if(range.location!=NSNotFound && range.location==0 && scorerange.location!=NSNotFound){
//                return i;
//            }
//        }
//    }
//
//    return -1;
//}

-(NSString *) returnMarkWithResponseArray:(NSMutableArray *)array Value:(NSString *)value
{
    NSRange andrange=[value rangeOfString:@"&&"];
    if (andrange.location!=NSNotFound) {
        value=[value substringToIndex:andrange.location];
    }
    
    for (int i=0; i<array.count; i++) {
        NSRange range=[array[i] rangeOfString:[NSString stringWithFormat:@"%@%@",value,andrange.location!=NSNotFound?@"&&":@"|"]];
        if(range.location!=NSNotFound){
            NSRange range=[array[i] rangeOfString:[NSString stringWithFormat:@"|"]];
            if(range.location!=NSNotFound){
                NSString *mark=[array[i] substringFromIndex:range.location+range.length];
                return [mark isEqualToString:@""]?[MyClass returntitlewithtitle:@"NA"]:mark;
            }
        }
    }
    
    return [MyClass returntitlewithtitle:@"Score"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:collectionView.tag/1000]).questionarray objectAtIndex:collectionView.tag%1000];
    return assessmentformrowobject.valuearray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:collectionView.tag/1000]).questionarray objectAtIndex:collectionView.tag%1000];
    
    if ([assessmentformrowobject.questiontype isEqualToString:@"checkboxtext"] || [assessmentformrowobject.questiontype isEqualToString:@"checkboxtextns"]) {
        __weak afCheckBoxTextCViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"afCheckBoxTextCViewCell" forIndexPath:indexPath];

        cell.checkboxtitlebutton.tag=indexPath.item;
        
        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        NSRange range=[titlestring rangeOfString:@"&&"];
        if(range.location==NSNotFound){
            cell.textstack.hidden=YES;
            cell.checkboxtitle.text=titlestring;
        }else{
            cell.textstack.hidden=NO;
            cell.checkboxtitle.text=[titlestring substringToIndex:range.location];
            cell.texttitle.text=[titlestring substringFromIndex:range.location+2];
        }
        
        if([self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:[assessmentformrowobject.valuearray objectAtIndex:indexPath.item] disabled:YES]>=0){
            cell.checkboxtitle.textColor=[UIColor lightGrayColor];
            cell.checkboxbutton.enabled=NO;
            cell.checkboximage.layer.opacity=0.4;
            [cell.checkboximage setImage:[UIImage imageNamed:@"checkboxbutton_unselect.png"]];
            cell.texttitle.textColor=[UIColor lightGrayColor];
            cell.textfield.text=@"";
            cell.textfield.enabled=NO;
        }else{
            cell.checkboxtitle.textColor=[UIColor blackColor];
            cell.checkboxbutton.enabled=YES;
            cell.checkboximage.layer.opacity=1.0;
            cell.texttitle.textColor=[UIColor blackColor];
            NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:[assessmentformrowobject.valuearray objectAtIndex:indexPath.item] disabled:NO];
            if (index>=0) {
                [cell.checkboximage setImage:[UIImage imageNamed:@"checkboxbutton_selected.png"]];
                cell.checkboxtitle.textColor=[self returnCheckBoxTitleColorWithIndex:indexPath.item];
                NSRange andrange=[assessmentformrowobject.responsearray[index] rangeOfString:@"&&"];
                if (andrange.location!=NSNotFound) {
                    NSRange scorerange=[assessmentformrowobject.responsearray[index] rangeOfString:@"|"];
                    cell.textfield.text=[assessmentformrowobject.responsearray[index] substringFromIndex:andrange.location+2];
                    cell.textfield.text=[cell.textfield.text substringToIndex:scorerange.location-andrange.location-2];
                    cell.textfield.enabled=YES;
                    cell.textfield.tag=indexPath.item;
//                    [cell.textfield addTarget:self action:@selector(updatecheckboxtextexample:) forControlEvents:UIControlEventEditingChanged];
                }
            }else{
                [cell.checkboximage setImage:[UIImage imageNamed:@"checkboxbutton_unselect.png"]];
                cell.checkboxtitle.textColor=[UIColor blackColor];
                cell.textfield.text=@"";
                cell.textfield.enabled=NO;
            }
        }
        
        return cell;
    }else if ([assessmentformrowobject.questiontype isEqualToString:@"multiplechoice2"]){
        __weak afMultipleChoiceCViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"afMultipleChoiceCViewCell" forIndexPath:indexPath];
        
        
//        [cell.multiplechoicebutton addTarget:self action:@selector(multiplechoicebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.multiplechoicebutton.tag=indexPath.item;
        

        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        cell.multiplechoicetitle.text=titlestring;
        
//        NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:[assessmentformrowobject.valuearray objectAtIndex:indexPath.item] disabled:NO];
        if ([assessmentformrowobject.responsearray containsObject:[assessmentformrowobject.valuearray objectAtIndex:indexPath.item]]) {
            [cell.multiplechoiceimage setImage:[UIImage imageNamed:@"multiplechoicebutton_selected.png"]];
        }else{
            [cell.multiplechoiceimage setImage:[UIImage imageNamed:@"multiplechoicebutton_unselect.png"]];
        }
        
        
        return cell;
    }else if ([assessmentformrowobject.questiontype isEqualToString:@"textmultiplechoiceremarks"]) {
        __weak afTextMCCViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"afTextMCCViewCell" forIndexPath:indexPath];
        
        
//        [cell.multiplechoicebutton addTarget:self action:@selector(multiplechoicebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
//        cell.multiplechoicebutton.tag=indexPath.item;
        
        
        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        NSRange range=[titlestring rangeOfString:@"&&"];
        NSRange range2=[titlestring rangeOfString:@"%%"];
        cell.mcstack.hidden=NO;
        if(range.location!=NSNotFound){
            cell.textstack.hidden=NO;
            cell.texttitle.text=[titlestring substringToIndex:range.location];
            cell.multiplechoicetitle.text=[titlestring substringFromIndex:range.location+2];
        }else if(range2.location!=NSNotFound){
            cell.textstack.hidden=YES;
            cell.multiplechoicetitle.text=[titlestring substringToIndex:range2.location];;
        }else{
            cell.textstack.hidden=YES;
            cell.multiplechoicetitle.text=titlestring;
        }

        
        if([self textmultiplechoiceremarkscontainsValue:[assessmentformrowobject.valuearray objectAtIndex:indexPath.item] responsearray:assessmentformrowobject.responsearray]){
            [cell.multiplechoiceimage setImage:[UIImage imageNamed:@"multiplechoicebutton_selected.png"]];
        }else{
            [cell.multiplechoiceimage setImage:[UIImage imageNamed:@"multiplechoicebutton_unselect.png"]];
        }
        
//        [cell.textfield addTarget:self action:@selector(updatemultiplechoicetext:) forControlEvents:UIControlEventEditingChanged];
//        [cell.textfield addTarget:self action:@selector(autosaveassessmentresponse) forControlEvents:UIControlEventEditingDidEnd];
        cell.textfield.enabled=YES;
        cell.textfield.tag=indexPath.item;
        NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"TXT" disabled:NO];
        if (index>=0) {
            NSRange txtrange=[assessmentformrowobject.responsearray[index] rangeOfString:@"TXT|"];
            if (txtrange.location!=NSNotFound) {
                cell.textfield.text=[assessmentformrowobject.responsearray[index] substringFromIndex:txtrange.location+4];
            }
        }else{
            cell.textfield.text=@"";
        }
        
        return cell;
    }else if ([assessmentformrowobject.questiontype isEqualToString:@"textremarks"]) {
        __weak afTextMCCViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"afTextMCCViewCell" forIndexPath:indexPath];
        
        cell.mcstack.hidden=YES;
        
        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        NSRange range2=[titlestring rangeOfString:@"%%"];
        cell.textstack.hidden=NO;
        cell.texttitle.text=[titlestring substringToIndex:range2.location];

        
//        [cell.textfield addTarget:self action:@selector(updatemultiplechoicetext:) forControlEvents:UIControlEventEditingChanged];
//        [cell.textfield addTarget:self action:@selector(autosaveassessmentresponse) forControlEvents:UIControlEventEditingDidEnd];
        cell.textfield.enabled=YES;
        cell.textfield.tag=indexPath.item;
        NSInteger index=[self returnResponseArrayindexWithAssessmentFormRowObject:assessmentformrowobject Value:@"TXT" disabled:NO];
        if (index>=0) {
            NSRange txtrange=[assessmentformrowobject.responsearray[index] rangeOfString:@"TXT|"];
            if (txtrange.location!=NSNotFound) {
                cell.textfield.text=[assessmentformrowobject.responsearray[index] substringFromIndex:txtrange.location+4];
            }
        }else{
            cell.textfield.text=@"";
        }
        
        return cell;
    }
    
    return nil;
    
}

-(NSInteger) returnResponseArrayindexWithAssessmentFormRowObject:(AssessmentFormRowObject *)object Value:(NSString *)value disabled:(BOOL)disabled
{
    NSString *newvalue =[self returnValueFromValue:value questiontype:object.questiontype];
    
    if(disabled){
        for (int i=0; i<object.responsearray.count; i++) {
            NSRange range=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"<>%@",newvalue]];
            if(range.location!=NSNotFound){
                return i;
            }
        }
    }else{
        for (int i=0; i<object.responsearray.count; i++) {
            if([object.questiontype isEqualToString:@"textmultiplechoiceremarks"]){
                NSRange andrange=[value rangeOfString:@"&&"];
                NSRange percentagerange=[value rangeOfString:@"%%"];
                if([value isEqualToString:@"RMK"]){
                    NSRange range=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"RMK|"]];
                    if(range.location!=NSNotFound){
                        return i;
                    }
                }else if([value isEqualToString:@"TXT"]){
                    NSRange range=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"TXT|"]];
                    if(range.location!=NSNotFound){
                        return i;
                    }
                }else if([value isEqualToString:newvalue]){
                    if([object.responsearray[i] isEqualToString:newvalue]){
                        return i;
                    }
                }else if (andrange.location!=NSNotFound){
                    NSRange range=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"&&%@",newvalue]];
                    if(range.location!=NSNotFound){
                        return i;
                    }
                }else if (percentagerange.location!=NSNotFound){
                    NSRange range=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"%@%%",newvalue]];
                    if(range.location!=NSNotFound){
                        return i;
                    }
                }
            }else{
                NSRange range=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"%@%@",newvalue,![value isEqualToString:newvalue]?@"&&":@"|"]];
                NSRange scorerange=[object.responsearray[i] rangeOfString:[NSString stringWithFormat:@"%@",@"|"]];
                if(range.location!=NSNotFound && range.location==0 && scorerange.location!=NSNotFound){
                    return i;
                }
            }
            
        }
    }
    
    return -1;
}

-(BOOL) textmultiplechoiceremarkscontainsValue:(NSString *)value responsearray:(NSMutableArray *)responsearray
{
    for(int i=0;i<responsearray.count;i++){
        NSRange andrange=[value rangeOfString:@"&&"];
        NSRange percentagerange=[value rangeOfString:@"%%"];
        if(andrange.location!=NSNotFound){
            NSRange andrange2=[responsearray[i] rangeOfString:@"&&"];
            if(andrange2.location!=NSNotFound){
                return TRUE;
            }
        }else if(percentagerange.location!=NSNotFound){
            NSRange andrange2=[responsearray[i] rangeOfString:@"%%"];
            if(andrange2.location!=NSNotFound){
                return TRUE;
            }
        }else{
            if([value isEqualToString:responsearray[i]]){
                return TRUE;
            }
        }
        
    }
    return FALSE;
}

-(UIColor *) returnCheckBoxTitleColorWithIndex:(NSInteger)index
{
    return assessmentColorArray[index];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:collectionView.tag/1000]).questionarray objectAtIndex:collectionView.tag%1000];
    
    if([assessmentformrowobject.questiontype isEqualToString:@"textmultiplechoiceremarks"]){
        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        NSRange range1=[titlestring rangeOfString:@"&&"];
        NSRange range2=[titlestring rangeOfString:@"%%"];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 140)];
        label.font=[UIFont systemFontOfSize:14];
        if(range1.location!=NSNotFound){
            label.text=[titlestring substringFromIndex:range1.location+2];
            label.numberOfLines=0;
            [label sizeToFit];
            
            UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 140)];
            label2.font=[UIFont systemFontOfSize:14];
            label2.text=[NSString stringWithFormat:@"%@:",[titlestring substringToIndex:range1.location] ];
            label2.numberOfLines=0;
            [label2 sizeToFit];
            
            CGSize size= CGSizeMake(15+5+label.frame.size.width+20+label2.frame.size.width+6+50+10, 19);
            return size;
        }else if(range2.location!=NSNotFound){
            label.text=[titlestring substringToIndex:range2.location];
            label.numberOfLines=0;
            [label sizeToFit];
            CGSize size= CGSizeMake(15+5+label.frame.size.width+10, 19);
            return size;
        }else{
            label.text=titlestring;
            label.numberOfLines=0;
            [label sizeToFit];
            CGSize size= CGSizeMake(15+5+label.frame.size.width+10, 19);
            return size;
        }
    }else if([assessmentformrowobject.questiontype isEqualToString:@"textremarks"]){
        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        NSRange range1=[titlestring rangeOfString:@"%%"];

        UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 140)];
        label2.font=[UIFont systemFontOfSize:14];
        label2.text=[NSString stringWithFormat:@"%@:",[titlestring substringToIndex:range1.location] ];
        label2.numberOfLines=0;
        [label2 sizeToFit];
        
        CGSize size= CGSizeMake(label2.frame.size.width+6+40+10, 19);
        return size;

    }else{
        NSString *titlestring=[assessmentformrowobject.valuearray objectAtIndex:indexPath.item];
        NSRange range=[titlestring rangeOfString:@"&&"];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 140)];
        label.font=[UIFont systemFontOfSize:14];
        if(range.location==NSNotFound){
            label.text=titlestring;
            label.numberOfLines=0;
            [label sizeToFit];
            CGSize size= CGSizeMake(15+5+label.frame.size.width+10, 19);
            return size;
        }else{
            label.text=[titlestring substringToIndex:range.location];
            label.numberOfLines=0;
            [label sizeToFit];
            
            UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 140)];
            label2.font=[UIFont systemFontOfSize:14];
            label2.text=[NSString stringWithFormat:@"%@:",[titlestring substringFromIndex:range.location+2] ];
            label2.numberOfLines=0;
            [label2 sizeToFit];
            
            CGSize size= CGSizeMake(15+5+label.frame.size.width+20+label2.frame.size.width+6+200+10, 19);
            return size;
        }
    }
    
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}



@end
