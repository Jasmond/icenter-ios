
//  detailsLessonItem.m
//  iCenter
//
//  Created by Jasmond Luk on 13/11/2021.
//  Copyright © 2021 DreamHigh Company Limited. All rights reserved.
//

#import "detailsLessonItem.h"

@implementation detailsLessonItem
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
//    globalvariables=[GlobalVariables singleObj];
//    float scale;
//    if(zoommode==0){
//        //fit
//        if(cellwidth>50){
//            scale=0.8;
//        }else{
//            scale=cellwidth/50*0.8;
//            scale=scale<0.8?0.8:scale;
//            scale=scale>1?1:scale;
//        }
//    }else if (zoommode==1){
//        //standard, width=50
//        scale=0.8;
//    }else{
//        //large
//        scale=1;
//    }
    
    NSString* nibName = NSStringFromClass([self class]);
    self = [super initWithFrame:frame];
    if (self) {
        if ([[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]) {

            [self setupDetailsLessonItemWithFrame:frame LessonObject:object ContentMode:contentmode ZoomMode:zoommode Index:index CellWidth:cellwidth TimeTableMode:timetablemode];
            
            /*contentBox.layer.borderColor=[UIColor lightGrayColor].CGColor;
            contentBox.layer.borderWidth=0.5;
            contentBox.layer.masksToBounds=YES;
            contentBox.layer.cornerRadius=5;
            
            timetableDisplayArray=globalvariables.centerrecord.timetablefielddisplayorder;
            
            BOOL showlevel=[MyClass isTimeTableFieldEnabled:@"level"];
            BOOL showclassroom=[MyClass isTimeTableFieldEnabled:@"classroom"];
            BOOL showinstructor=[MyClass isTimeTableFieldEnabled:@"instructor"];
            BOOL showstudent=[MyClass isTimeTableFieldEnabled:@"student"];
            BOOL showsubject=[MyClass isTimeTableFieldEnabled:@"subject"];
            
            [mainstack removeArrangedSubview:subjectStack];
            [mainstack removeArrangedSubview:levelLabel];
            [mainstack removeArrangedSubview:instructorStack];
            [mainstack removeArrangedSubview:sinstructorStack];
            [mainstack removeArrangedSubview:classroomStack];
            [mainstack removeArrangedSubview:studentStack];
            
            NSInteger sindex=1;
            for(int i=0;i<timetableDisplayArray.count;i++){
                if([[[timetableDisplayArray objectAtIndex:i] substringFromIndex:2] isEqualToString:@"subject"]){
                    [mainstack insertArrangedSubview:subjectStack atIndex:sindex];
                }else if([[[timetableDisplayArray objectAtIndex:i] substringFromIndex:2] isEqualToString:@"level"]){
                    [mainstack insertArrangedSubview:levelLabel atIndex:sindex];
                }else if([[[timetableDisplayArray objectAtIndex:i] substringFromIndex:2] isEqualToString:@"instructor"]){
                    [mainstack insertArrangedSubview:instructorStack atIndex:sindex];
                    sindex+=1;
                    [mainstack insertArrangedSubview:sinstructorStack atIndex:sindex];
                }else if([[[timetableDisplayArray objectAtIndex:i] substringFromIndex:2] isEqualToString:@"classroom"]){
                    [mainstack insertArrangedSubview:classroomStack atIndex:sindex];
                }else if([[[timetableDisplayArray objectAtIndex:i] substringFromIndex:2] isEqualToString:@"student"]){
                    [mainstack insertArrangedSubview:studentStack atIndex:sindex];
                }
                sindex+=1;
            }
            
            if ([contentmode isEqualToString:@"Subject"]) {
                contentBox.backgroundColor=[self returnsubjectcolor:object];
            }else if ([contentmode isEqualToString:@"Classroom"]){
                contentBox.backgroundColor=[self returnclassroomcolor:object.classroom];
            }else if ([contentmode isEqualToString:@"Instructor"]){
                contentBox.backgroundColor=[self returninstructorcolor:object.instructor];
            }
            
            timeLabel.text=[NSString stringWithFormat:@"%@ - %@",object.classtime,[MyClass convertToNSStringWithNSDate:[[MyClass convertToNSDateWithDate:object.classtime DateFormat:@"HH:mm"] dateByAddingTimeInterval:object.classduration*60] DateFormat:@"HH:mm"]];
            timeLabel.font=[UIFont boldSystemFontOfSize:10*scale];
            subjectLabel.text=object.subjectfullname;
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
            
            levelLabel.font=[UIFont systemFontOfSize:12*scale];
            NSString *level;
            int attendingstudentcount=0;
            int outstandingstudentcount=0;
            
            countBox.hidden=![[MyClass getlocaldbwithparameter:@"timetableshowattendingcount"] isEqualToString:@"Y"];
            allcountBox.hidden=![[MyClass getlocaldbwithparameter:@"timetableshowallstudentcount"] isEqualToString:@"Y"];
            outstandingcountBox.hidden=![[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"] isEqualToString:@"Y"];
            
            if(showstudent){
                studentStack.hidden=NO;
                [[studentStack subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
            }else{
                studentStack.hidden=YES;
            }
            
            for (int j=0;j<object.studentarray.count;j++){
                ClassTimeTableSubRecord *subrecord=[object.studentarray objectAtIndex:j];
                if ([MyClass isattendingwithclasstype:subrecord.classtype attendance:subrecord.attendance makeupattendance:subrecord.attendance]) {
                    attendingstudentcount++;
                }
                
                if([subrecord.outstanding floatValue]>0){
                    outstandingstudentcount++;
                }
                
                if (showlevel) {
                    //deterine level
                    if (!level) {
                        level=subrecord.levelmain;
                    }else if (![level isEqualToString:subrecord.levelmain] && ![level isEqualToString:@"Multiple levels"]){
                        level=@"Multiple levels";
                    }
                }
                
                if(showstudent){
                    UIStackView *vStack=[[UIStackView alloc]init];
                    vStack.translatesAutoresizingMaskIntoConstraints = NO;
                    vStack.alignment=UIStackViewAlignmentCenter;
                    vStack.axis=UILayoutConstraintAxisHorizontal;
                    vStack.distribution=UIStackViewDistributionFill;
                    vStack.spacing=2.0f;
                    
                    UIImageView *image=[[UIImageView alloc]init];
                    image.layer.masksToBounds=YES;
                    image.layer.cornerRadius=15*scale/2.0;
                    image.translatesAutoresizingMaskIntoConstraints = NO;
                    if ([timetablemode isEqualToString:@"Consolidated"]) {
                        [MyClass downloadImageWithImageview:image gender:nil type:subrecord.type typekey:subrecord.typekey image:@"Yes" async:YES];
                    }else{
                        [image setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:subrecord.classtype attendance:subrecord.attendance makeupattendance:subrecord.attendance]]];
                    }
                    
                    [image.heightAnchor constraintEqualToConstant:15*scale].active = true;
                    [image.widthAnchor constraintEqualToConstant:15*scale].active = true;
                    [vStack addArrangedSubview:image];
                    
                    UILabel *namelabel=[[UILabel alloc]init];
                    namelabel.translatesAutoresizingMaskIntoConstraints = NO;
                    namelabel.textAlignment=NSTextAlignmentLeft;
                    namelabel.textColor=[UIColor blackColor];
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
                    
                    [vStack addArrangedSubview:namelabel];
                    [studentStack addArrangedSubview:vStack];
                    
                    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:vStack attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:studentStack attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.f];
                    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:vStack attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:studentStack attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.f];
                    [studentStack addConstraint:leading];
                    [studentStack addConstraint:trailing];
                }
            }
            
            if (showlevel && level) {
                levelLabel.hidden=NO;
                levelLabel.text=[level isEqualToString:@"Multiple levels"]?[MyClass returntitlewithtitle:@"Multiple levels"]:([level isEqualToString:@""]?[MyClass returntitlewithtitle:@"NA"]:level);
            }else{
                levelLabel.hidden=YES;
            }
            
            
            widthconstraint.constant=frame.size.width;
            countLabel.text=[NSString stringWithFormat:@"%i",attendingstudentcount];
            countLabel.font=[UIFont systemFontOfSize:10*scale];
            
            allcountLabel.text=[NSString stringWithFormat:@"%lu",(unsigned long)object.studentarray.count];
            allcountLabel.font=[UIFont systemFontOfSize:10*scale];
            
            outstandingcountLabel.text=[NSString stringWithFormat:@"%i",outstandingstudentcount];
            outstandingcountLabel.font=[UIFont systemFontOfSize:10*scale];
            
            sinstructorStack.hidden=!showinstructor || !globalvariables.centerrecord.secondaryinstructor || [object.sinstructor isEqualToString:@""] || [object.sinstructor isEqualToString:@"TBD"];
            self.frame=frame;
            self.view.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);*/
            [self addSubview:self.view];
        }
    }
    return self;
}

-(void) configureDetailsLessonItemWithFrame:(CGRect)frame LessonObject:(ClassTimeTableRecord3 *)object ContentMode:(NSString *)contentmode ZoomMode:(NSInteger)zoommode Index:(NSInteger)index CellWidth:(float)cellwidth TimeTableMode:(NSString *)timetablemode
{
    [self setupDetailsLessonItemWithFrame:frame LessonObject:object ContentMode:contentmode ZoomMode:zoommode Index:index CellWidth:cellwidth TimeTableMode:timetablemode];
}


-(void) setupDetailsLessonItemWithFrame:(CGRect)frame LessonObject:(ClassTimeTableRecord3 *)object ContentMode:(NSString *)contentmode ZoomMode:(NSInteger)zoommode Index:(NSInteger)index CellWidth:(float)cellwidth TimeTableMode:(NSString *)timetablemode
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
    
            contentBox.layer.borderColor=[UIColor lightGrayColor].CGColor;
            contentBox.layer.borderWidth=0.5;
            contentBox.layer.masksToBounds=YES;
            contentBox.layer.cornerRadius=5;
            
            timetableDisplayArray=globalvariables.centerrecord.timetablefielddisplayorder;
            
            BOOL showlevel=[MyClass isTimeTableFieldEnabled:@"level"];
            BOOL showclassroom=[MyClass isTimeTableFieldEnabled:@"classroom"];
            BOOL showinstructor=[MyClass isTimeTableFieldEnabled:@"instructor"];
            BOOL showstudent=[MyClass isTimeTableFieldEnabled:@"student"];
            BOOL showsubject=[MyClass isTimeTableFieldEnabled:@"subject"];
            BOOL showlessonnumber=[[MyClass getlocaldbwithparameter:@"timetableshowlessonnumber"] isEqualToString:@"Y"] && globalvariables.centerrecord.enablelessonnumber;
            
            [mainstack removeArrangedSubview:subjectStack];
            [mainstack removeArrangedSubview:levelLabel];
            [mainstack removeArrangedSubview:instructorStack];
            [mainstack removeArrangedSubview:sinstructorStack];
            [mainstack removeArrangedSubview:classroomStack];
            [mainstack removeArrangedSubview:studentStack];
            
    //remove all student
    for (UIStackView *vStack in studentStack.arrangedSubviews) {
        [studentStack removeArrangedSubview:vStack];
    }
    
            NSInteger sindex=1;
            for(int i=0;i<timetableDisplayArray.count;i++){
                if([[[timetableDisplayArray objectAtIndex:i] substringFromIndex:2] isEqualToString:@"subject"]){
                    [mainstack insertArrangedSubview:subjectStack atIndex:sindex];
                }else if([[[timetableDisplayArray objectAtIndex:i] substringFromIndex:2] isEqualToString:@"level"]){
                    [mainstack insertArrangedSubview:levelLabel atIndex:sindex];
                }else if([[[timetableDisplayArray objectAtIndex:i] substringFromIndex:2] isEqualToString:@"instructor"]){
                    [mainstack insertArrangedSubview:instructorStack atIndex:sindex];
                    sindex+=1;
                    [mainstack insertArrangedSubview:sinstructorStack atIndex:sindex];
                }else if([[[timetableDisplayArray objectAtIndex:i] substringFromIndex:2] isEqualToString:@"classroom"]){
                    [mainstack insertArrangedSubview:classroomStack atIndex:sindex];
                }else if([[[timetableDisplayArray objectAtIndex:i] substringFromIndex:2] isEqualToString:@"student"]){
                    [mainstack insertArrangedSubview:studentStack atIndex:sindex];
                }
                sindex+=1;
            }
            
            if ([contentmode isEqualToString:@"Subject"]) {
                contentBox.backgroundColor=[self returnsubjectcolor:object];
            }else if ([contentmode isEqualToString:@"Classroom"]){
                contentBox.backgroundColor=[self returnclassroomcolor:object.classroom];
            }else if ([contentmode isEqualToString:@"Instructor"]){
                contentBox.backgroundColor=[self returninstructorcolor:object.instructor];
            }
            
            timeLabel.text=[NSString stringWithFormat:@"%@ - %@",object.classtime,[MyClass convertToNSStringWithNSDate:[[MyClass convertToNSDateWithDate:object.classtime DateFormat:@"HH:mm"] dateByAddingTimeInterval:object.classduration*60] DateFormat:@"HH:mm"]];
    
    
            timeLabel.font=[UIFont boldSystemFontOfSize:10*scale];
            subjectLabel.text=object.subjectfullname;
            subjectLabel.font=[UIFont systemFontOfSize:14*scale];
    if (showlessonnumber) {
        NSString *lessonnumber=[self renderLessonNumber:object.studentarray];
        if (![lessonnumber isEqualToString:@""]){
            subjectLabel.text=[NSString stringWithFormat:@"%@ %@",lessonnumber,subjectLabel.text];
        }
    }
            
    
    
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
            
            levelLabel.font=[UIFont systemFontOfSize:12*scale];
            NSString *level;
            int attendingstudentcount=0;
            int outstandingstudentcount=0;
            
            countBox.hidden=![[MyClass getlocaldbwithparameter:@"timetableshowattendingcount"] isEqualToString:@"Y"];
            allcountBox.hidden=![[MyClass getlocaldbwithparameter:@"timetableshowallstudentcount"] isEqualToString:@"Y"];
            outstandingcountBox.hidden=![[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"] isEqualToString:@"Y"];
            
            if(showstudent){
                studentStack.hidden=NO;
                [[studentStack subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
            }else{
                studentStack.hidden=YES;
            }
            
            for (int j=0;j<object.studentarray.count;j++){
                ClassTimeTableSubRecord *subrecord=[object.studentarray objectAtIndex:j];
                if ([MyClass isattendingwithclasstype:subrecord.classtype attendance:subrecord.attendance makeupattendance:subrecord.attendance]) {
                    attendingstudentcount++;
                }
                
                if([subrecord.outstanding floatValue]>0){
                    outstandingstudentcount++;
                }
                
                if (showlevel) {
                    //deterine level
                    if (!level) {
                        level=subrecord.levelmain;
                    }else if (![level isEqualToString:subrecord.levelmain] && ![level isEqualToString:@"Multiple levels"]){
                        level=@"Multiple levels";
                    }
                }
                
                if(showstudent){
                    UIStackView *vStack=[[UIStackView alloc]init];
                    vStack.translatesAutoresizingMaskIntoConstraints = NO;
                    vStack.alignment=UIStackViewAlignmentCenter;
                    vStack.axis=UILayoutConstraintAxisHorizontal;
                    vStack.distribution=UIStackViewDistributionFill;
                    vStack.spacing=2.0f;
                    
                    UIImageView *image=[[UIImageView alloc]init];
                    image.layer.masksToBounds=YES;
                    image.layer.cornerRadius=15*scale/2.0;
                    image.translatesAutoresizingMaskIntoConstraints = NO;
                    if ([timetablemode isEqualToString:@"Consolidated"]) {
                        [MyClass downloadImageWithImageview:image gender:nil type:subrecord.type typekey:subrecord.typekey image:@"Yes" async:YES];
                    }else{
                        [image setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:subrecord.classtype attendance:subrecord.attendance makeupattendance:subrecord.attendance]]];
                    }
                    
                    [image.heightAnchor constraintEqualToConstant:15*scale].active = true;
                    [image.widthAnchor constraintEqualToConstant:15*scale].active = true;
                    [vStack addArrangedSubview:image];
                    
                    UILabel *namelabel=[[UILabel alloc]init];
                    namelabel.translatesAutoresizingMaskIntoConstraints = NO;
                    namelabel.textAlignment=NSTextAlignmentLeft;
                    namelabel.textColor=[UIColor blackColor];
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
                    
                    [vStack addArrangedSubview:namelabel];
                    [studentStack addArrangedSubview:vStack];
                    
                    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:vStack attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:studentStack attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0.f];
                    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:vStack attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:studentStack attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.f];
                    [studentStack addConstraint:leading];
                    [studentStack addConstraint:trailing];
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
            self.frame=frame;
            self.view.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
//            [self addSubview:self.view];
//        }
//    }
//    return self;
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

-(UIColor *) returnsubjectcolor:(ClassTimeTableRecord3 *)object
{
    if ([object.subjecttype isEqualToString:@"subject"]) {
        SubjectRecord *subjectobject=[MyClass returnsubjectinformationwithsubject_shortname:object.subject centerkey:globalvariables.centerrecord.centerkey];
        if (subjectobject) {
            return [globalvariables.colorcodearray objectAtIndex:subjectobject.colorcode];
        }else{
            return [globalvariables.colorcodearray lastObject];
        }
    }else{
        SubjectCategoryRecord *subjectcategoryobject=[MyClass returnsubjectcategorywithscategorykey:object.subject];
        if (subjectcategoryobject) {
            return [globalvariables.colorcodearray objectAtIndex:subjectcategoryobject.colorcode];
        }else{
            return [globalvariables.colorcodearray lastObject];
        }
    }
    
}

- (NSString *)renderLessonNumber:(NSMutableArray *)studentlist
{
    NSMutableArray *lessons = [NSMutableArray array];
    NSString *lessonstring = @"";
    
    // Create a mutable copy of the student list
    NSMutableArray *filteredstudentlist = [studentlist mutableCopy];
    NSString *lesson;
    ClassTimeTableSubRecord *suberecordobj;
    
    if (filteredstudentlist.count > 0) {
        // Extract 'lesson' values (equivalent to lodash map)
        NSMutableArray *rawLessons = [NSMutableArray array];
        for (int i=0;i<filteredstudentlist.count;i++ ) {
            suberecordobj=[filteredstudentlist objectAtIndex:i];
            lesson = suberecordobj.lesson;
            if (lesson) {
                [rawLessons addObject:lesson];
            }
        }
        
        // Get unique lessons (equivalent to lodash uniq)
        NSSet *uniqueLessons = [NSSet setWithArray:rawLessons];
        
        // Filter out nil or empty strings (equivalent to lodash filter)
        for (id item in uniqueLessons) {
            NSString *lessonStr = [item description];
            if (lessonStr.length >  0) {
                [lessons addObject:lessonStr];
            }
        }
        
        // Format the string based on the count
        if (lessons.count == 1) {
            lessonstring = [NSString stringWithFormat:@"#%@", lessons[0]];
        } else if (lessons.count > 1) {
            lessonstring = [NSString stringWithFormat:@"#%@", [lessons componentsJoinedByString:@"/"]];
        }
    }
    
    return lessonstring;
}

@end
