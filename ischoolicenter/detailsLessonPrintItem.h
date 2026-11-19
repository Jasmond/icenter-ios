//
//  detailsLessonPrintItem.h
//  iCenter
//
//  Created by Jasmond Luk on 13/11/2021.
//  Copyright © 2021 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyClass.h"
#import "MyObject.h"

//NS_ASSUME_NONNULL_BEGIN


@interface detailsLessonPrintItem : UIView
{
    GlobalVariables *globalvariables;
    __weak IBOutlet UIView *contentBox;
    __weak IBOutlet UILabel *timeLabel;
    __weak IBOutlet UILabel *subjectLabel;
    __weak IBOutlet UILabel *levelLabel;
    __weak IBOutlet UILabel *instructorLabel;
    __weak IBOutlet UILabel *sinstructorLabel;
    __weak IBOutlet UILabel *classroomLabel;
    __weak IBOutlet UIStackView *studentStack;
    __weak IBOutlet UILabel *countLabel;
    __weak IBOutlet UIImageView *instructorimage;
    __weak IBOutlet UIImageView *sinstructorimage;
    __weak IBOutlet UIImageView *classroomimage;
    __weak IBOutlet NSLayoutConstraint *widthconstraint;
    
    __weak IBOutlet UIView *allcountBox;
    __weak IBOutlet UIView *countBox;
    __weak IBOutlet UIView *outstandingcountBox;
    __weak IBOutlet UILabel *allcountLabel;
    __weak IBOutlet UILabel *outstandingcountLabel;
    __weak IBOutlet UIStackView *instructorStack;
    __weak IBOutlet UIStackView *sinstructorStack;
    __weak IBOutlet UIStackView *classroomStack;
    
    __weak IBOutlet UIStackView *subjectStack;
    __weak IBOutlet UIStackView *mainstack;
    
    NSArray *timetableDisplayArray;
    
}

@property (weak, nonatomic) IBOutlet UIView *view;
//- (IBAction)viewButtonPressed:(id)sender;
- (id)initWithFrame:(CGRect)frame LessonObject:(ClassTimeTableRecord3 *)object ContentMode:(NSString *)contentmode ZoomMode:(NSInteger)zoommode Index:(NSInteger)index CellWidth:(float)cellwidth TimeTableMode:(NSString *)timetablemode;

@end

//NS_ASSUME_NONNULL_END
