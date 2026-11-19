//
//  AssessmentReportView.h
//  ischoolicenter
//
//  Created by Jasmond Luk on 15/12/2023.
//  Copyright © 2023 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "MyClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssessmentReportView : UIView
{
    GlobalVariables *globalvariables;
    __weak IBOutlet UIImageView *logo;
    __weak IBOutlet UITableView *reportTable_0;
    __weak IBOutlet UITableView *reportTable_1;
    __weak IBOutlet NSLayoutConstraint *reportTableHeight_0;
    __weak IBOutlet NSLayoutConstraint *reportTableHeight_1;
    __weak IBOutlet UILabel *studentLabel;
    __weak IBOutlet UILabel *gradeLabel;
    __weak IBOutlet UILabel *periodLabel;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UILabel *formLabel;
    __weak IBOutlet UILabel *subjectLabel;
    __weak IBOutlet UIStackView *viewstack;
    __weak IBOutlet UILabel *sumbitdateLabel;
    __weak IBOutlet UILabel *commentLabel;
    __weak IBOutlet UILabel *instructorLabel;
    __weak IBOutlet UILabel *total_0_Label;
    __weak IBOutlet UILabel *total_1_Label;
    __weak IBOutlet UILabel *totalLabel;
    __weak IBOutlet UILabel *reportTable_headerTitle_0;
    __weak IBOutlet UILabel *reportTable_headerTitle_1;
    
    __weak IBOutlet UIView *spiderChartView_0;
    __weak IBOutlet UIView *spiderChartView_1;
    
    __weak IBOutlet UILabel *chart_element_0;
    __weak IBOutlet UILabel *chart_element_1;
    __weak IBOutlet UILabel *chart_element_2;
    __weak IBOutlet UILabel *chart_element_3;
    __weak IBOutlet UILabel *chart_element_4;
    
    __weak IBOutlet UILabel *chart_element_10;
    __weak IBOutlet UILabel *chart_element_11;
    __weak IBOutlet UILabel *chart_element_12;
    __weak IBOutlet UILabel *chart_element_13;
    __weak IBOutlet UILabel *chart_element_14;
    
    __weak IBOutlet UILabel *studentTitle;
    __weak IBOutlet UILabel *gradeTitle;
    __weak IBOutlet UILabel *issueDateTitle;
    __weak IBOutlet UILabel *evaluationPeriodTitle;
    __weak IBOutlet UILabel *reportTableTitle_0;
    __weak IBOutlet UILabel *reportTableTitle_1;
    __weak IBOutlet UILabel *overallScoreTitle;
    __weak IBOutlet UILabel *reportTable_subTotal_0;
    __weak IBOutlet UILabel *reportTable_subTotal_1;
    __weak IBOutlet UILabel *instructorCommentsTitle;
    __weak IBOutlet UILabel *instructorTitle;
    __weak IBOutlet UILabel *averageScoreLabel;
    __weak IBOutlet UILabel *averageScoreTitle;
    __weak IBOutlet UILabel *issueDateLabel;
    __weak IBOutlet UIView *averageScoreSeparator;
    __weak IBOutlet UIStackView *averageScoreStack;
    __weak IBOutlet UIView *formRemarksView;
    __weak IBOutlet UILabel *formRemarks;
    
    NSMutableArray *assessmentformarray;
    
    NSArray *assessmentColorArray;
    AssessmentFormRowObject *assessmentformrowobject;
}

@property (weak, nonatomic) IBOutlet UIView *view;
- (id)initWithFrame:(CGRect)frame assessmentReportDict:(NSMutableDictionary *)_assessmentreportdict sendAssessmentReport:(BOOL)sendassessmentreport;

@end

NS_ASSUME_NONNULL_END
