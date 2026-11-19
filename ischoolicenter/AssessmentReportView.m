//
//  AssessmentReportView.m
//  ischoolicenter
//
//  Created by Jasmond Luk on 15/12/2023.
//  Copyright © 2023 DreamHigh Company Limited. All rights reserved.
//

#import "AssessmentReportView.h"
#import "AR_DP_Score1_TableViewCell.h"

@implementation AssessmentReportView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame assessmentReportDict:(NSMutableDictionary *)_assessmentreportdict sendAssessmentReport:(BOOL)sendassessmentreport
{
    NSString* nibName = NSStringFromClass([self class]);
    self = [super initWithFrame:frame];
    if (self) {
        if ([[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]) {
            
            globalvariables=[GlobalVariables singleObj];
            UINib *nib = [UINib nibWithNibName:@"AR_DP_Score1_TableViewCell" bundle:nil];
            [reportTable_0 registerNib:nib forCellReuseIdentifier:@"shortAnswerCell"];
            [reportTable_1 registerNib:nib forCellReuseIdentifier:@"shortAnswerCell"];
                        
            averageScoreStack.hidden=![_assessmentreportdict[@"showcenteraveragescore"] isEqualToString:@"Yes"];
            averageScoreSeparator.hidden=averageScoreStack.hidden;
            
            assessmentformarray=_assessmentreportdict[@"assessmentformarray"];
            [MyClass downloadImageWithImageview:logo gender:nil type:@"centerimage" typekey:_assessmentreportdict[@"printlogoimage"] image:@"Yes" async:NO];
            logo.backgroundColor=nil;

            [reportTable_0 reloadData];
            [reportTable_1 reloadData];
            [reportTable_0 layoutIfNeeded];
            [reportTable_1 layoutIfNeeded];

            CGFloat rowheight=10;
            NSInteger scoretotal_0=0;
            NSInteger scoresum_0=0;
            for (int i=0; i<1; i++) {
                for (int j=0; j<((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:0]).questionarray.count; j++) {
                    [self tableView: reportTable_0 cellForRowAtIndexPath: [NSIndexPath indexPathForRow:j inSection:i]];
                    CGRect rect=[reportTable_0 rectForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                    rowheight+=rect.size.height;
                    
                    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:0]).questionarray objectAtIndex:j];
                    NSString *score = assessmentformrowobject.responsearray[0];
                    if (![score isEqualToString:@"NA"] && ![assessmentformrowobject.title isEqualToString:@""]) {
                        scoresum_0+=[score integerValue];
                        scoretotal_0+=10;
                    }
                }
            }
            
            total_0_Label.text=[NSString stringWithFormat:@"%ld / %ld",(long)scoresum_0,(long)scoretotal_0];
            reportTableHeight_0.constant=rowheight;
            
            rowheight=10;
            NSInteger scoretotal_1=0;
            NSInteger scoresum_1=0;
            for (int i=0; i<1; i++) {
                for (int j=0; j<((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:1]).questionarray.count; j++) {
                    [self tableView: reportTable_1 cellForRowAtIndexPath: [NSIndexPath indexPathForRow:j inSection:i]];
                    CGRect rect=[reportTable_1 rectForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
                    rowheight+=rect.size.height;
                    
                    assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:1]).questionarray objectAtIndex:j];
                    NSString *score = assessmentformrowobject.responsearray[0];
                    if (![score isEqualToString:@"NA"] && ![assessmentformrowobject.title isEqualToString:@""]) {
                        scoresum_1+=[score integerValue];
                        scoretotal_1+=10;
                    }
                }
            }

            total_1_Label.text=[NSString stringWithFormat:@"%ld / %ld",(long)scoresum_1,(long)scoretotal_1];
            reportTableHeight_1.constant=rowheight;

            NSInteger total=(scoresum_0+scoresum_1)*100/(scoretotal_0+scoretotal_1);
            totalLabel.text=[NSString stringWithFormat:@"%ld%@",(long)total,@"%"];
            
            subjectLabel.text=_assessmentreportdict[@"subjectname"];
            studentLabel.text=_assessmentreportdict[@"studentname"];
            gradeLabel.text=_assessmentreportdict[@"grade"];
            formLabel.text=_assessmentreportdict[@"formname"];
            periodLabel.text=[NSString stringWithFormat:@"%@ - %@",_assessmentreportdict[@"periodstart"],_assessmentreportdict[@"periodend"]];
            issueDateLabel.text=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
            
            NSArray *chart_element_array=[[NSArray alloc]initWithObjects:chart_element_0, chart_element_1, chart_element_2, chart_element_3, chart_element_4, nil];
            for (int i=0; i<5; i++) {
                assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:0]).questionarray objectAtIndex:i];
                UILabel *label=(UILabel *)[chart_element_array objectAtIndex:i];
                label.text=assessmentformrowobject.title;
            }
            
            chart_element_array=[[NSArray alloc]initWithObjects:chart_element_10, chart_element_11, chart_element_12, chart_element_13, chart_element_14, nil];
            for (int i=0; i<5; i++) {
                assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:1]).questionarray objectAtIndex:i];
                UILabel *label=(UILabel *)[chart_element_array objectAtIndex:i];
                label.text=assessmentformrowobject.title;
            }
            
            
            assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:2]).questionarray objectAtIndex:0];
            
            commentLabel.text=assessmentformrowobject.responsearray[0];
            instructorLabel.text=_assessmentreportdict[@"instructorname"];
            averageScoreLabel.text=[NSString stringWithFormat:@"%@%@",_assessmentreportdict[@"averagescore"],@"%"];
            
            reportTable_headerTitle_0.text = [MyClass returntitlewithtitle:((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:0]).title];
            reportTable_headerTitle_1.text = [MyClass returntitlewithtitle:((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:1]).title];
            
            UIView *_spiderChartView_0=[MyClass drawAssessmentSpiderChart:[assessmentformarray objectAtIndex:0] inview:spiderChartView_0 size:@""];
            [spiderChartView_0 addSubview:_spiderChartView_0];
            
            UIView *_spiderChartView_1=[MyClass drawAssessmentSpiderChart:[assessmentformarray objectAtIndex:1] inview:spiderChartView_0 size:@""];
            [spiderChartView_1 addSubview:_spiderChartView_1];
            
            studentTitle.text=[self returnTranslatedTitle:@"Student" sendAssessmentReport:sendassessmentreport language:_assessmentreportdict[@"documentlanguage"] assessmentReportDict:_assessmentreportdict];
            gradeTitle.text=[self returnTranslatedTitle:@"Grade" sendAssessmentReport:sendassessmentreport language:_assessmentreportdict[@"documentlanguage"] assessmentReportDict:_assessmentreportdict];
            issueDateTitle.text=[self returnTranslatedTitle:@"Issue Date" sendAssessmentReport:sendassessmentreport language:_assessmentreportdict[@"documentlanguage"] assessmentReportDict:_assessmentreportdict];
            evaluationPeriodTitle.text=[self returnTranslatedTitle:@"Evaluation Period" sendAssessmentReport:sendassessmentreport language:_assessmentreportdict[@"documentlanguage"] assessmentReportDict:_assessmentreportdict];
            reportTableTitle_0.text=[self returnTranslatedTitle:@"1 Below Mastery - 10 Exceed Mastery" sendAssessmentReport:sendassessmentreport language:_assessmentreportdict[@"documentlanguage"] assessmentReportDict:_assessmentreportdict];
            reportTableTitle_1.text=[self returnTranslatedTitle:@"1 Below Mastery - 10 Exceed Mastery" sendAssessmentReport:sendassessmentreport language:_assessmentreportdict[@"documentlanguage"] assessmentReportDict:_assessmentreportdict];
            reportTable_subTotal_0.text=[self returnTranslatedTitle:@"Subtotal" sendAssessmentReport:sendassessmentreport language:_assessmentreportdict[@"documentlanguage"] assessmentReportDict:_assessmentreportdict];
            reportTable_subTotal_1.text=[self returnTranslatedTitle:@"Subtotal" sendAssessmentReport:sendassessmentreport language:_assessmentreportdict[@"documentlanguage"] assessmentReportDict:_assessmentreportdict];
            overallScoreTitle.text=[self returnTranslatedTitle:@"Student Overall Score" sendAssessmentReport:sendassessmentreport language:_assessmentreportdict[@"documentlanguage"] assessmentReportDict:_assessmentreportdict];
            instructorCommentsTitle.text=[self returnTranslatedTitle:@"Instructor Comments" sendAssessmentReport:sendassessmentreport language:_assessmentreportdict[@"documentlanguage"] assessmentReportDict:_assessmentreportdict];
            instructorTitle.text=[self returnTranslatedTitle:@"Instructor" sendAssessmentReport:sendassessmentreport language:_assessmentreportdict[@"documentlanguage"] assessmentReportDict:_assessmentreportdict];
            averageScoreTitle.text=[self returnTranslatedTitle:@"Center Average Score" sendAssessmentReport:sendassessmentreport language:_assessmentreportdict[@"documentlanguage"] assessmentReportDict:_assessmentreportdict];
            formRemarksView.hidden=[_assessmentreportdict[@"remarks"] isEqualToString:@""];
            formRemarks.text=_assessmentreportdict[@"remarks"];
            
            
            [self.view layoutIfNeeded];
            self.frame=viewstack.bounds;
            [self addSubview:self.view];
        }
    }
    return self;
}

-(NSString *) returnTranslatedTitle:(NSString *)title sendAssessmentReport:(BOOL)sendassessmentreport language:(NSString *)language assessmentReportDict:(NSMutableDictionary *)assessmentreportdict
{
    if(sendassessmentreport){
        NSMutableDictionary *documentlanguagetitledict=assessmentreportdict[@"documentlanguagetitledict"];
        NSString *translatedtitle=documentlanguagetitledict[title];
        return translatedtitle?translatedtitle:title;
    }else{
        return [MyClass returntitlewithtitle:title language:language];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==reportTable_0) {
        return ((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:0]).questionarray.count;
    }else if (tableView==reportTable_1){
        return ((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:1]).questionarray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AR_DP_Score1_TableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"shortAnswerCell"];
    
    if (tableView==reportTable_0) {
        assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:0]).questionarray objectAtIndex:indexPath.row];
    }else if (tableView==reportTable_1){
        assessmentformrowobject=[((AssessmentFormSectionObject *)[assessmentformarray objectAtIndex:1]).questionarray objectAtIndex:indexPath.row];
    }
    
    cell.question.text=assessmentformrowobject.title;
    NSString *score=assessmentformrowobject.responsearray[0];
    if([assessmentformrowobject.title isEqualToString:@""]){
        cell.score.text=@" ";
    }else if ([score isEqualToString:@"NA"]) {
        cell.score.text=assessmentformrowobject.responsearray[0];
    }else{
        cell.score.text=[NSString stringWithFormat:@"%@ / 10",assessmentformrowobject.responsearray[0]];
    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

@end
