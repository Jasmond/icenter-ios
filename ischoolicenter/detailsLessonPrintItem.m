//
//  detailsLessonPrintItem.m
//  iCenter
//
//  Created by Jasmond Luk on 13/11/2021.
//  Copyright © 2021 DreamHigh Company Limited. All rights reserved.
//

#import "detailsLessonPrintItem.h"

@implementation detailsLessonPrintItem
@synthesize view;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id) initWithFrame:(CGRect)frame LessonObject:(ClassTimeTableRecord3 *)object ContentMode:(NSString *)contentmode ZoomMode:(NSInteger)zoommode Index:(NSInteger)index CellWidth:(float)cellwidth TimeTableMode:(NSString *)timetablemode
{
    globalvariables=[GlobalVariables singleObj];
    float scale;
    if(zoommode==0){
        //fit
        if(cellwidth>50){
            scale=0.8;
        }else{
            scale=cellwidth/50*0.8;
            scale=scale<0.8?0.8:scale;
            scale=scale>1?1:scale;
        }
    }else if (zoommode==1){
        //standard, width=50
        scale=0.8;
    }else{
        //large
        scale=1;
    }
    
    NSString* nibName = NSStringFromClass([self class]);
    self = [super initWithFrame:frame];
    if (self) {
        if ([[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]) {
            contentBox.layer.masksToBounds=YES;
            contentBox.layer.cornerRadius=5;
            
            timetableDisplayArray=globalvariables.centerrecord.timetablefielddisplayorder;
            
            BOOL showlevel=[MyClass isTimeTableFieldEnabled:@"level"];
            BOOL showclassroom=[MyClass isTimeTableFieldEnabled:@"classroom"];
            BOOL showinstructor=[MyClass isTimeTableFieldEnabled:@"instructor"];
            BOOL showstudent=[MyClass isTimeTableFieldEnabled:@"student"];
            BOOL showsubject=[MyClass isTimeTableFieldEnabled:@"subject"];
            
            if ([contentmode isEqualToString:@"Subject"]) {
                contentBox.backgroundColor=[self returnsubjectcolor:object.subject];
            }else if ([contentmode isEqualToString:@"Classroom"]){
                contentBox.backgroundColor=[self returnclassroomcolor:object.classroom];
            }else if ([contentmode isEqualToString:@"Instructor"]){
                contentBox.backgroundColor=[self returninstructorcolor:object.instructor];
            }
            
            timeLabel.text=[NSString stringWithFormat:@"%@ - %@",object.classtime,[MyClass convertToNSStringWithNSDate:[[MyClass convertToNSDateWithDate:object.classtime DateFormat:@"HH:mm"] dateByAddingTimeInterval:object.classduration*60] DateFormat:@"HH:mm"]];
            timeLabel.font=[UIFont boldSystemFontOfSize:10*scale];
            subjectLabel.text=[MyClass returnsubjectnamewithsubject_shortname:object.subject centerkey:globalvariables.centerrecord.centerkey];
            subjectLabel.font=[UIFont systemFontOfSize:12*scale];
            
            
            
            instructorLabel.text=[MyClass returnstaffnamewithusername:object.instructor firstorfullname:@"Full"];
            instructorLabel.font=[UIFont systemFontOfSize:12*scale];
            [instructorimage.heightAnchor constraintEqualToConstant:15*scale].active = true;
            [instructorimage.widthAnchor constraintEqualToConstant:15*scale].active = true;
            
            sinstructorLabel.text=[MyClass returnstaffnamewithusername:object.sinstructor firstorfullname:@"Full"];
            sinstructorLabel.font=[UIFont systemFontOfSize:12*scale];
            [sinstructorimage.heightAnchor constraintEqualToConstant:15*scale].active = true;
            [sinstructorimage.widthAnchor constraintEqualToConstant:15*scale].active = true;
            
            
            classroomLabel.text=object.classroom;
            classroomLabel.font=[UIFont systemFontOfSize:12*scale];
            [classroomimage.heightAnchor constraintEqualToConstant:15*scale].active = true;
            [classroomimage.widthAnchor constraintEqualToConstant:15*scale].active = true;
            
            instructorStack.hidden=!showinstructor;
            classroomStack.hidden=!showclassroom;
            subjectStack.hidden=!showsubject;
            studentStack.hidden=!showstudent;
            
            levelLabel.font=[UIFont systemFontOfSize:12*scale];
            NSString *level;
            int attendingstudentcount=0;
            int outstandingstudentcount=0;
            
            countBox.hidden=![[MyClass getlocaldbwithparameter:@"timetableshowattendingcount"] isEqualToString:@"Y"];
            allcountBox.hidden=![[MyClass getlocaldbwithparameter:@"timetableshowallstudentcount"] isEqualToString:@"Y"];
            outstandingcountBox.hidden=![[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"] isEqualToString:@"Y"];
            
//            [[studentStack subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
            
            
            for (int j=0;j<object.studentarray.count;j++){
                ClassTimeTableSubRecord *subrecord=[object.studentarray objectAtIndex:j];
                if ([MyClass isattendingwithclasstype:subrecord.classtype attendance:subrecord.attendance makeupattendance:subrecord.attendance]) {
                    attendingstudentcount++;
                }
                if (showlevel) {
                    //deterine level
                    if (!level) {
                        level=subrecord.levelmain;
                    }else if (![level isEqualToString:subrecord.levelmain] && ![level isEqualToString:@"Multiple levels"]){
                        level=@"Multiple levels";
                    }
                }
                
                
                if (showlevel) {
                    levelLabel.text=[level isEqualToString:@"Multiple levels"]?[MyClass returntitlewithtitle:@"Multiple levels"]:([level isEqualToString:@""]?[MyClass returntitlewithtitle:@"NA"]:level);
                }
            }
                
            if(showstudent){
                NSMutableArray *studentStackArray=[[NSMutableArray alloc]init];
                for (id object in [studentStack subviews]){
                    if([object isKindOfClass:[UIStackView class]]){
                        [studentStackArray addObject:object];
                    }
                }
                
                
                for (int i=0; i<studentStackArray.count; i++) {
                    UIStackView *studentStack=studentStackArray[i];
                    studentStack.hidden=object.studentarray.count<i+1;
                    if (!studentStack.hidden) {
                        ClassTimeTableSubRecord *subrecord=[object.studentarray objectAtIndex:i];
                        for (id object in [studentStack arrangedSubviews]) {
                            if ([object isKindOfClass:[UILabel class]]) {
                                UILabel *namelabel=object;
                                [namelabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
                                namelabel.font=[UIFont systemFontOfSize:11*scale];
                                if ([subrecord.type isEqualToString:@"student"]) {
                                    namelabel.text=subrecord.displayname;
                                    if ([subrecord.classtype isEqualToString:@"Makeup"]) {
                                        namelabel.text=[NSString stringWithFormat:@"%@%@",[MyClass returntitlewithtitle:@"(MU)"],namelabel.text];
                                    }else if ([subrecord.classtype isEqualToString:@"Assessment"]) {
                                        namelabel.text=[NSString stringWithFormat:@"%@%@",[MyClass returntitlewithtitle:@"(A)"],namelabel.text];
                                    }else if ([subrecord.classtype isEqualToString:@"Trial"]) {
                                        namelabel.text=[NSString stringWithFormat:@"%@%@",[MyClass returntitlewithtitle:@"(T)"],namelabel.text];
                                    }
                                }else{
                                    namelabel.text=subrecord.displayname;
                                }
                                
                                if([MyClass getlocaldbwithparameter:@"showageintimetable"]){
                                    NSString *age;
                                    if([subrecord.type isEqualToString:@"student"]){
                                        age = [MyClass returnAgeFromStudent:[MyClass returnstudentwithstudentkey:subrecord.typekey]];
                                    }else{
                                        age = [MyClass returnAgeFromLead:[MyClass returnleadwithleadkey:subrecord.typekey]];
                                    }
                                    
                                    if(![age isEqualToString:@""]){
                                        namelabel.text=[NSString stringWithFormat:@"%@/%@",namelabel.text,age];
                                    }
                                }
                                
                                namelabel.textColor=[subrecord.outstanding floatValue]>0?[UIColor redColor]:[UIColor blackColor];
                                
                            }else if ([object isKindOfClass:[UIImageView class]]){
                                UIImageView *image=object;
                                [image.heightAnchor constraintEqualToConstant:15*scale].active = true;
                                [image.widthAnchor constraintEqualToConstant:15*scale].active = true;
                                if ([timetablemode isEqualToString:@"Consolidated"]) {
                                    [MyClass downloadImageWithImageview:image gender:nil type:subrecord.type typekey:subrecord.typekey image:@"Yes" async:YES];
                                }else{
                                    [image setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:subrecord.classtype attendance:subrecord.attendance makeupattendance:subrecord.attendance]]];
                                }
                            }
                        }
                    }
                }
            }
            
            if (showlevel && level) {
                levelLabel.hidden=NO;
                levelLabel.text=[level isEqualToString:@"Multiple levels"]?[MyClass returntitlewithtitle:@"Multiple levels"]:([level isEqualToString:@""]?[MyClass returntitlewithtitle:@"NA"]:level);
            }else{
                levelLabel.hidden=YES;
            }
            
            widthconstraint.constant=frame.size.width;
//            levelLabel.hidden=!showlevel;
            countLabel.text=[NSString stringWithFormat:@"%i",attendingstudentcount];
            countLabel.font=[UIFont systemFontOfSize:10*scale];
            
            allcountLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)object.studentarray.count];
            allcountLabel.font=[UIFont systemFontOfSize:10*scale];
            
            outstandingcountLabel.text=[NSString stringWithFormat:@"%i",outstandingstudentcount];
            outstandingcountLabel.font=[UIFont systemFontOfSize:10*scale];
            
            sinstructorStack.hidden=!showinstructor || !globalvariables.centerrecord.secondaryinstructor || [object.sinstructor isEqualToString:@""] || [object.sinstructor isEqualToString:@"TBD"];
            
            [self.view layoutIfNeeded];
            self.frame=frame;
            self.view.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
            [self addSubview:self.view];
        }
    }
    return self;
}

-(UIColor *) returninstructorcolor:(NSString *)instructor
{
    Staff *object=[MyClass returnstaffrecordwithusername:instructor];
    if (object) {
        return [globalvariables.colorcodearray objectAtIndex:object.colorcode];
    }else{
        return [globalvariables.colorcodearray objectAtIndex:globalvariables.centerrecord.timetabletbdinstructorcolorcode];
    }
}

-(UIColor *) returnclassroomcolor:(NSString *)classroom
{
    ClassroomRecord *object=[MyClass returnclassroominformationwithclassroom:classroom centerkey:globalvariables.centerrecord.centerkey];
    if (object) {
        return [globalvariables.colorcodearray objectAtIndex:object.colorcode];
    }else{
        return [globalvariables.colorcodearray objectAtIndex:globalvariables.centerrecord.timetabletbdclassroomcolorcode];
    }
}

-(UIColor *) returnsubjectcolor:(NSString *)subject
{
    SubjectRecord *object=[MyClass returnsubjectinformationwithsubject_shortname:(NSString *)subject centerkey:globalvariables.centerrecord.centerkey];
    if (object) {
        return [globalvariables.colorcodearray objectAtIndex:object.colorcode];
    }else{
        return [globalvariables.colorcodearray lastObject];
    }
}

@end
