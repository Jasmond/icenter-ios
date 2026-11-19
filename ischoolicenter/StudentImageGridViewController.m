//
//  StudentImageGridViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 11/9/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import "StudentImageGridViewController.h"
#import "MyClass.h"

@interface StudentImageGridViewController ()

@end

@implementation StudentImageGridViewController
@synthesize studentArray,studentcategory,mode,enrollmentrecord,classarray,instructorarray,subjectarray,source,tmpcallingkey,salesrecord,promotionarray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalvariables=[GlobalVariables singleObj];
    
    filteredStudentArray=[[NSMutableArray alloc]initWithArray:studentArray];
    
    viewtitle.text=[NSString stringWithFormat:@"%@ - %@",[MyClass returntitlewithtitle:@"Student Photo"],[MyClass returntitlewithtitle:studentcategory]];
    [title_CancelButton setTitle:[MyClass returntitlewithtitle:@"Close"] forState:UIControlStateNormal];
    [title_DoneButton setTitle:[MyClass returntitlewithtitle:[source isEqualToString:@"message"]?@"Done":@"Copy"] forState:UIControlStateNormal];
    
    df=[[NSDateFormatter alloc]init];
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    

    
    [studentphotocollection reloadData];
    
    if ([mode isEqualToString:@"multiple"]) {
        for (int i=0; i<studentArray.count; i++) {
            ((Student *)[studentArray objectAtIndex:i]).photoalbumrecord=[[ClassValidateRecord alloc]initClassValidateRecordwithstatus:@"" classvalidatestatus:[[ClassValidateStatus alloc]init] classvalidmessage:[[ClassValidateMessage alloc]init] classkey:nil];
            
            if (tmpcallingkey && tmpcallingkey.count>0) {
                if ([tmpcallingkey containsObject:((Student *)[filteredStudentArray objectAtIndex:i]).studentkey]) {
                    ((ClassValidateRecord *)((Student *)[studentArray objectAtIndex:i]).photoalbumrecord).status=@"Checked";
                }
            }
        }
        
        [df setDateFormat:@"dd-MMM-yyyy"];
        //enrollmentrecord.enrollmentdate=[df stringFromDate:[NSDate date]];
        enrollmentrecord.paid=@"0";
        enrollmentrecord.remarks=@"";
        enrollmentrecord.dropclassstatus=@"No";
        enrollmentrecord.dropclassdate=@"";
        enrollmentrecord.invoiceremarks=@"";
        
        for (int i=0; i<classarray.count; i++) {
            ((FreeScheduleClass *)[classarray objectAtIndex:i]).action=@"Add";
        }
        
        int checked=[self returncheckedimage];
        
        if (checked>0) {
            [title_DoneButton setTitle:[NSString stringWithFormat:@"%@ (%d)",[MyClass returntitlewithtitle:[source isEqualToString:@"message"]?@"Done":@"Copy"],checked] forState:UIControlStateNormal];
        }else{
            [title_DoneButton setTitle:[MyClass returntitlewithtitle:[source isEqualToString:@"message"]?@"Done":@"Copy"] forState:UIControlStateNormal];
        }
        
        
    }else{
        title_DoneButton.hidden=YES;
    }
    //self.preferredContentSize=CGSizeMake(984, 738);
    
    
    //studentsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 68, self.preferredContentSize.width, 42)];
    studentsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    //studentsearchbar.delegate=self;
    //[self.view addSubview:studentsearchbar];
    
    title_copydiscount.text=[MyClass returntitlewithtitle:@"Copy Discount"];
    swcopydiscount.on=globalvariables.centerrecord.cloneenrollmentcopydiscountdefault;
    copydiscountstack.hidden=![source isEqualToString:@"enrollment"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return filteredStudentArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StudentGridCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    cell.delegate=self;
    studentobject=[filteredStudentArray objectAtIndex:indexPath.row];
    cell.studentnamelabel.text=[MyClass returnStudentnameWithStudentkey:studentobject.studentkey option:@"full"];//] returnfullnamewithfirstname:studentobject.firstname lastname:studentobject.lastname];
    
    ////[MyClass downloadImageWithImageview:cell.studentimage collectionview:collectionView indexpath:indexPath gender:studentobject.gender type:@"student" typekey:studentobject.studentkey image:studentobject.image];
    
    [MyClass downloadImageWithImageview:cell.studentimage gender:studentobject.gender type:@"student" typekey:studentobject.studentkey image:studentobject.image async:YES];

    
    cell.studentimage.layer.cornerRadius=10;
    cell.studentimage.layer.masksToBounds=YES;
    
    cell.okbutton.layer.cornerRadius=5;
    cell.okbutton.layer.masksToBounds=YES;
    cell.cancelbutton.layer.cornerRadius=5;
    cell.cancelbutton.layer.masksToBounds=YES;
    [cell.okbutton setTitle:[MyClass returntitlewithtitle:@"OK"] forState:UIControlStateNormal];
    [cell.cancelbutton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    cell.messageview.layer.cornerRadius=5;
    cell.messageview.layer.masksToBounds=YES;

    photoalbumobject=((Student *)[filteredStudentArray objectAtIndex:indexPath.row]).photoalbumrecord;
    
    if ([mode isEqualToString:@"multiple"]) {
        if ([source isEqualToString:@"enrollment"]) {
            
            if ([photoalbumobject.status isEqualToString:@"Checked"]) {
                [cell.informationbutton setImage:[UIImage imageNamed:@"checked_icon.png"] forState:UIControlStateNormal];
                cell.informationbutton.hidden=NO;
                cell.informationbutton.userInteractionEnabled=NO;
                cell.messageview.hidden=YES;
            }else if ([photoalbumobject.status isEqualToString:@"Passed"]) {
                [cell.informationbutton setImage:[UIImage imageNamed:@"passed_icon.png"] forState:UIControlStateNormal];
                cell.informationbutton.hidden=NO;
                cell.informationbutton.userInteractionEnabled=NO;
                cell.messageview.hidden=YES;
            }else if ([photoalbumobject.status isEqualToString:@"Failed"]) {
                [cell.informationbutton setImage:[UIImage imageNamed:@"warning_icon.png"] forState:UIControlStateNormal];
                cell.informationbutton.hidden=NO;
                cell.informationbutton.userInteractionEnabled=YES;
                cell.messageview.hidden=NO;
                cell.okbutton.hidden=YES;
                cell.errormessagelabel.text=[MyClass returntitlewithtitle:@"Student already enrolled in other course"];
            }else if ([photoalbumobject.status isEqualToString:@"UserResponse"]) {
                [cell.informationbutton setImage:[UIImage imageNamed:@"warning_icon.png"] forState:UIControlStateNormal];
                cell.informationbutton.hidden=NO;
                cell.informationbutton.userInteractionEnabled=YES;
                cell.messageview.hidden=NO;
                cell.okbutton.hidden=NO;

                if (![((ClassValidateMessage *)photoalbumobject.classvalidatemessage).alreadyenrolledmessage isEqualToString:@""] && ![((ClassValidateStatus *)photoalbumobject.classvalidatestatus).alreadyenrolledstatus isEqualToString:@"Override"]) {
                    cell.errormessagelabel.text=[MyClass returntitlewithtitle:@"Student already enroll other course. Do you want to enroll anyway?"];
                }else if (![((ClassValidateMessage *)photoalbumobject.classvalidatemessage).overenrollmentmessage isEqualToString:@""] && ![((ClassValidateStatus *)photoalbumobject.classvalidatestatus).overenrollmentstatus isEqualToString:@"Override"]) {
                    cell.errormessagelabel.text=[MyClass returntitlewithtitle:@"Class over enrollment. Do you want to enroll anyway?"];
                }else if (![((ClassValidateMessage *)photoalbumobject.classvalidatemessage).sameinstructormulticlassmessage isEqualToString:@""] && ![((ClassValidateStatus *)photoalbumobject.classvalidatestatus).sameinstructormulticlassstatus isEqualToString:@"Override"]) {
                    cell.errormessagelabel.text=[MyClass returntitlewithtitle:@"Instructor conflicts with other class. Do you want to continue?"];
                }else if (![((ClassValidateMessage *)photoalbumobject.classvalidatemessage).sameclassroommulticlassmessage isEqualToString:@""] && ![((ClassValidateStatus *)photoalbumobject.classvalidatestatus).sameclassroommulticlassstatus isEqualToString:@"Override"]) {
                    cell.errormessagelabel.text=[MyClass returntitlewithtitle:@"Classroom conflicts with other class. Do you want to continue?"];
                }else if (![((ClassValidateMessage *)photoalbumobject.classvalidatemessage).classroomexceedcapacitymessage isEqualToString:@""] && ![((ClassValidateStatus *)photoalbumobject.classvalidatestatus).classroomexceedcapacitystatus isEqualToString:@"Override"]) {
                    cell.errormessagelabel.text=[MyClass returntitlewithtitle:@"Classroom exceed capacity. Do you want to enroll anyway?"];
                }
            }else{
                cell.informationbutton.hidden=YES;
                cell.messageview.hidden=YES;
            }
        }else if ([source isEqualToString:@"message"]){
            if ([photoalbumobject.status isEqualToString:@"Checked"]) {
                [cell.informationbutton setImage:[UIImage imageNamed:@"checked_icon.png"] forState:UIControlStateNormal];
                cell.informationbutton.hidden=NO;
                cell.informationbutton.userInteractionEnabled=NO;
                cell.messageview.hidden=YES;
            }else{
                cell.informationbutton.hidden=YES;
                cell.messageview.hidden=YES;
            }
        }else if ([source isEqualToString:@"sales"]){
            if ([photoalbumobject.status isEqualToString:@"Checked"]) {
                [cell.informationbutton setImage:[UIImage imageNamed:@"checked_icon.png"] forState:UIControlStateNormal];
                cell.informationbutton.hidden=NO;
                cell.informationbutton.enabled=YES;
                cell.messageview.hidden=YES;
            }else{
                cell.informationbutton.hidden=YES;
                cell.messageview.hidden=YES;
            }
        }
    }else{
        cell.informationbutton.hidden=YES;
        cell.messageview.hidden=YES;
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(154, 180+20+0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 20, 5);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([mode isEqualToString:@"multiple"]) {
        
        photoalbumobject=((Student *)[filteredStudentArray objectAtIndex:indexPath.row]).photoalbumrecord;
        if ([photoalbumobject.status isEqualToString:@""] || [photoalbumobject.status isEqualToString:@"Checked"]) {
            if (![photoalbumobject.status isEqualToString:@""]) {
                photoalbumobject.status=@"";
            }else{
                photoalbumobject.status=@"Checked";
                //[checkimagearray replaceObjectAtIndex:indexPath.row withObject:@"Checked"];
                photoalbumobject.classvalidatestatus=[[ClassValidateStatus alloc]init];
                //[validateclassstatusarray replaceObjectAtIndex:indexPath.row withObject:[[ClassValidateStatus alloc]init]];
            }
            filteredStudentArray=[self returnfilterstudentarray];
            [studentphotocollection reloadData];
            //[studentphotocollection reloadItemsAtIndexPaths:[[NSArray alloc]initWithObjects:indexPath, nil]];
        }
        int checked=[self returncheckedimage];
        
        if (checked>0) {
            [title_DoneButton setTitle:[NSString stringWithFormat:@"%@ (%d)",[MyClass returntitlewithtitle:[source isEqualToString:@"message"]?@"Done":@"Copy"],checked] forState:UIControlStateNormal];
        }else{
            [title_DoneButton setTitle:[MyClass returntitlewithtitle:[source isEqualToString:@"message"]?@"Done":@"Copy"] forState:UIControlStateNormal];
        }
    }else{
        studentobject=[filteredStudentArray objectAtIndex:indexPath.row];
        [self.delegate passstudentfromgrid:studentobject.studentkey];
    }
}

-(int) returncheckedimage
{
    int checked=0;
    for (int i=0; i<filteredStudentArray.count; i++) {
        photoalbumobject=((Student *)[filteredStudentArray objectAtIndex:i]).photoalbumrecord;
        if ([photoalbumobject.status isEqualToString:@"Checked"]) {
            checked+=1;
        }
    }
    return checked;
}

- (IBAction)cancelbuttonpressed:(id)sender {
    [self.delegate dismissstudentgridviewwithreload:NO];
}

- (IBAction)savebuttonpressed:(id)sender
{
    __block BOOL checkedimagefound=FALSE;
    
    if ([source isEqualToString:@"enrollment"]) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i=0; i<filteredStudentArray.count; i++) {
            photoalbumobject=((Student *)[filteredStudentArray objectAtIndex:i]).photoalbumrecord;
            if ([photoalbumobject.status isEqualToString:@"Checked"]) {
                checkedimagefound=TRUE;
                [self validateAndUpdateEnrollmentwithindex:i];
            }
        }
        
        if (!checkedimagefound) {
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Copy Enrollment"] message:[MyClass returntitlewithtitle:@"Please select at least 1 student to copy the enrollment"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            //[self presentViewController:missinginput animated:YES completion:nil];
            [MyClass presentViewController:missinginput View:self];
        }else{

            
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate refreshstudentimagegridpresentingview];
                [studentphotocollection reloadData];
                UIAlertController *completealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Copy Enrollment"] message:[MyClass returntitlewithtitle:@"Enrollment copying is completed"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [completealert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [completealert addAction:OKAction];
                [MyClass presentViewController:completealert View:self];
                [title_DoneButton setTitle:[MyClass returntitlewithtitle:[source isEqualToString:@"enrollment"]?@"Copy":@"Done"] forState:UIControlStateNormal];
            //});
        }
        });
    }else if ([source isEqualToString:@"message"]){
        NSMutableArray *studentlist=[[NSMutableArray alloc]init];
        for (int i=0; i<filteredStudentArray.count; i++) {
            photoalbumobject=((Student *)[filteredStudentArray objectAtIndex:i]).photoalbumrecord;
            if ([photoalbumobject.status isEqualToString:@"Checked"]) {
                [studentlist addObject:((Student *)[filteredStudentArray objectAtIndex:i]).studentkey];
                checkedimagefound=TRUE;
            }
        }
        
        if (!checkedimagefound) {
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Send Message"] message:[MyClass returntitlewithtitle:@"Please select at least 1 student to send message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            //[self presentViewController:missinginput animated:YES completion:nil];
            [MyClass presentViewController:missinginput View:self];
        }else{
            //pass student list to message popover window
            [self.delegate passstudentarrayfromgrid:studentlist];
        }
    }else if ([source isEqualToString:@"sales"]) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *checkedstudentarray=[[NSMutableArray alloc]init];
            for (int i=0; i<filteredStudentArray.count; i++) {
                photoalbumobject=((Student *)[filteredStudentArray objectAtIndex:i]).photoalbumrecord;
                if ([photoalbumobject.status isEqualToString:@"Checked"]) {
                    [checkedstudentarray addObject:((Student *)[filteredStudentArray objectAtIndex:i]).studentkey];
                }
            }
            
            if (checkedstudentarray.count==0) {
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Copy Sales"] message:[MyClass returntitlewithtitle:@"Please select at least 1 student to copy the sales"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [missinginput dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [missinginput addAction:OKAction];
                [self presentViewController:missinginput animated:YES completion:nil];
            }else{
//                [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self updateBulkSalesWithStudentArray:checkedstudentarray];
                    //[studentphotocollection reloadData];
                    UIAlertController *completealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Copy Sales"] message:[MyClass returntitlewithtitle:@"Sales copying is completed"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [self.delegate dismissstudentgridviewwithreload:YES];
                    }];
                    
                    [completealert addAction:OKAction];
                    [self presentViewController:completealert animated:YES completion:nil];
                    [MyClass loadingindicatorwithoption:@"stop" color:nil];
//                });
                

            }
        });
        
    }
}

-(void) updateBulkSalesWithStudentArray:(NSMutableArray *)checkedstudentarray;
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsonstudentkeyarray=[[NSArray alloc]init];

    keys=[NSArray arrayWithObjects:@"studentkey",nil];
    
    //BOOL addToJson=FALSE;
    
    for (int i=0; i<checkedstudentarray.count; i++) {
        values=[NSArray arrayWithObjects:checkedstudentarray[i],nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    jsonstudentkeyarray = [NSArray arrayWithArray:arrayOfDicts];
    
    //combine arrays
    NSDictionary *dictionary = @{@"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"saleskey" : salesrecord.saleskey,
                                 @"studentkeys" : jsonstudentkeyarray,
                                 @"updatedby" : globalvariables.username,
                                 @"postaction" : @"copysales"};
    
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {

    }];
}

-(void) validateAndUpdateEnrollmentwithindex:(long)index
{
    ClassValidateMessage *classvalidatemessage=[[ClassValidateMessage alloc]init];
    ClassValidateStatus *classvalidatestatus=[[ClassValidateStatus alloc]init];
    enrollmentrecord.studentkey=((Student *)[filteredStudentArray objectAtIndex:index]).studentkey;
    
    photoalbumobject=((Student *)[filteredStudentArray objectAtIndex:index]).photoalbumrecord;

    classvalidatemessage=[MyClass validateClassWithFreeScheduleArray:classarray studentkey:enrollmentrecord.studentkey enrollmentkey:nil];
    classvalidatestatus=photoalbumobject.classvalidatestatus;// [validateclassstatusarray objectAtIndex:index];
    
    if (![classvalidatemessage.alreadyenrolledmessage isEqualToString:@""]  && ![classvalidatestatus.alreadyenrolledstatus isEqualToString:@"Override"]) {
        photoalbumobject.status=@"UserResponse";
        photoalbumobject.classvalidatemessage=classvalidatemessage;
    }else if(![classvalidatemessage.overenrollmentmessage isEqualToString:@""] && ![classvalidatestatus.overenrollmentstatus isEqualToString:@"Override"]) {
        photoalbumobject.status=@"UserResponse";
        photoalbumobject.classvalidatemessage=classvalidatemessage;
    }else if(![classvalidatemessage.sameinstructormulticlassmessage isEqualToString:@""] && ![classvalidatestatus.sameinstructormulticlassstatus isEqualToString:@"Override"]) {
        photoalbumobject.status=@"UserResponse";
        photoalbumobject.classvalidatemessage=classvalidatemessage;
    }else if(![classvalidatemessage.sameclassroommulticlassmessage isEqualToString:@""] && ![classvalidatestatus.sameclassroommulticlassstatus isEqualToString:@"Override"]) {
        photoalbumobject.status=@"UserResponse";
        photoalbumobject.classvalidatemessage=classvalidatemessage;
    }else if(![classvalidatemessage.classroomexceedcapacitymessage isEqualToString:@""] && ![classvalidatestatus.classroomexceedcapacitystatus isEqualToString:@"Override"]) {
        photoalbumobject.status=@"UserResponse";
        photoalbumobject.classvalidatemessage=classvalidatemessage;
    }else{
        enrollmentrecord.grade=((Student *)[filteredStudentArray objectAtIndex:index]).grade;
        
        enrollmentrecord.tuitionfee=[MyClass calculateTuitionFeeWithClass:enrollmentrecord.subject Levelmain:enrollmentrecord.levelmain noOfClass:enrollmentrecord.noofclass startdatetime:[NSString stringWithFormat:@"%@ %@",enrollmentrecord.startdate,enrollmentrecord.classtime] schedulekey:enrollmentrecord.schedulekey schedulerecord:[MyClass returnscheduleinformationwithsubject_shortname:enrollmentrecord.subject schedulekey:enrollmentrecord.schedulekey centerkey:globalvariables.centerrecord.centerkey] Grade:enrollmentrecord.grade EnrollmentTableMode:@"Copy" freescheduleclassarray:classarray];
        
//        enrollmentrecord.oneoffdiscount=@"";
//        enrollmentrecord.oneoffpercentagediscount=@"";
        enrollmentrecord.recursivediscount=@"";
        [self calculateTotalFeeWithEnrollmentFee:enrollmentrecord.enrollmentfee TuitionFee:enrollmentrecord.tuitionfee LateFee:enrollmentrecord.latefee];
        //enrollmentrecord.totalfee=[NSString stringWithFormat:@"%g",[enrollmentrecord.tuitionfee floatValue]+[enrollmentrecord.enrollmentfee floatValue]];
        
        if ([self updateEnrollmentClassPaymentWithPopoverEnrollment:enrollmentrecord FreeScheduleClassArray:classarray DetailsPaymentArray:nil draft:@"" drafttovalid:FALSE Action:@"Add" DTkey:nil]) {
            photoalbumobject.status=@"Passed";
        }else{
            photoalbumobject.status=@"Failed";
        }
    }
}

-(void) calculatetotaldiscount
{
    
    float discountedfee=[enrollmentrecord.tuitionfee floatValue];
    
    if(swcopydiscount.on){
        for (int i=0; i<enrollmentrecord.promotiondiscountrecords.count; i++) {
            MarketingRecord * marketingobject=[enrollmentrecord.promotiondiscountrecords objectAtIndex:i];
            if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
                discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[enrollmentrecord.noofclass integerValue]);
            }else{
                discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
            }
        }
        
        discountedfee*=(1-[enrollmentrecord.oneoffpercentagediscount floatValue]/100);
        discountedfee-=[enrollmentrecord.oneoffdiscount floatValue];
    }
    
    tmpTotalDiscount=[NSString stringWithFormat:@"%g",[enrollmentrecord.tuitionfee floatValue]-discountedfee];
    
    if (noofroundoffdigit==1) {
        if ([tmpTotalDiscount floatValue]==(int)[tmpTotalDiscount floatValue]) {
            tmpTotalDiscount=[NSString stringWithFormat:@"%g",[tmpTotalDiscount floatValue]];
        }else{
            if ([[NSString stringWithFormat:@"%.1f",[tmpTotalDiscount floatValue]] hasSuffix:@".0"]) {
                tmpTotalDiscount= [[NSString stringWithFormat:@"%.1f",[tmpTotalDiscount floatValue]] substringToIndex:[[NSString stringWithFormat:@"%.1f",[tmpTotalDiscount floatValue]] length]-2];
            }else{
                tmpTotalDiscount= [NSString stringWithFormat:@"%.1f",[tmpTotalDiscount floatValue]];
            }
        }
    }else{
        tmpTotalDiscount=[NSString stringWithFormat:@"%ld",lroundf([tmpTotalDiscount floatValue])];
    }
}


- (void) calculateTotalFeeWithEnrollmentFee:(NSString *)enrollmentfee TuitionFee:(NSString *)tuitionfee LateFee:(NSString *)latefee{
    
    [self calculatetotaldiscount];
    
    float thetotalfee=0;

    
    thetotalfee=[tuitionfee floatValue]-[tmpTotalDiscount floatValue]+[enrollmentfee floatValue]+[latefee floatValue];
    
    if (noofroundoffdigit==1) {
        if (thetotalfee==(int)thetotalfee) {
            enrollmentrecord.totalfee=[NSString stringWithFormat:@"%g",thetotalfee];
        }else{
            if ([[NSString stringWithFormat:@"%.1f",thetotalfee] hasSuffix:@".0"]) {
                enrollmentrecord.totalfee= [[NSString stringWithFormat:@"%.1f",thetotalfee] substringToIndex:[[NSString stringWithFormat:@"%.1f",thetotalfee] length]-2];
            }else{
                enrollmentrecord.totalfee= [NSString stringWithFormat:@"%.1f",thetotalfee];
            }
        }
    }else{
        enrollmentrecord.totalfee=[NSString stringWithFormat:@"%ld",lroundf(thetotalfee)];
    }
}


-(BOOL) updateEnrollmentClassPaymentWithPopoverEnrollment:(EnrollmentRecord *)popoverenrollment FreeScheduleClassArray:(NSMutableArray *)freescheduleclassarray DetailsPaymentArray:(NSMutableArray *)detailspaymentarray draft:(NSString *)draft drafttovalid:(BOOL)drafttovalid Action:(NSString *)action DTkey:(NSString *)DTkey
{
    
    NSDate *date;
    NSString *startdatestring;
    NSString *tmpclassday;
    NSString *tmpschoolmonth;
    NSString *tmpclasstime;
    NSString *tmpinstructor;
    NSString *tmpsinstructor;
    NSString *tmpclasskey;
    NSString *tmpaction;
    NSString *tmpdtkey;
    
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsonclassarray=[[NSArray alloc]init];
    NSArray *jsonpaymentarray=[[NSArray alloc]init];
    NSArray *jsonpromotionarray=[[NSArray alloc]init];
    FreeScheduleClass *FreeScheduleClassObject=[[FreeScheduleClass alloc]init];

    tmpdtkey=(!DTkey)?@"":DTkey;
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:@"updateenrollment" forKey:@"postaction"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:action forKey:@"action"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:popoverenrollment.studentkey forKey:@"studentkey"];
    [dictionary setValue:popoverenrollment.enrollmentkey forKey:@"enrollmentkey"];
    [dictionary setValue:popoverenrollment.subject forKey:@"subject"];
                                     
                                     
                                     
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"enrollmentdate" NewValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:popoverenrollment.enrollmentdate] OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"schedulekey" NewValue:popoverenrollment.schedulekey OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"levelmain" NewValue:popoverenrollment.levelmain OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"levelctm" NewValue:popoverenrollment.levelctm OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"grade" NewValue:popoverenrollment.grade OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"classtime" NewValue:popoverenrollment.classtime OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"startdate" NewValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:popoverenrollment.startdate] OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"noofclass" NewValue:popoverenrollment.noofclass OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"enddate" NewValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:popoverenrollment.enddate] OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"classday" NewValue:popoverenrollment.classday OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"instructor" NewValue:popoverenrollment.instructor OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"sinstructor" NewValue:popoverenrollment.sinstructor OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"classroom" NewValue:popoverenrollment.classroom OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"enrollmentfee" NewValue:popoverenrollment.enrollmentfee OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"tuitionfee" NewValue:popoverenrollment.tuitionfee OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"oneoffdiscount" NewValue:swcopydiscount.on?popoverenrollment.oneoffdiscount:@"" OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"recursivediscount" NewValue:popoverenrollment.recursivediscount OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"oneoffpercentagediscount" NewValue:swcopydiscount.on?popoverenrollment.oneoffpercentagediscount:@"" OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"latefee" NewValue:popoverenrollment.latefee OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"totalfee" NewValue:popoverenrollment.totalfee OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"paid" NewValue:[popoverenrollment.paid isEqualToString:@""]?@"0":popoverenrollment.paid OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"dropclassstatus" NewValue:popoverenrollment.dropclassstatus OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"dropclassdate" NewValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:popoverenrollment.dropclassdate] OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"remarks" NewValue:popoverenrollment.remarks OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"draft" NewValue:popoverenrollment.draft OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"invoiceremarks" NewValue:popoverenrollment.invoiceremarks OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"dtkey" NewValue:tmpdtkey OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"autorenew" NewValue:popoverenrollment.autorenew OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"status" NewValue:popoverenrollment.status OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"reverseadjustment" NewValue:popoverenrollment.reverseadjustment OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"validity" NewValue:popoverenrollment.validity OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"makeup_quota" NewValue:popoverenrollment.makeup_quota OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"enrollmentmode" NewValue:popoverenrollment.enrollmentmode OldValue:@"" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"standardnoofclassormonth" NewValue:popoverenrollment.standardnoofclassormonth OldValue:@"" Action:action];
    
    
    //generate json class array
    if (freescheduleclassarray.count>0) {
        
        arrayOfDicts = [[NSMutableArray alloc] init];
        keys=[NSArray arrayWithObjects:@"centerdb",@"centerkey",@"studentkey",@"enrollmentkey",@"classkey",@"subject",@"classtime",@"startdate",@"levelmain",@"levelctm",@"instructor",@"classroom",@"classday",@"schoolmonth",@"attendance",@"makeupattendance",@"makeupdate",@"makeuptime",@"makeupinstructor",@"makeupclassroom",@"absentmakeupreason",@"remarks",@"allclassremarks",@"draft", @"action",@"sinstructor",@"makeupsinstructor",nil];
        
        for (int i = 0; i<freescheduleclassarray.count; i++) {
            FreeScheduleClassObject=[freescheduleclassarray objectAtIndex:i];

                if ([FreeScheduleClassObject.classdate isEqualToString:@"TBD"]) {
                    startdatestring=@"TBD";
                    tmpclassday=@"TBD";
                    tmpschoolmonth=@"TBD";
                    tmpclasstime=FreeScheduleClassObject.classtime;
                    tmpinstructor=FreeScheduleClassObject.instructor;
                    tmpsinstructor=FreeScheduleClassObject.sinstructor;
                }else{
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    date=[df dateFromString:FreeScheduleClassObject.classdate];
                    [df setDateFormat:@"yyyy-MM-dd"];
                    startdatestring=[df stringFromDate:date];
                    [df setDateFormat:@"EEE"];
                    tmpclassday=[df stringFromDate:date];
                    tmpschoolmonth=[MyClass findSchoolMonthWithStartDateTime:FreeScheduleClassObject.classdate EndDate:@""];
                    tmpclasstime=FreeScheduleClassObject.classtime;
                    tmpinstructor=FreeScheduleClassObject.instructor;
                    tmpsinstructor=FreeScheduleClassObject.sinstructor;
                }
                
                tmpclasskey=@"";
                tmpaction=@"Add";
                
            
            values=[NSArray arrayWithObjects:globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,popoverenrollment.studentkey,popoverenrollment.enrollmentkey,tmpclasskey?tmpclasskey:@"",FreeScheduleClassObject.subject,tmpclasstime?tmpclasstime:@"",startdatestring?startdatestring:@"",popoverenrollment.levelmain?popoverenrollment.levelmain:@"",popoverenrollment.levelctm?popoverenrollment.levelctm:@"",tmpinstructor?tmpinstructor:@"",FreeScheduleClassObject.classroom,tmpclassday?tmpclassday:@"",tmpschoolmonth?tmpschoolmonth:@"",globalvariables.centerrecord.defaultattendancestatus,@"",@"",@"",@"",@"",@"",FreeScheduleClassObject.classremarks,FreeScheduleClassObject.allclassremarks,draft, tmpaction,tmpinstructor?tmpinstructor:@"",@"", nil];
            
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
        jsonclassarray = [NSArray arrayWithArray:arrayOfDicts];
        //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonclassarray options:NSJSONWritingPrettyPrinted error:&requestError];
        
    }
    
    if (enrollmentrecord.promotiondiscountrecords.count>0 && swcopydiscount.on) {
        arrayOfDicts = [[NSMutableArray alloc] init];
        keys=[NSArray arrayWithObjects:@"marketingkey",@"recursive",nil];
        
        for (long i =0; i< enrollmentrecord.promotiondiscountrecords.count; i++) {
            MarketingRecord *marketingobject=[enrollmentrecord.promotiondiscountrecords objectAtIndex:i];
            
            values=[NSArray arrayWithObjects:marketingobject.marketingkey,marketingobject.recursive, nil];
            
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
        jsonpromotionarray = [NSArray arrayWithArray:arrayOfDicts];
    }
    
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:jsonclassarray forKey:@"classarray"];
    [dictionary setValue:jsonpaymentarray forKey:@"paymentarray"];
    [dictionary setValue:jsonpromotionarray forKey:@"promotionarray"];
                                     
                                    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    __block BOOL result=FALSE;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray * JSONArray = jsonreturned[@"content"];
            if ([[[JSONArray objectAtIndex:0] objectForKey:@"result"] isEqualToString:@"success"]) {
                result= YES;
            }
        }else{
            NSLog(@"NSURLConnection sendSynchronousRequest error: %@", error);
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    return result;
}

-(void) copycancelbuttonpressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:studentphotocollection];
    NSIndexPath *indexpath =[studentphotocollection indexPathForItemAtPoint:point];
    
    photoalbumobject=((Student *)[filteredStudentArray objectAtIndex:indexpath.row]).photoalbumrecord;
    photoalbumobject.status=@"";
    
    //[checkimagearray replaceObjectAtIndex:indexpath.row withObject:@""];
    [studentphotocollection reloadData];
}

-(void) informationbuttonpressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:studentphotocollection];
    NSIndexPath *indexpath =[studentphotocollection indexPathForItemAtPoint:point];
    
    NSString *errormessage;
    
    photoalbumobject=((Student *)[filteredStudentArray objectAtIndex:indexpath.row]).photoalbumrecord;
    
    ClassValidateMessage *validatemessage=photoalbumobject.classvalidatemessage;
    ClassValidateStatus *validatestatus=photoalbumobject.classvalidatestatus;//[validateclassstatusarray objectAtIndex:indexpath.row];
    
    if (![validatemessage.alreadyenrolledmessage isEqualToString:@""] && ![validatestatus.alreadyenrolledstatus isEqualToString:@"Override"]) {
        errormessage=validatemessage.alreadyenrolledmessage;
    }else if (![validatemessage.overenrollmentmessage isEqualToString:@""] && ![validatestatus.overenrollmentstatus isEqualToString:@"Override"]) {
        errormessage=validatemessage.overenrollmentmessage;
    }else if (![validatemessage.sameinstructormulticlassmessage isEqualToString:@""] && ![validatestatus.sameinstructormulticlassstatus isEqualToString:@"Override"]) {
        errormessage=validatemessage.sameinstructormulticlassmessage;
    }else if (![validatemessage.sameclassroommulticlassmessage isEqualToString:@""] && ![validatestatus.sameclassroommulticlassstatus isEqualToString:@"Override"]) {
        errormessage=validatemessage.sameclassroommulticlassmessage;
    }else if (![validatemessage.classroomexceedcapacitymessage isEqualToString:@""] && ![validatestatus.classroomexceedcapacitystatus isEqualToString:@"Override"]) {
        errormessage=validatemessage.classroomexceedcapacitymessage;
    }
    
    
    [self popupwarningwindowwithbutton:sender warningmessage:errormessage];
}

-(void) copyokbuttonpressed:(UIButton *)sender
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:studentphotocollection];
        NSIndexPath *indexpath =[studentphotocollection indexPathForItemAtPoint:point];
        
        photoalbumobject=((Student *)[filteredStudentArray objectAtIndex:indexpath.row]).photoalbumrecord;
        
        ClassValidateMessage *validatemessage=photoalbumobject.classvalidatemessage;
        ClassValidateStatus *validatestatus=photoalbumobject.classvalidatestatus;//[validateclassstatusarray objectAtIndex:indexpath.row];
        
        if (![validatemessage.alreadyenrolledmessage isEqualToString:@""] && ![validatestatus.alreadyenrolledstatus isEqualToString:@"Override"]) {
            validatestatus.alreadyenrolledstatus=@"Override";
        }else if (![validatemessage.overenrollmentmessage isEqualToString:@""] && ![validatestatus.overenrollmentstatus isEqualToString:@"Override"]) {
            validatestatus.overenrollmentstatus=@"Override";
        }else if (![validatemessage.sameinstructormulticlassmessage isEqualToString:@""] && ![validatestatus.sameinstructormulticlassstatus isEqualToString:@"Override"]) {
            validatestatus.sameinstructormulticlassstatus=@"Override";
        }else if (![validatemessage.sameclassroommulticlassmessage isEqualToString:@""] && ![validatestatus.sameclassroommulticlassstatus isEqualToString:@"Override"]) {
            validatestatus.sameclassroommulticlassstatus=@"Override";
        }else if (![validatemessage.classroomexceedcapacitymessage isEqualToString:@""] && ![validatestatus.classroomexceedcapacitystatus isEqualToString:@"Override"]) {
            validatestatus.classroomexceedcapacitystatus=@"Override";
        }
        
        //update enrollment again
        [self validateAndUpdateEnrollmentwithindex:indexpath.row];
        [studentphotocollection reloadData];
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate refreshstudentimagegridpresentingview];
        //});
    });
    
    
}


-(void) popupwarningwindowwithbutton:(UIButton *)sender warningmessage:(NSString *)warningmessage
{
    UILabel *warningmessagelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 400, 600)];
    warningmessagelabel.font=[UIFont systemFontOfSize:15];
    warningmessagelabel.textColor=[UIColor darkGrayColor];
    warningmessagelabel.textAlignment=NSTextAlignmentCenter;
    warningmessagelabel.text=[NSString stringWithFormat:@"%@%@",warningmessage,@"\r\n"];
    warningmessagelabel.numberOfLines=0;
    [warningmessagelabel sizeToFit];
    
    CGRect myFrame=warningmessagelabel.frame;
    myFrame=CGRectMake(myFrame.origin.x, myFrame.origin.y, 400, myFrame.size.height);
    warningmessagelabel.frame=myFrame;
    
    UIScrollView *scrollbar=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, 400, warningmessagelabel.frame.size.height>600?600:warningmessagelabel.frame.size.height)];
    scrollbar.showsHorizontalScrollIndicator=NO;
    scrollbar.showsVerticalScrollIndicator=YES;
    scrollbar.delegate=self;
    scrollbar.backgroundColor=[UIColor systemGroupedBackgroundColor];
    
    [scrollbar setContentSize:CGSizeMake(400, warningmessagelabel.frame.size.height)];
    [scrollbar addSubview:warningmessagelabel];
    
    
    UIView *warningview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 400, scrollbar.frame.size.height+44)];
    [warningview addSubview:scrollbar];
    
    //add toolbar
    UIToolbar *Toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 400, 44)];
    Toolbar.barStyle=UIBarStyleDefault;
    Toolbar.barTintColor=[UIColor lightGrayColor];
    
    NSMutableArray *barItems=[[NSMutableArray alloc]init];
    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *closeButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Close"] style:UIBarButtonItemStylePlain target:self action:@selector(closewarning:)];
    barItems = [[NSMutableArray alloc]initWithObjects:flexSpace,closeButton, nil];
    
    [Toolbar setItems:barItems];
    [warningview addSubview:Toolbar];
    
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=warningview;
    viewcontroller.preferredContentSize=CGSizeMake(400, warningview.frame.size.height);
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myPopoverController=viewcontroller.popoverPresentationController;
    //myPopoverController.delegate=self;
    myPopoverController.permittedArrowDirections=UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight;
    myPopoverController.sourceView=sender;
    myPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
}

-(void) closewarning:(id)sender
{
    [[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==studentsearchbar) {
        filteredStudentArray=[self returnfilterstudentarray];
        [studentphotocollection reloadData];
        [studentphotocollection setContentOffset:CGPointZero animated:YES];
    }
}

-(NSMutableArray *) returnfilterstudentarray
{
    NSMutableArray *result;
    
    if ([studentsearchbar.text isEqualToString:@""]) {
        result= [[NSMutableArray alloc]initWithArray:studentArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.othername contains[c] %@ or SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or any phonearray.contact contains[c] %@ or self.studentid contains[c] %@ or self.remarks contains[c] %@ or self.grade contains[c] %@ or self.school contains[c] %@ or self.parentaddress contains[c] %@ or self.parentemail contains[c] %@ or  photoalbumrecord.status contains[c] %@",studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,@"Checked"];
        result= [[NSMutableArray alloc]initWithArray:[studentArray filteredArrayUsingPredicate:predicate]];
    }
    
    return [MyClass sortstudentlistwithstudentarray:result sortingarray:nil];
}



@end
