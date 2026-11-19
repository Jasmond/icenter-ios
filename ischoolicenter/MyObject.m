//
//  MyObject.m
//  ELTestX
//
//  Created by Jasmond Luk on 5/7/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "MyObject.h"


@implementation ClassValidateMessage
@synthesize overenrollmentmessage,sameinstructormulticlassmessage,alreadyenrolledmessage,sameclassroommulticlassmessage,hasextendedchildclassmessage,classroomexceedcapacitymessage,makeupquotaexceedmessage;

-(id)initClassValidateMessagewithoverenrollmentmessage:(NSString *)coverenrollmentmessage sameinstructormulticlassmessage:(NSString *)csameinstructormulticlassmessage alreadyenrolledmessage:(NSString *)calreadyenrolledmessage sameclassroommulticlassmessage:(NSString *)csameclassroommulticlassmessage hasextendedchildclassmessage:(NSString *)chasextendedchildclassmessage classroomexceedcapacitymessage:(NSString *)cclassroomexceedcapacitymessage makeupquotaexceedmessage:(NSString *)cmakeupquotaexceedmessage

{
    self =[super init];
    if (self)
    {
        overenrollmentmessage=coverenrollmentmessage;
        sameinstructormulticlassmessage=csameinstructormulticlassmessage;
        alreadyenrolledmessage=calreadyenrolledmessage;
        sameclassroommulticlassmessage=csameclassroommulticlassmessage;
        hasextendedchildclassmessage=chasextendedchildclassmessage;
        classroomexceedcapacitymessage=cclassroomexceedcapacitymessage;
        makeupquotaexceedmessage=cmakeupquotaexceedmessage;
    }
    return self;
}

@end

@implementation ClassValidateStatus
@synthesize overenrollmentstatus,sameinstructormulticlassstatus,alreadyenrolledstatus,sameclassroommulticlassstatus,hasextendedchildclassstatus,classroomexceedcapacitystatus,makeupquotaexceedstatus;

-(id)initClassValidateStatuswithoverenrollmentstatus:(NSString *)coverenrollmentstatus sameinstructormulticlassstatus:(NSString *)csameinstructormulticlassstatus alreadyenrolledstatus:(NSString *)calreadyenrolledstatus sameclassroommulticlassstatus:(NSString *)csameclassroommulticlassstatus hasextendedchildclassstatus:(NSString *)chasextendedchildclassstatus classroomexceedcapacitystatus:(NSString *)cclassroomexceedcapacitystatus makeupquotaexceedstatus:(NSString *)cmakeupquotaexceedstatus

{
    self =[super init];
    if (self)
    {
        overenrollmentstatus=coverenrollmentstatus;
        sameinstructormulticlassstatus=csameinstructormulticlassstatus;
        alreadyenrolledstatus=calreadyenrolledstatus;
        sameclassroommulticlassstatus=csameclassroommulticlassstatus;
        hasextendedchildclassstatus=chasextendedchildclassstatus;
        classroomexceedcapacitystatus=cclassroomexceedcapacitystatus;
        makeupquotaexceedstatus=cmakeupquotaexceedstatus;
    }
    return self;
}

@end

@implementation ClassValidateRecord
@synthesize status,classvalidatestatus,classvalidatemessage,classkey;

-(id)initClassValidateRecordwithstatus:(NSString *)cstatus classvalidatestatus:(ClassValidateStatus *)cclassvalidatestatus classvalidmessage:(ClassValidateMessage *)cclassvalidmessage classkey:(NSString *)cclasskey

{
    self =[super init];
    if (self)
    {
        classkey=cclasskey;
        status=cstatus;
        classvalidatestatus=cclassvalidatestatus;
        classvalidatemessage=cclassvalidmessage;
    }
    return self;
}

@end

@implementation ClassExtendRecord
@synthesize classkey,classkeyarray;

-(id)initClassExtendRecordwithclasskey:(NSString *)cclasskey classkeyarray:(NSArray *)cclasskeyarray

{
    self =[super init];
    if (self)
    {
        classkey=cclasskey;
        classkeyarray=cclasskeyarray;
    }
    return self;
}

@end


@implementation Student
@synthesize studentkey,studentid,firstname,lastname,othername,gender,dateofbirth,age,grade,preferredlanguage,school,parentname,phonearray,parentemail,parentaddress,remarks,flag,status,promotion,image,leadkey,studentmedia,studentsource,siblingarray,photoalbumrecord,centerkey,due,avatar,sendmessage,displayfullname,fcmemberid,ddaenabled,ddaaccountno,ddaaccountname,ddadebtorreference,ddalimit,extrafield1,parentname2,validcouponcount,extrafield2,creditamount;


-(id)initStudentWithstudentkey:(NSString *)sstudentkey studentid:(NSString *)sstudentid firstname:(NSString *)sfirstname lastname:(NSString *)slastname othername:(NSString *)sothername gender:(NSString *)sgender dateofbirth:(NSString *)sdateofbirth age:(NSString *)sage grade:(NSString *)sgrade preferredlanguage:(NSString *)spreferredlanguage school:(NSString *)sschool parentname:(NSString *)sparentname phonearray:(NSMutableArray *)sphonearray parentemail:(NSString *)sparentemail parentaddress:(NSString *)sparentaddress remarks:(NSString *)sremarks flag:(NSString *)sflag status:(NSString *)sstatus promotion:(NSString *)spromotion image:(NSString *)simage leadkey:(NSString *)sleadkey studentmedia:(NSString *)sstudentmedia studentsource:(NSString *)sstudentsource siblingarray:(NSMutableArray *)ssiblingarray photoalbumrecord:(ClassValidateRecord *)sphotoalbumrecord centerkey:(NSString *)scenterkey due:(NSString *)sdue avatar:(NSString *)savatar sendmessage:(BOOL)ssendmessage displayfullname:(NSString *)sdisplayfullname fcmemberid:(NSString *)sfcmemberid ddaenabled:(BOOL)sddaenabled ddaaccountno:(NSString *)sddaaccountno ddaaccountname:(NSString *)sddaaccountname ddadebtorreference:(NSString *)sddadebtorreference ddalimit:(NSString *)sddalimit extrafield1:(NSString *)sextrafield1 parentname2:(NSString *)sparentname2 validcouponcount:(NSString *)svalidcouponcount extrafield2:(NSString *)sextrafield2 creditamount:(float)screditamount
{
    self =[super init];
    if (self)
    {
        studentkey=sstudentkey;
        studentid=sstudentid;
        firstname=sfirstname;
        lastname=slastname;
        othername=sothername;
        gender=sgender;
        dateofbirth=sdateofbirth;
        age=sage;
        grade=sgrade;
        preferredlanguage=spreferredlanguage;
        school=sschool;
        parentname=sparentname;
        //parentcontact=sparentcontact;
        phonearray=sphonearray;
        parentemail=sparentemail;
        parentaddress=sparentaddress;
        remarks=sremarks;
        flag=sflag;
        status=sstatus;
        promotion=spromotion;
        image=simage;
        leadkey=sleadkey;
        studentmedia=sstudentmedia;
        studentsource=sstudentsource;
        siblingarray=ssiblingarray;
        photoalbumrecord=sphotoalbumrecord;
        centerkey=scenterkey;
        due=sdue;
        avatar=savatar;
        sendmessage=ssendmessage;
        displayfullname=sdisplayfullname;
        fcmemberid=sfcmemberid;
        ddaenabled=sddaenabled;
        ddaaccountno=sddaaccountno;
        ddaaccountname=sddaaccountname;
        ddadebtorreference=sddadebtorreference;
        ddalimit=sddalimit;
        extrafield1=sextrafield1;
        parentname2=sparentname2;
        validcouponcount=svalidcouponcount;
        extrafield2=sextrafield2;
        creditamount=screditamount;
    }
    
    return self;
    
}

@end

@implementation Instructor
@synthesize staffkey,firstname,lastname,valid,username,phone,staffschedule,photoalbumrecord;

-(id)initInstructortWithstaffkey:(NSString *)sstaffkey firstname:(NSString *)sfirstname lastname:(NSString *)slastname username:(NSString *)susername phone:(NSString *)sphone valid:(NSString *)svalid photoalbumrecord:(ClassValidateRecord *)sphotoalbumrecord staffschedule:(BOOL)sstaffschedule
{
    self =[super init];
    if (self)
    {
        staffkey=sstaffkey;
        firstname=sfirstname;
        lastname=slastname;
        valid=svalid;
        username=susername;
        phone=sphone;
        staffschedule=sstaffschedule;
        photoalbumrecord=sphotoalbumrecord;
    }
    
    return self;
}


@end

@implementation Staff
@synthesize centerkey,staffkey,firstname,lastname,status,role,username,privilege,grouparray,phone,centerapp,staffapp,biapp,staffschedule,salaryrate,remarks,confirmmakeuprequest,staffscheduledict,iso_code,colorcode,avatar,showlastclass,showfirstclass,showoutstandingclass,showpendingrenewalclass,showassessclass,showtrialclass,showmakeupclass,showabsentclass,classtimetabledaystodisplay,a4trayfora5printing_invoice,a4trayfora5printing_receipt,defaultarckey,studentlistsortingorder,leadlistsortingorder,timetablezoommode,effectiveresignationdate,competencyarray;

-(id)initStaffWithCenterkey:(NSString *)scenterkey Staffkey:(NSString *)sstaffkey firstname:(NSString *)sfirstname lastname:(NSString *)slastname status:(NSString *)sstatus role:(NSString *)srole username:(NSString *)susername privilege:(NSString *)sprivilege grouparray:(NSMutableArray *)sgrouparray phone:(NSString *)sphone centerapp:(BOOL)scenterapp staffapp:(BOOL)sstaffapp biapp:(BOOL)sbiapp salaryrate:(NSString *)ssalaryrate remarks:(NSString *)sremarks staffschedule:(BOOL)sstaffschedule confirmmakeuprequest:(BOOL)sconfirmmakeuprequest staffscheduledict:(NSMutableDictionary *)sstaffscheduledict iso_code:(NSString *)siso_code colorcode:(NSInteger)scolorcode avatar:(NSString *)savatar showlastclass:(BOOL)sshowlastclass showfirstclass:(BOOL)sshowfirstclass showoutstandingclass:(BOOL)sshowoutstandingclass showpendingrenewalclass:(BOOL)sshowpendingrenewalclass showassessclass:(BOOL)sshowassessclass showtrialclass:(BOOL)sshowtrialclass showmakeupclass:(BOOL)sshowmakeupclass showabsentclass:(BOOL)sshowabsentclass classtimetabledaystodisplay:(NSString *)sclasstimetabledaystodisplay defaultarckey:(NSString *)sdefaultarckey a4trayfora5printing_invoice:(NSInteger)sa4trayfora5printing_invoice a4trayfora5printing_receipt:(NSInteger)sa4trayfora5printing_receipt studentlistsortingorder:(NSString *)sstudentlistsortingorder leadlistsortingorder:(NSString *)sleadlistsortingorder timetablezoommode:(NSInteger)stimetablezoommode effectiveresignationdate:(NSString *)seffectiveresignationdate competencyarray:(NSMutableArray *)scompetencyarray
{
    self =[super init];
    if (self)
    {
        centerkey=scenterkey;
        staffkey=sstaffkey;
        firstname=sfirstname;
        lastname=slastname;
        status=sstatus;
        role=srole;
        username=susername;
        privilege=sprivilege;
        grouparray=sgrouparray;
        phone=sphone;
        centerapp=scenterapp;
        staffapp=sstaffapp;
        biapp=sbiapp;
        staffschedule=sstaffschedule;
        salaryrate=ssalaryrate;
        remarks=sremarks;
        confirmmakeuprequest=sconfirmmakeuprequest;
        staffscheduledict=sstaffscheduledict;
        iso_code=siso_code;
        colorcode=scolorcode;
        avatar=savatar;
        showlastclass=sshowlastclass;
        showfirstclass=sshowfirstclass;
        showoutstandingclass=sshowoutstandingclass;
        showpendingrenewalclass=sshowpendingrenewalclass;
        showassessclass=sshowassessclass;
        showtrialclass=sshowtrialclass;
        showmakeupclass=sshowmakeupclass;
        showabsentclass=sshowabsentclass;
        classtimetabledaystodisplay=sclasstimetabledaystodisplay;
        defaultarckey=sdefaultarckey;
        a4trayfora5printing_receipt=sa4trayfora5printing_receipt;
        a4trayfora5printing_invoice=sa4trayfora5printing_invoice;
//        showtimetablelevel=sshowtimetablelevel;
        studentlistsortingorder=sstudentlistsortingorder;
        leadlistsortingorder=sleadlistsortingorder;
        timetablezoommode=stimetablezoommode;
        effectiveresignationdate=seffectiveresignationdate;
        competencyarray=scompetencyarray;
    }
    
    return self;
}


@end


@implementation ClassRecord
@synthesize studentkey,enrollmentkey,classkey,subject,levelmain,levelctm,startdate,classday,classtime,instructor,classroom,attendance,makeupattendance,makeupdate, makeuptime,remarks,allclassremarks,absentmakeupreason,makeupinstructor,makeupclassroom,draft,schedulekey,status,extendedminute,extensiontime,orderdatetime,instructorfullname,makeupinstructorfullname,subjectfullname,parentnote,assessmentformcount,leavenaturelistkey,makeupquotaavailable,voiceparentnotemessage,lesson,sinstructor,makeupsinstructor,locked,enrollmentpaid,expiredpromotion,hasextendedclass;

-(id)initClassWithstudentkey:(NSString *)cstudentkey andenrollmentkey:(NSString *)cenrollmentkey andclasskey:(NSString *)cclasskey andsubject:(NSString *)csubject andlevelmain:(NSString *)clevelmain andlevelctm:(NSString *)clevelctm andstartdate:(NSString *)cstartdate andclassday:(NSString *)cclassday andclasstime:(NSString *)cclasstime andinstructor:(NSString *)cinstructor andattendance:(NSString *)cattendance andmakeupattendance:(NSString *)cmakeupattendance andmakeupdate:(NSString *)cmakeupdate andmakeuptime:(NSString *)cmakeuptime andremarks:(NSString *)cremarks andallclassremarks:(NSString *)callclassremarks andmakeupinstructor:(NSString *)cmakeupinstructor andmakeupclassroom:(NSString *)cmakeupclassroom andabsentmakeupreason:(NSString *)cabsentmakeupreason anddraft:(NSString *)cdraft andclassroom:(NSString *)cclassroom andschedulekey:(NSString *)cschedulekey andstatus:(NSString *)cstatus andextendedminute:(NSString *)cextendedminute andextensiontime:(NSString *)cextensiontime orderdatetime:(NSString *)corderdatetime instructorfullname:(NSString *)cinstructorfullname makeupinstructorfullname:(NSString *)cmakeupinstructorfullname subjectfullname:(NSString *)csubjectfullname parentnote:(NSString *)cparentnote assessmentformcount:(int)cassessmentformcount leavenaturelistkey:(NSString *)cleavenaturelistkey makeupquotaavailable:(BOOL)cmakeupquotaavailable voiceparentnotemessage:(OutboxMessageRecord *)cvoiceparentnotemessage lesson:(NSString *)clesson sinstructor:(NSString *)csinstructor makeupsinstructor:(NSString *)cmakeupsinstructor locked:(BOOL)clocked enrollmentpaid:(BOOL)cenrollmentpaid expiredpromotion:(BOOL)cexpiredpromotion hasextendedclass:(BOOL)chasextendedclass
{
    
    self =[super init];
    if (self)
    {
        studentkey=cstudentkey;
        enrollmentkey=cenrollmentkey;
        classkey=cclasskey;
        subject=csubject;
        levelmain=clevelmain;
        levelctm=clevelctm;
        startdate=cstartdate;
        classday=cclassday;
        classtime=cclasstime;
        instructor=cinstructor;
        attendance=cattendance;
        makeupattendance=cmakeupattendance;
        makeupdate=cmakeupdate;
        makeuptime=cmakeuptime;
        remarks=cremarks;
        allclassremarks=callclassremarks;
        makeupinstructor=cmakeupinstructor;
        makeupclassroom=cmakeupclassroom;
        absentmakeupreason=cabsentmakeupreason;
        draft=cdraft;
        classroom=cclassroom;
        makeupclassroom=cmakeupclassroom;
        schedulekey=cschedulekey;
        status=cstatus;
        extendedminute=cextendedminute;
        extensiontime=cextensiontime;
        orderdatetime=corderdatetime;
        instructorfullname=cinstructorfullname;
        makeupinstructorfullname=cmakeupinstructorfullname;
        subjectfullname=csubjectfullname;
        parentnote=cparentnote;
        assessmentformcount=cassessmentformcount;
        leavenaturelistkey=cleavenaturelistkey;
        makeupquotaavailable=cmakeupquotaavailable;
        voiceparentnotemessage=cvoiceparentnotemessage;
        lesson=clesson;
        sinstructor=csinstructor;
        makeupsinstructor=cmakeupsinstructor;
        locked=clocked;
        enrollmentpaid=cenrollmentpaid;
        expiredpromotion=cexpiredpromotion;
        hasextendedclass=chasextendedclass;
    }
    
    return self;
    
}

@end

@implementation ClassRecord2
@synthesize classtype,type,typekey,classtypekey,subject,attendance,duration,extendedminute,startdate,classtime,instructor,classroom,makeupattendance,makeupdate,makeuptime,makeupinstructor,makeupclassroom,remarks,allclassremarks,absentmakeupreason,parentnote,request_status,request_for_value,request_for_leavenaturelistkey,request_for_value_reason,request_for_date,request_for_time,leavenaturelistkey;

-(id)initClassWithclasstype:(NSString *)cclasstype type:(NSString *)ctype typekey:(NSString *)ctypekey classtypekey:(NSString *)cclasstypekey subject:(NSString *)csubject attendance:(NSString *)cattendance duration:(NSString *)cduration extendedminute:(NSString *)cextendedminute startdate:(NSString *)cstartdate classtime:(NSString *)cclasstime instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom makeupattendance:(NSString *)cmakeupattendance makeupdate:(NSString *)cmakeupdate makeuptime:(NSString *)cmakeuptime makeupinstructor:(NSString *)cmakeupinstructor makeupclassroom:(NSString *)cmakeupclassroom remarks:(NSString *)cremarks allclassremarks:(NSString *)callclassremarks absentmakeupreason:(NSString *)cabsentmakeupreason parentnote:(NSString *)cparentnote request_status:(NSString *)crequest_status request_for_value:(NSString *)crequest_for_value request_for_leavenaturelistkey:(NSString *)crequest_for_leavenaturelistkey request_for_value_reason:(NSString *)crequest_for_value_reason request_for_date:(NSString *)crequest_for_date request_for_time:(NSString *)crequest_for_time leavenaturelistkey:(NSString *)cleavenaturelistkey
{
    
    self =[super init];
    if (self)
    {
        classtype=cclasstype;
        type=ctype;
        typekey=ctypekey;
        classtypekey=cclasstypekey;
        subject=csubject;
        attendance=cattendance;
        duration=cduration;
        extendedminute=cextendedminute;
        startdate=cstartdate;
        classtime=cclasstime;
        instructor=cinstructor;
        classroom=cclassroom;
        makeupattendance=cmakeupattendance;
        makeupdate=cmakeupdate;
        makeuptime=cmakeuptime;
        makeupinstructor=cmakeupinstructor;
        makeupclassroom=cmakeupclassroom;
        remarks=cremarks;
        allclassremarks=callclassremarks;
        absentmakeupreason=cabsentmakeupreason;
        parentnote=cparentnote;
        request_status=crequest_status;
        request_for_value=crequest_for_value;
        request_for_leavenaturelistkey=crequest_for_leavenaturelistkey;
        request_for_value_reason=crequest_for_value_reason;
        request_for_date=crequest_for_date;
        request_for_time=crequest_for_time;
        leavenaturelistkey=cleavenaturelistkey;
    }
    
    return self;
    
}

@end

@implementation EnrollmentRecord
@synthesize studentkey,enrollmentkey,enrollmentdate,schedulekey,subject,levelmain,levelctm,grade,startdate,noofclass,enddate,classday,classtime,instructor,enrollmentfee,tuitionfee,oneoffdiscount,recursivediscount,oneoffpercentagediscount,latefee,totalfee,paid,remarks,dropclassstatus,dropclassdate,draft,invoiceremarks,classroom,autorenew,status,reverseadjustment,instructorfullname,subjectfullname,validity,makeup_quota,makeup_quota_used,paymentrecords,promotiondiscountrecords,classrecords,sinstructor,transferredfromenrollmentkey,enrollmentmode,standardnoofclassormonth,couponrecords,invoicenumber,invoiceprefix,locked,billdate,resumeclassdate,outstandingmakeupclasses;

-(id)initEnrollmentWithstudentkey:(NSString *)cstudentkey andenrollmentkey:(NSString *)cenrollmentkey andenrollmentdate:(NSString *)cenrollmentdate andschedulekey:(NSString *)cschedulekey andsubject:(NSString *)csubject andlevelmain:(NSString *)clevelmain andlevelctm:(NSString *)clevelctm andgrade:(NSString *)cgrade andstartdate:(NSString *)cstartdate andnoofclass:(NSString *)cnoofclass andenddate:(NSString *)cenddate andclassday:(NSString *)cclassday andclasstime:(NSString *)cclasstime andinstructor:(NSString *)cinstructor andenrollmentfee:(NSString *)cenrollmentfee andtuitionfee:(NSString *)ctuitionfee andoneoffdiscount:(NSString *)coneoffdiscount andrecursivediscount:(NSString *)crecursivediscount andoneoffpercentagediscount:(NSString *)coneoffpercentagediscount andlatefee:(NSString *)clatefee andtotalfee:(NSString *)ctotalfee andpaid:(NSString *)cpaid anddropclassstatus:(NSString *)cdropclassstatus anddropclassdate:(NSString *)cdropclassdate andremarks:(NSString *)cremarks anddraft:(NSString *)cdraft andinvoiceremarks:(NSString *)cinvoiceremarks andclassroom:(NSString *)cclassroom andautorenew:(NSString *)cautorenew andstatus:(NSString *)cstatus andreverseadjustment:(NSString *)creverseadjustment instructorfullname:(NSString *)cinstructorfullname subjectfullname:(NSString *)csubjectfullname validity:(NSString *)cvalidity makeup_quota:(NSString *)cmakeup_quota makeup_quota_used:(NSString *)cmakeup_quota_used paymentrecords:(NSMutableArray *)cpaymentrecords promotiondiscountrecords:(NSMutableArray *)cpromotiondiscountrecords classrecords:(NSMutableArray *)cclassrecords sinstructor:(NSString *)csinstructor transferredfromenrollmentkey:(NSString *)ctransferredfromenrollmentkey enrollmentmode:(NSString *)cenrollmentmode standardnoofclassormonth:(NSString *)cstandardnoofclassormonth couponrecords:(NSMutableArray *)ccouponrecords invoicenumber:(NSString *)cinvoicenumber invoiceprefix:(NSString *)cinvoiceprefix locked:(BOOL)clocked billdate:(NSString *)cbilldate resumeclassdate:(NSString *)cresumeclassdate outstandingmakeupclasses:(NSString *)coutstandingmakeupclasses
{
    
    self =[super init];
    if (self)
    {
        studentkey=cstudentkey;
        enrollmentkey=cenrollmentkey;
        enrollmentdate=cenrollmentdate;
        schedulekey=cschedulekey;
        subject=csubject;
        levelmain=clevelmain;
        levelctm=clevelctm;
        grade=cgrade;
        startdate=cstartdate;
        noofclass=cnoofclass;
        startdate=cstartdate;
        classday=cclassday;
        enddate=cenddate;
        classtime=cclasstime;
        instructor=cinstructor;
        enrollmentfee=cenrollmentfee;
        tuitionfee=ctuitionfee;
        oneoffdiscount=coneoffdiscount;
        recursivediscount=crecursivediscount;
        oneoffpercentagediscount=coneoffpercentagediscount;
        latefee=clatefee;
        totalfee=ctotalfee;
        paid=cpaid;
        dropclassstatus=cdropclassstatus;
        dropclassdate=cdropclassdate;
        remarks=cremarks;
        draft=cdraft;
        invoiceremarks=cinvoiceremarks;
        classroom=cclassroom;
        autorenew=cautorenew;
        status=cstatus;
        reverseadjustment=creverseadjustment;
        instructorfullname=cinstructorfullname;
        subjectfullname=csubjectfullname;
        validity=cvalidity;
        makeup_quota=cmakeup_quota;
        makeup_quota_used=cmakeup_quota_used;
        paymentrecords=cpaymentrecords;
        promotiondiscountrecords=cpromotiondiscountrecords;
        classrecords=cclassrecords;
        sinstructor=csinstructor;
        transferredfromenrollmentkey=ctransferredfromenrollmentkey;
        enrollmentmode=cenrollmentmode;
        standardnoofclassormonth=cstandardnoofclassormonth;
        couponrecords=ccouponrecords;
        invoicenumber=cinvoicenumber;
        invoiceprefix=cinvoiceprefix;
        locked=clocked;
        billdate=cbilldate;
        resumeclassdate=cresumeclassdate;
        outstandingmakeupclasses=coutstandingmakeupclasses;
    }
    
    return self;
    
}

@end


@implementation RenewalRecord

@synthesize studentkey,enrollmentkey,studentfullname,classday,subject,classtime,levelmain,levelctm,remainingclass,remainingclassTBDmakeup,lastdate,renewalstartdate,schedulekey,remainingclassTBDclass,autorenew,coursetype;

-(id)initRenewalRecordWithstudentkey:(NSString *)cstudentkey andenrollmentkey:(NSString *)cenrollmentkey andstudentfullname:(NSString *)cstudentfullname andclassday:(NSString *)cclassday andsubject:(NSString *)csubject andclasstime:(NSString *)cclasstime andlevelmain:(NSString *)clevelmain andlevelctm:(NSString *)clevelctm andremainingclass:(NSString *)cremainingclass andremainingclassTBDmakeup:(NSString *)cremainingclassTBDmakeup andlastdate:(NSString *)clastdate andrenewalstartdate:(NSString *)crenewalstartdate andschedulekey:(NSString *)cschedulekey andremainingclassTBDclass:(NSString *)cremainingclassTBDclass andautorenew:(NSString *)cautorenew coursetype:(NSString *)ccoursetype
{
    
    self =[super init];
    if (self)
    {
        studentkey=cstudentkey;
        enrollmentkey=cenrollmentkey;
        studentfullname=cstudentfullname;
        classday=cclassday;
        subject=csubject;
        classtime=cclasstime;
        levelmain=clevelmain;
        levelctm=clevelctm;
        remainingclass=cremainingclass;
        remainingclassTBDmakeup=cremainingclassTBDmakeup;
        lastdate=clastdate;
        renewalstartdate=crenewalstartdate;
        schedulekey=cschedulekey;
        remainingclassTBDclass=cremainingclassTBDclass;
        autorenew=cautorenew;
        coursetype=ccoursetype;
    }
    return self;
    
}


@end

@implementation OutstandingPaymentRecord

@synthesize enrollmentkey,studentkey,studentfullname,enrollmentdate,subject,classday,classtime,startdate,enddate,noofclass,totalfee,paid,outstanding,parentcontact,gender,image,studentid,subjectfullname,lastpaymentkey;

-(id)initOutstandingPaymentRecordWithStudentkey: (NSString *)cstudentkey andenrollmentkey: (NSString *)cenrollmentkey andstudentfullname:(NSString *)cstudentfullname andenrollmentdate:(NSString *)cenrollmentdate andsubject: (NSString *)csubject andclassday:(NSString *)cclassday andclasstime:(NSString *)cclasstime andstartdate: (NSString *)cstartdate andenddate:(NSString *)cenddate andnoofclass:(NSString *)cnoofclass andtotalfee:(NSString *)ctotalfee andpaid:(NSString *)cpaid andoutstanding:(NSString *)coutstanding andparentcontact:(NSString *)cparentcontact andgender:(NSString *)cgender andimage:(NSString *)cimage andstudentid:(NSString *)cstudentid andsubjectfullname:(NSString *)csubjectfullname lastpaymentkey:(NSString *)clastpaymentkey
{
    
    self =[super init];
    if (self)
    {
        lastpaymentkey=clastpaymentkey;
        enrollmentkey=cenrollmentkey;
        studentkey=cstudentkey;
        studentfullname=cstudentfullname;
        enrollmentdate=cenrollmentdate;
        subject=csubject;
        classday=cclassday;
        classtime=cclasstime;
        startdate=cstartdate;
        enddate=cenddate;
        noofclass=cnoofclass;
        totalfee=ctotalfee;
        paid=cpaid;
        outstanding=coutstanding;
        parentcontact=cparentcontact;
        gender=cgender;
        image=cimage;
        subjectfullname=csubjectfullname;
        studentid=cstudentid;
        lastpaymentkey=clastpaymentkey;

    }
    return self;
    
}


@end

@implementation OutstandingSalesPaymentRecord

@synthesize saleskey,studentkey,studentfullname,orderdate,product,quantity,totalfee,paid,outstanding,parentcontact,gender,image,productfullname,studentid,lastpaymentkey;

-(id)initOutstandingSalesPaymentRecordWithSaleskey:(NSString *)csaleskey studentkey:(NSString *)cstudentkey orderdate:(NSString *)corderdate studentfullname:(NSString *)cstudentfullname product:(NSString *)cproduct quantity:(NSString *)cquantity totalfee:(NSString *)ctotalfee paid:(NSString *)cpaid outstanding:(NSString *)coutstanding parentcontact:(NSString *)cparentcontact andgender:(NSString *)cgender andimage:(NSString *)cimage andstudentid:(NSString *)cstudentid andproductfullname:(NSString *)cproductfullname lastpaymentkey:(NSString *)clastpaymentkey
{
    
    self =[super init];
    if (self)
    {
        saleskey=csaleskey;
        studentkey=cstudentkey;
        studentfullname=cstudentfullname;
        orderdate=corderdate;
        product=cproduct;
        quantity=cquantity;
        totalfee=ctotalfee;
        paid=cpaid;
        outstanding=coutstanding;
        parentcontact=cparentcontact;
        gender=cgender;
        image=cimage;
        productfullname=cproductfullname;
        studentid=cstudentid;
        lastpaymentkey=clastpaymentkey;
    }
    return self;
    
}


@end

@implementation OutstandingBankinRecord

@synthesize bankindatetime,newpaymentreceivedcash,newpaymentreceivedcheque,bankinamountcash,bankinamountcheque,outstandingbankincash,outstandingbankincheque,bankinperson,remarks;

-(id)initOutstandingBankinRecordWithbankindatetime:(NSString *)cbankindatetime newpaymentreceivedcash:(NSString *)cnewpaymentreceivedcash newpaymentreceivedcheque:(NSString *)cnewpaymentreceivedcheque bankinamountcash:(NSString *)cbankinamountcash bankinamountcheque:(NSString *)cbankinamountcheque outstandingbankincash:(NSString *)coutstandingbankincash outstandingbankincheque:(NSString *)coutstandingbankincheque bankinperson:(NSString *)cbankinperson remarks:(NSString *)cremarks;
{
    self =[super init];
    if (self)
    {
        bankindatetime=cbankindatetime;
        newpaymentreceivedcash=cnewpaymentreceivedcash;
        newpaymentreceivedcheque=cnewpaymentreceivedcheque;
        bankinamountcash=cbankinamountcash;
        bankinamountcheque=cbankinamountcheque;
        outstandingbankincash=coutstandingbankincash;
        outstandingbankincheque=coutstandingbankincheque;
        bankinperson=cbankinperson;
        remarks=cremarks;
    }
    return self;
}


@end

@implementation ClassTimeTableRecord
@synthesize startdate,classday,classtime,subject, instructor,classroom,studentarray;

-(id)initClassTimeTableRecordWithstartdate:(NSString *)cstartdate classday:(NSString *)cclassday classtime:(NSString *)cclasstime subject:(NSString *)csubject instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom studentarray:(NSMutableArray *)cstudentarray{
    
    self =[super init];
    if (self)
    {
        startdate=cstartdate;
        classday=cclassday;
        classtime=cclasstime;
        subject=csubject;
        instructor=cinstructor;
        classroom=cclassroom;
        studentarray=cstudentarray;
    }
    
    return self;
}

@end

@implementation ClassTimeTableRecord2
@synthesize startdate,classday,classtime,subject,instructor,classroom,studentkey,firstname,lastname,subjectfullname,instructorfullname;

-(id)initClassTimeTableRecordWithstartdate:(NSString *)cstartdate classday:(NSString *)cclassday classtime:(NSString *)cclasstime subject:(NSString *)csubject instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom studentkey:(NSString *)cstudentkey firstname:(NSString *)cfirstname lastname:(NSString *)clastname instructorfullname:(NSString *)cinstructorfullname subjectfullname:(NSString *)csubjectfullname
{
    self =[super init];
    if (self)
    {
        startdate=cstartdate;
        classday=cclassday;
        classtime=cclasstime;
        subject=csubject;
        instructor=cinstructor;
        classroom=cclassroom;
        studentkey=cstudentkey;
        firstname=cfirstname;
        lastname=clastname;
        instructorfullname=cinstructorfullname;
        subjectfullname=csubjectfullname;
    }
    return self;
}

@end

@implementation ClassTimeTableRecord3
@synthesize position,classday,classtime,subject,instructor,classroom,studentarray,classduration,subjectfullname,instructorfullname,timevaluearray,subjecttype,sinstructor,schedulekey;

-(id)initClassTimeTableRecord3Withclassday:(NSString *)cclassday classtime:(NSString *)cclasstime subject:(NSString *)csubject instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom classduration:(int)cclassduration studentarray:(NSMutableArray *)cstudentarray position:(int)cposition instructorfullname:(NSString *)cinstructorfullname subjectfullname:(NSString *)csubjectfullname timevaluearray:(NSMutableArray *)ctimevaluearray subjecttype:(NSString *)csubjecttype sinstructor:(NSString *)csinstructor schedulekey:(NSString *)cschedulekey
{
    
    self =[super init];
    if (self)
    {
        position=cposition;
        classday=cclassday;
        classtime=cclasstime;
        subject=csubject;
        instructor=cinstructor;
        classroom=cclassroom;
        studentarray=cstudentarray;
        classduration=cclassduration;
        instructorfullname=cinstructorfullname;
        subjectfullname=csubjectfullname;
        timevaluearray=ctimevaluearray;
        subjecttype=csubjecttype;
        sinstructor=csinstructor;
        schedulekey=cschedulekey;
    }
    return self;
}

@end

@implementation ClassTimeTableSubRecord
@synthesize classtype,type,typekey,attendance,levelmain,displayname,classkey,subject,outstanding,lesson;

-(id)initClassTimeTableSubRecordWithclasstype:(NSString *)cclasstype type:(NSString *)ctype typekey:(NSString *)ctypekey attendance:(NSString *)cattendance levelmain:(NSString *)clevelmain displayname:(NSString *)cdisplayname classkey:(NSString *)cclasskey subject:(NSString *)csubject outstanding:(NSString *)coutstanding lesson:(NSString *)clesson
{
    self =[super init];
    if (self)
    {
        classtype=cclasstype;
        type=ctype;
        typekey=ctypekey;
        attendance=cattendance;
        levelmain=clevelmain;
        displayname=cdisplayname;
        classkey=cclasskey;
        subject=csubject;
        outstanding=coutstanding;
        lesson=clesson;
    }
    return self;
}

@end

@implementation ClassScheduleRecord
@synthesize studentkey,enrollmentkey,classkey,dtkey, classtype,firstname,lastname,othername,gender,parentcontact,image,subject,levelmain,levelctm,startdate,classday,classtime,instructor,classroom,attendance,makeupattendance,makeupdate, makeuptime,remarks,allclassremarks,absentmakeupreason,makeupinstructor,makeupclassroom,firstclass,nextclassalldaytime,lastscheduledclassalldaytime,remainingclassscheduled,remainingclassTBDclass,remainingclassTBDmakeup,remainingclassscheduledall,outstandingpayment,classduration,type,instructorfullname,autorenew,schedulekey,outstandingextendtime,extendedminute,status,extensiontime,subjectfullname,studentid,parentnote,studentdisplayname,assessmentformcount,leavenaturelistkey,makeupquotaavailable,realclasstime,realclassroom,lesson,sinstructor,makeupsinstructor,sinstructorfullname,locked,enrollmentpaid;

-(id)initClassScheduleRecordWithstudentkey:(NSString *)cstudentkey andenrollmentkey:(NSString *)cenrollmentkey andclasskey:(NSString *)cclasskey anddtkey:(NSString *)cdtkey andclasstype:(NSString *)cclasstype andfirstname:(NSString *)cfirstname andlastname:(NSString *)clastname andothername:(NSString *)cothername andgender:(NSString *)cgender andparentcontact:(NSString *)cparentcontact andimage:(NSString *)cimage andsubject:(NSString *)csubject andlevelmain:(NSString *)clevelmain andlevelctm:(NSString *)clevelctm andstartdate:(NSString *)cstartdate andclassday:(NSString *)cclassday andclasstime:(NSString *)cclasstime andinstructor:(NSString *)cinstructor andclassroom:(NSString *)cclassroom andattendance:(NSString *)cattendance andmakeupattendance:(NSString *)cmakeupattendance andmakeupdate:(NSString *)cmakeupdate andmakeuptime:(NSString *)cmakeuptime andremarks:(NSString *)cremarks andallclassremarks:(NSString *)callclassremarks andmakeupinstructor:(NSString *)cmakeupinstructor andmakeupclassroom:(NSString *)cmakeupclassroom andabsentmakeupreason:(NSString *)cabsentmakeupreason andfirstclass:(NSString *)cfirstclass andnextclassalldaytime:(NSString *)cnextclassalldaytime andlastscheduledclassalldaytime:(NSString *)clastscheduledclassalldaytime andremainingclassscheduled:(NSString *)cremainingclassscheduled andremainingclassTBDclass:(NSString *)cremainingclassTBDclass andremainingclassTBDmakeup:(NSString *)cremainingclassTBDmakeup andremainingclassscheduledall:(NSString *)cremainingclassscheduledall andoutstandingpayment:(NSString *)coutstandingpayment andclassduration:(NSString *)cclassduration type:(NSString *)ctype instructorfullname:(NSString *)cinstructorfullname autorenew:(NSString *)cautorenew schedulekey:(NSString *)cschedulekey outstandingextendtime:(NSString *)coutstandingextendtime extendedminute:(NSString *)cextendedminute status:(NSString *)cstatus extensiontime:(NSString *)cextensiontime subjectfullname:(NSString *)csubjectfullname studentid:(NSString *)cstudentid parentnote:(NSString *)cparentnote studentdisplayname:(NSString *)cstudentdisplayname assessmentformcount:(int)cassessmentformcount leavenaturelistkey:(NSString *)cleavenaturelistkey makeupquotaavailable:(BOOL)cmakeupquotaavailable realclassroom:(NSString *)crealclassroom realclasstime:(NSString *)crealclasstime lesson:(NSString *)clesson sinstructor:(NSString *)csinstructor makeupsinstructor:(NSString *)cmakeupsinstructor sinstructorfullname:(NSString *)csinstructorfullname locked:(BOOL)clocked enrollmentpaid:(BOOL)cenrollmentpaid
{
    
    self =[super init];
    if (self)
    {
        studentkey=cstudentkey;
        enrollmentkey=cenrollmentkey;
        classkey=cclasskey;
        dtkey=cdtkey;
        classtype=cclasstype;
        firstname=cfirstname;
        lastname=clastname;
        othername=cothername;
        gender=cgender;
        parentcontact=cparentcontact;
        image=cimage;
        subject=csubject;
        levelmain=clevelmain;
        levelctm=clevelctm;
        startdate=cstartdate;
        classday=cclassday;
        classtime=cclasstime;
        instructor=cinstructor;
        classroom=cclassroom;
        attendance=cattendance;
        makeupattendance=cmakeupattendance;
        makeupdate=cmakeupdate;
        makeuptime=cmakeuptime;
        remarks=cremarks;
        allclassremarks=callclassremarks;
        makeupinstructor=cmakeupinstructor;
        makeupclassroom=cmakeupclassroom;
        absentmakeupreason=cabsentmakeupreason;
        firstclass=cfirstclass;
        nextclassalldaytime=cnextclassalldaytime;
        lastscheduledclassalldaytime=clastscheduledclassalldaytime;
        remainingclassscheduled=cremainingclassscheduled;
        remainingclassTBDclass=cremainingclassTBDclass;
        remainingclassTBDmakeup=cremainingclassTBDmakeup;
        remainingclassscheduledall=cremainingclassscheduledall;
        outstandingpayment=coutstandingpayment;
        classduration=cclassduration;
        type=ctype;
        instructorfullname=cinstructorfullname;
        autorenew=cautorenew;
        schedulekey=cschedulekey;
        outstandingextendtime=coutstandingextendtime;
        extendedminute=cextendedminute;
        status=cstatus;
        extensiontime=cextensiontime;
        subjectfullname=csubjectfullname;
        studentid=cstudentid;
        parentnote=cparentnote;
        studentdisplayname=cstudentdisplayname;
        assessmentformcount=cassessmentformcount;
        leavenaturelistkey=cleavenaturelistkey;
        makeupquotaavailable=cmakeupquotaavailable;
        realclasstime=crealclasstime;
        realclassroom=crealclassroom;
        lesson=clesson;
        sinstructor=csinstructor;
        makeupsinstructor=cmakeupsinstructor;
        sinstructorfullname=csinstructorfullname;
        locked=clocked;
        enrollmentpaid=cenrollmentpaid;
    }
    return self;
}

@end

@implementation DTRecord
@synthesize DTkey,DTstatus,DTdate,DTtime,subject,levelmain,levelctm,classduration,instructor,remarks,classtype,classroom,attendance,instructorfullname,subjectfullname,locked;

-(id) initDTRecordWithDTkey:(NSString *)cdtkey DTStatus:(NSString *)cdtstatus andDTdate:(NSString *)cdtdate andDTtime:(NSString *)cdttime andsubject:(NSString *)csubject andlevelmain:(NSString *)clevelmain andlevelctm:(NSString *)clevelctm andclassduration:(NSString *)cclassduration andinstructor:(NSString *)cinstructor andremarks:(NSString *)cremarks andclasstype:(NSString *)cclasstype andclassroom:(NSString *)cclassroom andattendance:(NSString *)cattendance andinstructorfullname:(NSString *)cinstructorfullname andsubjectfullname:(NSString *)csubjectfullname andlocked:(BOOL)clocked
{
    self=[super init];
    if (self) {
        DTkey=cdtkey;
        DTstatus=cdtstatus;
        DTdate=cdtdate;
        DTtime=cdttime;
        subject=csubject;
        levelmain=clevelmain;
        levelctm=clevelctm;
        classduration=cclassduration;
        instructor=cinstructor;
        remarks=cremarks;
        classtype=cclasstype;
        classroom=cclassroom;
        attendance=cattendance;
        instructorfullname=cinstructorfullname;
        subjectfullname=csubjectfullname;
        locked=clocked;
    }
    return self;
}
@end

@implementation AssessmentTrialRecord
@synthesize DTkey,type,leadkey,studentkey,firstname,lastname,othername,grade,gender,dateofbirth,age,school,parentname,parentcontact,parentemail,parentaddress,preferredlanguage,profileremarks,image,classtype,DTstatus,DTdate,DTtime,classduration,subject,levelmain,levelctm,instructor,remarks,media,source,classroom,attendance,studentfullname,instructorfullname,subjectfullname,iso_code,locked;

-(id) initAssessmentTrialRecordWithDTkey:(NSString *)cdtkey type:(NSString *)ctype leadkey:(NSString *)cleadkey studentkey:(NSString *)cstudentkey firstname:(NSString *)cfirstname lastname:(NSString *)clastname othername:(NSString *)cothername grade:(NSString *)cgrade gender:(NSString *)cgender dateofbirth:(NSString *)cdateofbirth age:(NSString *)cage school:(NSString *)cschool parentname:(NSString *)cparentname parentcontact:(NSString *)cparentcontact parentemail:(NSString *)cparentemail parentaddress:(NSString *)cparentaddress preferredlanguage:(NSString *)cpreferredlanguage profileremarks:(NSString *)cprofileremarks image:(NSString *)cimage classtype:(NSString *)cclasstype dtstatus:(NSString *)cdtstatus dtdate:(NSString *)cdtdate dttime:(NSString *)cdttime classduration:(NSString *)cclassduration subject:(NSString *)csubject levelmain:(NSString *)clevelmain levelctm:(NSString *)clevelctm instructor:(NSString *)cinstructor remarks:(NSString *)cremarks media:(NSString *)cmedia source:(NSString *)csource classroom:(NSString *)cclassroom attendance:(NSString *)cattendance studentfullname:(NSString *)cstudentfullname instructorfullname:(NSString *)cinstructorfullname subjectfullname:(NSString *)csubjectfullname iso_code:(NSString *)ciso_code locked:(BOOL)clocked
{
    self=[super init];
    if (self) {
        
        DTkey=cdtkey;
        type=ctype;
        leadkey=cleadkey;
        studentkey=cstudentkey;
        firstname=cfirstname;
        lastname=clastname;
        othername=cothername;
        grade=cgrade;
        gender=cgender;
        dateofbirth=cdateofbirth;
        age=cage;
        school=cschool;
        parentname=cparentname;
        parentcontact=cparentcontact;
        parentemail=cparentemail;
        parentaddress=cparentaddress;
        preferredlanguage=cpreferredlanguage;
        profileremarks=cprofileremarks;
        image=cimage;
        classtype=cclasstype;
        DTstatus=cdtstatus;
        DTdate=cdtdate;
        DTtime=cdttime;
        classduration=cclassduration;
        subject=csubject;
        levelmain=clevelmain;
        levelctm=clevelctm;
        instructor=cinstructor;
        remarks=cremarks;
        media=cmedia;
        source=csource;
        classroom=cclassroom;
        attendance=cattendance;
        studentfullname=cstudentfullname;
        instructorfullname=cinstructorfullname;
        subjectfullname=csubjectfullname;
        iso_code=ciso_code;
        locked=clocked;
    }
    return self;
}
@end


@implementation ClassfeeRecord
@synthesize classfeekey,subject,fee;

-(id)initClassfeeRecordwithClassfeeKey:(NSString *)cclassfeekey subject: (NSString *)csubject fee: (NSString *)cfee
{
    self=[super init];
    if (self) {
        classfeekey=cclassfeekey;
        subject=csubject;
        fee=cfee;

    }
    return self;
}


@end

@implementation PaymentRecord
@synthesize paymentkey,paymenttype,paymenttypekey,paiddate,paidmethod,paidamount,action,paymentremarks,receiptremarks,staffname,receiptnumber,receiptprefix;

-(id)initPaymentRecordwithPaymentkey:(NSString *)cpaymentkey paymenttype:(NSString *)cpaymenttype paymenttypekey:(NSString *)cpaymenttypekey paiddate:(NSString *)cpaiddate paidmethod:(NSString *)cpaidmethod paidamount:(NSString *)cpaidamount action:(NSString *)caction paymentremarks:(NSString *)cpaymentremarks receiptremarks:(NSString *)creceiptremarks staffname:(NSString *)cstaffname receiptnumber:(NSString *)creceiptnumber receiptprefix:(NSString *)creceiptprefix
{
    self=[super init];
    if (self) {
        paymentkey=cpaymentkey;
        paymenttype=cpaymenttype;
        paymenttypekey=cpaymenttypekey;
        paiddate=cpaiddate;
        paidmethod=cpaidmethod;
        paidamount=cpaidamount;
        action=caction;
        paymentremarks=cpaymentremarks;
        receiptremarks=creceiptremarks;
        staffname=cstaffname;
        receiptnumber=creceiptnumber;
        receiptprefix=creceiptprefix;
    }
    return self;
}
@end


@implementation TimeTableDetails
@synthesize timetablekey,type,classdate,classday,classtime,subtypevalue,block,caption,remarks;

-(id)initTimeTableDetailsWithtimetablekey:(NSString *)ctimetablekey type: (NSString *)ctype classdate: (NSString *)cclassdate classday:(NSString *)cclassday classtime:(NSString *)cclasstime subtypevalue:(NSString *)csubtypevalue block:(NSString *)cblock caption:(NSString *)ccaption remarks:(NSString *)cremarks ;
{
    self=[super init];
    if (self) {
        timetablekey=ctimetablekey;
        type=ctype;
        classdate=cclassdate;
        classday=cclassday;
        classtime=cclasstime;
        subtypevalue=csubtypevalue;
        block=cblock;
        caption=ccaption;
        remarks=cremarks;
        
    }
    return self;
}


@end

@implementation FreeScheduleClass
@synthesize classkey,subject,classdate,classtime,instructor,classroom,attendance,makeupdate,makeuptime,makeupinstructor,makeupclassroom,makeupattendance,classremarks,allclassremarks,action,classtype,leavenaturelistkey,lesson,sinstructor,makeupsinstructor,locked;

-(id)initFreeScheduleClassWithclasskey:(NSString *)cclasskey subject:(NSString *)csubject classdate:(NSString *)cclassdate classtime:(NSString *)cclasstime instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom attendance:(NSString *)cattendance makeupdate:(NSString *)cmakeupdate makeuptime:(NSString *)cmakeuptime makeupinstructor:(NSString *)cmakeupinstructor makeupclassroom:(NSString *)cmakeupclassroom makeupattendance:(NSString *)cmakeupattendance classremarks:(NSString *)cclassremarks allclassremarks:(NSString *)callclassremarks action:(NSString *)caction classtype:(NSString *)cclasstype leavenaturelistkey:(NSString *)cleavenaturelistkey lesson:(NSString *)clesson sinstructor:(NSString *)csinstructor makeupsinstructor:(NSString *)cmakeupsinstructor locked:(BOOL)clocked
{
    self=[super init];
    if (self) {
        classkey=cclasskey;
        subject=csubject;
        classdate=cclassdate;
        classtime=cclasstime;
        instructor=cinstructor;
        classroom=cclassroom;
        attendance=cattendance;
        makeupdate=cmakeupdate;
        makeuptime=cmakeuptime;
        makeupinstructor=cmakeupinstructor;
        makeupclassroom=cmakeupclassroom;
        makeupattendance=cmakeupattendance;
        classremarks=cclassremarks;
        allclassremarks=callclassremarks;
        action=caction;
        classtype=cclasstype;
        leavenaturelistkey=cleavenaturelistkey;
        lesson=clesson;
        sinstructor=csinstructor;
        makeupsinstructor=cmakeupsinstructor;
        locked=clocked;
    }
    return self;
}



@end






@implementation NotificationRecord
@synthesize recordtype,type,category,enrollmentkey,classkey,studentkey,studentname,subjectcode,productcode,subjectname,productname, classdatetime,value,schedulekey,image,gender,saleskey;

-(id)initNotificationRecordwithRecordtype:(NSString *)srecordtype Type:(NSString *)stype Category:(NSString *)scategory Enrollmentkey:(NSString *)senrollmentkey Saleskey:(NSString *)ssaleskey Classkey:(NSString *)sclasskey Studentkey:(NSString *)sstudentkey Studentname:(NSString *)sstudentname Subjectcode:(NSString *)ssubjectcode Productcode:(NSString *)sproductcode Subjectname:(NSString *)ssubjectname Productname:(NSString *)sproductname Classdatetime:(NSString *)sclassdatetime Value:(NSString *)svalue ScheduleKey:(NSString *)sschedulekey Image:(NSString *)simage Gender:(NSString *)sgender
{
    self =[super init];
    if (self)
    {
        recordtype=srecordtype;
        type=stype;
        category=scategory;
        enrollmentkey=senrollmentkey;
        saleskey=ssaleskey;
        classkey=sclasskey;
        studentkey=sstudentkey;
        studentname=sstudentname;
        subjectcode=ssubjectcode;
        productcode=sproductcode;
        subjectname=ssubjectname;
        productname=sproductname;
        classdatetime=sclassdatetime;
        value=svalue;
        schedulekey=sschedulekey;
        image=simage;
        gender=sgender;
    }
    
    return self;
    
}

@end


@implementation TaskRecord
@synthesize taskkey,createdatetime,assignedby,assignedto,assignedbyusername,assignedtousername,followupdatetime,taskname,remarks,status,action;

-(id)initTaskRecordwithTaskkey:(NSString *)staskkey Createdatetime:(NSString *)screatedatetime Assignedby:(NSString *)sassignedby Assignedto:(NSString *)sassignedto AssignedbyUsername:(NSString *)sassignedbyusername AssignedtoUsername:(NSString *)sassignedtousername Followupdatetime:(NSString *)sfollowupdatetime Taskname:(NSString *)staskname Remarks:(NSString *)sremarks Status:(NSString *)sstatus Action:(NSString *)saction;
{
    self =[super init];
    if (self)
    {
        taskkey=staskkey;
        createdatetime=screatedatetime;
        assignedby=sassignedby;
        assignedto=sassignedto;
        assignedbyusername=sassignedbyusername;
        assignedtousername=sassignedtousername;
        followupdatetime=sfollowupdatetime;
        taskname=staskname;
        remarks=sremarks;
        status=sstatus;
        action=saction;
    }
    
    return self;
    
}

@end

@implementation UserRecord
@synthesize userkey,firstname,lastname,username;

-(id)initUserRecordwithUserkey:(NSString *)suserkey Firstname:(NSString *)sfirstname Lastname:(NSString *)slastname Username:(NSString *)susername;
{
    self =[super init];
    if (self)
    {
        userkey=suserkey;
        firstname=sfirstname;
        lastname=slastname;
        username=susername;
    }
    
    return self;
    
}

@end

@implementation ClassSummaryRecord
@synthesize subject,nextclass,lastscheduledclass,remainingclassscheduled,remainingclassTBDclass,remainingclassTBDmakeup,outstandingpayment,schedulekey,autorenew,outstandingextendtime;

-(id)initClassSummaryRecordWithSubject:(NSString *)csubject NextClass:(NSString *)cnextclass lastscheduledclass:(NSString *)clastscheduledclass remainingclassscheduled:(NSString *)cremainingclassscheduled remainingclassTBDclass:(NSString *)cremainingclassTBDclass remainingclassTBDmakeup:(NSString *)cremainingclassTBDmakeup outstandingpayment:(NSString *)coutstandingpayment schedulekey:(NSString *)cschedulekey autorenew:(NSString *)cautorenew outstandingextendtime:(NSString *)coutstandingextendtime;
{
    
    self =[super init];
    if (self)
    {
        subject=csubject;
        nextclass=cnextclass;
        lastscheduledclass=clastscheduledclass;
        remainingclassscheduled=cremainingclassscheduled;
        remainingclassTBDclass=cremainingclassTBDclass;
        remainingclassTBDmakeup=cremainingclassTBDmakeup;
        outstandingpayment=coutstandingpayment;
        schedulekey=cschedulekey;
        autorenew=cautorenew;
        outstandingextendtime=coutstandingextendtime;
    }
    return self;
}


@end

@implementation MessageRecord
@synthesize messagereceipient,messagekey,messagetype,messageenglish,messagechinese,messagecreatetime,messagestarttime,messageendtime,messageexcludelist,automessageflag,studentkey,type,messagechannel,receiptienttype,notificationqueuedflag;

-(id)initMessageRecordwithMessageReceipient:(NSString *)smessagereceipient Messagekey:(NSString *)smessagekey Messagetype:(NSString *)smessagetype MessageEnglish:(NSString *)smessageenglish MessageChinese:(NSString *)smessagechinese MessageCreateTime:(NSString *)smessagecreatetime MessageStartTime:(NSString *)smessagestarttime MessageEndTime:(NSString *)smessageendtime MessageExcludeList:(NSString *)smessageexcludelist AutoMessageFlag:(NSString *)sautomessageflag Studentkey:(NSString *)sstudentkey Type:(NSString *)stype MessageChannel:(NSString *)smessagechannel ReceiptientType:(NSString *)sreceipienttype Notificationqueuedflag:(NSString *)cnotificationqueuedflag;
{
    self =[super init];
    if (self)
    {
        messagereceipient=smessagereceipient;
        messagekey=smessagekey;
        messagetype=smessagetype;
        messageenglish=smessageenglish;
        messagechinese=smessagechinese;
        messagecreatetime=smessagecreatetime;
        messagestarttime=smessagestarttime;
        messageendtime=smessageendtime;
        messageexcludelist=smessageexcludelist;
        automessageflag=sautomessageflag;
        studentkey=sstudentkey;
        type=stype;
        messagechannel=smessagechannel;
        receiptienttype=sreceipienttype;
        notificationqueuedflag=cnotificationqueuedflag;
    }
    
    return self;
    
}

@end



@implementation RecipientGroupRecord
@synthesize individualarray,subjectarray,instructorarray,classdatearray,gradearray,studentstatusarray,leadstatusarray,staffgrouparray,droparray,activearray,paymentstatusarray,productarray;

-(id)initRecipientGroupRecordwithIndividualArray:(NSMutableArray *)sindividualarray SubjectArray:(NSMutableArray *)ssubjectarray InstructorArray:(NSMutableArray *)sinstructorarray ClassDateArray:(NSMutableArray *)sclassdatearray GradeArray:(NSMutableArray *)sgradearray StudentStatusArray:(NSMutableArray *)sstudentstatusarray LeadStatusArray:(NSMutableArray *)sleadstatusarray StaffGroupArray:(NSMutableArray *)sstaffgrouparray DropArray:(NSMutableArray *)sdroparray ActiveArray:(NSMutableArray *)sactivearray paymentstatusarray:(NSMutableArray *)spaymentstatusarray productarray:(NSMutableArray *)sproductarray
{
    self =[super init];
    if (self)
    {
        individualarray=sindividualarray;
        subjectarray=ssubjectarray;
        instructorarray=sinstructorarray;
        classdatearray=sclassdatearray;
        gradearray=sgradearray;
        studentstatusarray=sstudentstatusarray;
        leadstatusarray=sleadstatusarray;
        staffgrouparray=sstaffgrouparray;
        droparray=sdroparray;
        activearray=sactivearray;
        paymentstatusarray=spaymentstatusarray;
        productarray=sproductarray;
    }
    
    return self;
    
}


@end

@implementation MessagePhotoRecord
@synthesize messagephotokey,messagephotourl,imageview,width,height,filetype,internalurl,filename,thumbnailurl;

-(id)initMessagePhotoRecordwithMessagePhotoKey:(NSString *)smessagephotokey MessagePhotoURL:(NSString *)smessagephotourl ImageView:(UIImageView *)simageview Width:(CGFloat)swidth Height:(CGFloat)sheight FileType:(NSString *)sfiletype InternalURL:(NSURL *)sinternalurl FileName:(NSString *)sfilename ThumbnailURL:(NSString *)sthumbnailurl
{
    self =[super init];
    if (self)
    {
        messagephotokey=smessagephotokey;
        messagephotourl=smessagephotourl;
        imageview=simageview;
        width=swidth;
        height=sheight;
        filetype=sfiletype;
        internalurl=sinternalurl;
        filename=sfilename;
        thumbnailurl=sthumbnailurl;
    }
    
    return self;
    
}

@end

@implementation OutboxMessageRecord
@synthesize outboxmessagekey,messagetype,messageenglish,messagechinese,messagecreatetime,messagestarttime,automessageflag,channel,recipienttype,status,recipientgroup,sender,photoarray,hotnews,hn_expiry_date,readstatus,composer;

-(id)initOutboxMessageRecordwithOutboxMessagekey:(NSString *)soutboxmessagekey Messagetype:(NSString *)smessagetype MessageEnglish:(NSString *)smessageenglish MessageChinese:(NSString *)smessagechinese MessageCreateTime:(NSString *)smessagecreatetime MessageStartTime:(NSString *)smessagestarttime AutoMessageFlag:(NSString *)sautomessageflag Channel:(NSString *)schannel ReciptientType:(NSString *)srecipienttype Status:(NSString *)sstatus RecipientGroup:(RecipientGroupRecord *)srecipientgroup Sender:(NSString *)ssender photoarray:(NSMutableArray *)sphotoarray hotnews:(BOOL)shotnews hn_expiry_date:(NSString *)shn_expiry_date readstatus:(NSString *)sreadstatus composer:(NSString *)scomposer
{
    self =[super init];
    if (self)
    {
        outboxmessagekey=soutboxmessagekey;
        messagetype=smessagetype;
        messageenglish=smessageenglish;
        messagechinese=smessagechinese;
        messagecreatetime=smessagecreatetime;
        messagestarttime=smessagestarttime;
        automessageflag=sautomessageflag;
        channel=schannel;
        recipienttype=srecipienttype;
        status=sstatus;
        recipientgroup=srecipientgroup;
        sender=ssender;
        photoarray=sphotoarray;
        hotnews=shotnews;
        hn_expiry_date=shn_expiry_date;
        readstatus=sreadstatus;
        composer=scomposer;
    }
    
    return self;
    
}

@end

@implementation InboxMessageRecord
@synthesize inboxmessagekey,messagetype,messageenglish,messagechinese,messagecreatetime,messagestarttime,automessageflag,channel,recipienttype,status,associateid,readtime,sender,photoarray,recipient,type,readstatus,readstatusdetailsarray,outboxmessagekey,replytomessagekey;

-(id)initInboxMessageRecordwithInboxMessagekey:(NSString *)sinboxmessagekey Messagetype:(NSString *)smessagetype MessageEnglish:(NSString *)smessageenglish MessageChinese:(NSString *)smessagechinese MessageCreateTime:(NSString *)smessagecreatetime MessageStartTime:(NSString *)smessagestarttime AutoMessageFlag:(NSString *)sautomessageflag Channel:(NSString *)schannel ReciptientType:(NSString *)srecipienttype Status:(NSString *)sstatus Sender:(NSString *)ssender AssociateID:(NSString *)sassociateid Readtime:(NSString *)sreadtime photoarray:(NSMutableArray *)sphotoarray recipient:(NSString *)srecipient outboxmessagekey:(NSString *)soutboxmessagekey type:(NSString *)stype readstatus:(NSString *)sreadstatus readstatusdetailsarray:(NSMutableArray *)sreadstatusdetailsarray replytomessagekey:(NSString *)sreplytomessagekey
{
    self =[super init];
    if (self)
    {
        inboxmessagekey=sinboxmessagekey;
        outboxmessagekey=soutboxmessagekey;
        messagetype=smessagetype;
        messageenglish=smessageenglish;
        messagechinese=smessagechinese;
        messagecreatetime=smessagecreatetime;
        messagestarttime=smessagestarttime;
        automessageflag=sautomessageflag;
        channel=schannel;
        recipienttype=srecipienttype;
        status=sstatus;
        associateid=sassociateid;
        readtime=sreadtime;
        sender=ssender;
        photoarray=sphotoarray;
        recipient=srecipient;
        type=stype;
        readstatus=sreadstatus;
        readstatusdetailsarray=sreadstatusdetailsarray;
        replytomessagekey=sreplytomessagekey;
    }
    
    return self;
    
}

@end

@implementation MessageContactRecord
@synthesize centerkey,messagecontact,messagetype,messagestarttime,unreadcount,attachmenttypes,readstatus,type,messagecontacttype,sender,recipient,channel,unreadcountsort,outboxmessagekey,messagechinese,messageenglish,messagecontactdisplayname;

-(id)initMessageContactRecordwithcenterkey:(NSString *)ccenterkey messagecontact:(NSString *)cmessagecontact messagetype:(NSString *)cmessagetype messagestarttime:(NSString *)cmessagestarttime unreadcount:(NSString *)cunreadcount attachmenttypes:(NSArray *)cattachmenttypes readstatus:(NSString *)creadstatus type:(NSString *)ctype messagecontacttype:(NSString *)cmessagecontacttype sender:(NSString *)csender recipient:(NSString *)crecipient channel:(NSString *)cchannel unreadcountsort:(NSString *)cunreadcountsort messageenglish:(NSString *)cmessageenglish messagechinese:(NSString *)cmessagechinese outboxmessagekey:(NSString *)coutboxmessagekey messagecontactdisplayname:(NSString *)cmessagecontactdisplayname
{
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        messagecontact=cmessagecontact;
        messagetype=cmessagetype;
        messagestarttime=cmessagestarttime;
        unreadcount=cunreadcount;
        attachmenttypes=cattachmenttypes;
        readstatus=creadstatus;
        type=ctype;
        messagecontacttype=cmessagecontacttype;
        sender=csender;
        recipient=crecipient;
        channel=cchannel;
        unreadcountsort=cunreadcountsort;
        messageenglish=cmessageenglish;
        messagechinese=cmessagechinese;
        messagecontactdisplayname=cmessagecontactdisplayname;
    }
    return self;
}

@end


@implementation ReadStatusRecord
@synthesize recipientid,recipientname,channel,readtime,image,gender,centerkey,recipientkey,contactgroup,relationship,iso_code;

-(id)initReadStatusRecordwithRecipientName:(NSString *)srecipientname RecipientID:(NSString *)srecipientid Channel:(NSString *)schannel ReadTime:(NSString *)sreadtime Image:(NSString *)simage Gender:(NSString *)sgender Centerkey:(NSString *)scenterkey Recipientkey:(NSString *)srecipientkey Contactgroup:(NSMutableArray *)scontactgroup Relationship:(NSString *)srelationship iso_code:(NSString *)siso_code
{
    self =[super init];
    if (self)
    {
        recipientname=srecipientname;
        recipientid=srecipientid;
        channel=schannel;
        readtime=sreadtime;
        image=simage;
        gender=sgender;
        centerkey=scenterkey;
        recipientkey=srecipientkey;
        contactgroup=scontactgroup;
        relationship=srelationship;
        iso_code=siso_code;
    }
    
    return self;
    
}

@end

@implementation PolicyRecord
@synthesize headingchinese,headingenglish,contentchinese,contentenglish;

-(id)initPolicyRecordwithHeadingEnglish:(NSString *)cheadingenglish HeadingChinese:(NSString *)cheadingchinese ContentEnglish:(NSString *)ccontentenglish ContentChinese:(NSString *)ccontentchinese
{
    
    self =[super init];
    if (self)
    {
        headingenglish=cheadingenglish;
        headingchinese=cheadingchinese;
        contentenglish=ccontentenglish;
        contentchinese=ccontentchinese;
    }
    return self;
}

@end

@implementation CenterRecord
@synthesize centerkey,entitykey,centername,centershortname_english,centershortname_chinese,classstarttime,classendtime,classtimeinterval,centeraddress,centeraddress_chinese,centercontact,centerfax,centerwhatsapp,centeremail,centerwebsite,centerothers,centerdb,centerhour_line1left,centerhour_line1right,centerhour_line2left,centerhour_line2right,centerhour_line3left,centerhour_line3right,centerhour_line1left_chinese,centerhour_line1right_chinese,centerhour_line2left_chinese,centerhour_line2right_chinese,centerhour_line3left_chinese,centerhour_line3right_chinese,launchimage_landscape,launchimage_portrait,shopfrontimage,mapimage,printlogoimage,chequepayable,enrollmentfee,latefee_enable,receipttnc,invoicetnc,defaulteditablepaymentamount,defaultattendancestatus,launchmessagemode,enableattendanceextend,renewmonthlyroundup,enableautobatchrenew,autobatchrenewdaystoinclude,monthlymodeweeklyscheduletuitiondenominator,defaultstudentgrade,noofroundoffdigit,enablestaffsalaryrate,enablescantotakeattendance,scantotakeattendanceafterthreshold,scantotakeattendancebeforethreshold,scantype,autofillstudentid,enableistafftakingattendance,latefee,latefeegraceperiod,iparentusercanupdatepersonalinformation,reservedcalendardate,autofillleadid,parentappdefault,studentpromotiondefault,leadpromotiondefault,studentassessmentform,enrollmentvalidity,iparentshowenrollmenttuitionfee,enrollmultiplesubjectsatsametimeslot,enablemakeup,autorenewal_date_for_monthlycourse,editmonthlycourseclassdate,iparentclassalert,enablemakeupquota,iparentleavemode,maxdayformakeup,mindaytoapplyleave,noofdayafteroriginalclassformakeup,noofpastdayincludediniparentclassschedule,smsdefault,iparentshowclassroom,standaloneparentappid,autosendereceipt,enableaccountreceivablecodes,iparentshowmessages,iparentshowphotocorner,iparentshowsalesrecords,iparentshowclassschedule,iparentshowenrollmentrecords,duepayment,showdiscountdetailsinreceipt,showdiscountdetailsininvoice,leaveapprovalmode,enableparentsendmessage,expiringclassreminderrecursiveday,expiringclassreminder,firstreminderbeforeexpiry,studentnamedisplayorder,showcontactindailyscheduleprintout,showduepaymentindailyscheduleprintout,defaultleadmessagechannel,defaultstudentmessagechannel,leadnamedisplayorder,scannerpoweroffcode,defaultreceiptremarksasinvoiceremarksforproductsales,defaultreceiptremarksasinvoiceremarksforcourseenrollment,invoicefontsize,tncfontsize_invoice,showlevelininvoice,receiptfontsize,tncfontsize_receipt,showlevelinreceipt,showstaffnameinreceipt,showvalidityininvoicereceipt,enablevideomessage,enableparentsendvideomessage,enablevoicemessage,enableparentsendvoicemessage,sendparentappinvitesms,ddaenabled,studentsendmessagedefault,printclassdatemode,enablelessonnumber,schoolregnumber,autosendeinvoice,showclassdatesininvoice,showclassdatesinreceipt,showlastpaymentonlyinreceipt,secondaryinstructor,iparentshowonlynondroppedenrollment,studentextrafield1,fullday,lessonnumbermode,markexpiredclassabsent,paymentmethods,updateclassafterschedulechange,standalonestaffappid,renewevenifthereistbdclass,ecoupon,consolidatestockcountformultipleaccountcodes,enablechatbot,enablemembershippoint,addpointwithactiveparentapp,spendingtopointratio,spendingtopointratio_sales,defaultpointexpirydays,maxdayrangefortrialclass,autoenrollmentfeeforfirstenrollment,couponexpiryfirstreminder,couponexpiryrecursivereminder,pointexpiryfirstreminder,pointexpiryrecursivereminder,addpointforonlinepaymentonly,addpointforontimepaymentonly,timetablefielddisplayorder,printclassdateendtime,skipmakeupforrenewal_prepare,transferpointforinternaltransferpayment,cloneenrollmentcopydiscountdefault,invoiceprefix,receiptprefix,iparentshowuserdefinedschedulename,pointearn_qrcodecheckin,icenterversioncheck,jumptonextlevelduringrenewal,iparentreturnrenewalremindernotifications,makeupdelayhour,parentappcolorschemekey,iparentshowclassendtime,showcenteraveragescore,sidprefix,staffcompetencyvalues,enablestaffcompetency,waiveenrollmentfeeminmonth,defaultcsshowintimetableifnoenrollment,defaultcsmakeupschedule,lockclassperiod,usereserveddayduringrenewal,usereserveddayduringenrollment,maplat,maplong,minstudentcontact,removecouponifnotpaidbeforeexpiry,markrenewalreserveddaytomakeup,centerhour_line4left,centerhour_line4right,centerhour_line4left_chinese,centerhour_line4right_chinese,centerhour_line5left,centerhour_line5right,centerhour_line5left_chinese,centerhour_line5right_chinese,markenrollmentreserveddaytomakeup,removeunpaidandexpiredpromotion,fcgroup,enablemembershiptier,tierspendinginterval,maxuploadfilesize,studentextrafield2,trialdelayhour,timetabletbdclassroomcolorcode,timetabletbdinstructorcolorcode,noofpastdayincludedinistaffmystudentclass,staffpasswordexpirationday,caneditmonthlycoursestartdate,attendance_qrcode_refresh_minute,center_qrcode_refresh_minute,autodropenrollmentday,licensetype,pointearn_selfmakeup,mark_noattendancetaking_to,eenrollmentformdest;

-(id)initCenterRecordwithCenterKey:(NSString *)ccenterkey EntityKey:(NSString *)centitykey CenterName:(NSString *)ccentername CenterShortNameEnglish:(NSString *)ccentershortname_english CenterShortNameChinese:(NSString *)ccentershortname_chinese ClassStartTime:(NSString *)cclassstarttime ClassEndTime:(NSString *)cclassendtime ClassTimeInterval:(NSString *)cclasstimeinterval CenterAddress:(NSString *)ccenteraddress CenterAddress_chinese:(NSString *)ccenteraddress_chinese CenterContact:(NSString *)ccentercontact CenterFax:(NSString *)ccenterfax CenterWhatsapp:(NSString *)ccenterwhatsapp CenterEmail:(NSString *)ccenteremail CenterWebsite:(NSString *)ccenterwebsite CenterOthers:(NSString *)ccenterothers CenterDB:(NSString *)ccenterdb Centerhour_line1left:(NSString *)ccenterhour_line1left Centerhour_line1right:(NSString *)ccenterhour_line1right Centerhour_line2left:(NSString *)ccenterhour_line2left Centerhour_line2right:(NSString *)ccenterhour_line2right Centerhour_line3left:(NSString *)ccenterhour_line3left Centerhour_line3right:(NSString *)ccenterhour_line3right Centerhour_line1left_chinese:(NSString *)ccenterhour_line1left_chinese Centerhour_line1right_chinese:(NSString *)ccenterhour_line1right_chinese Centerhour_line2left_chinese:(NSString *)ccenterhour_line2left_chinese Centerhour_line2right_chinese:(NSString *)ccenterhour_line2right_chinese Centerhour_line3left_chinese:(NSString *)ccenterhour_line3left_chinese Centerhour_line3right_chinese:(NSString *)ccenterhour_line3right_chinese launchimage_landscape:(NSString *)claunchimage_landscape launchimage_portrait:(NSString *)claunchimage_portrait shopfrontimage:(NSString *)cshopfrontimage mapimage:(NSString *)cmapimage printlogoimage:(NSString *)cprintlogoimage chequepayable:(NSString *)cchequepayable Enrollmentfee:(NSString *)cenrollmentfee LateFee_Enable:(NSString *)clatefee_enable receipttnc:(NSString *)creceipttnc invoicetnc:(NSString *)cinvoicetnc defaulteditablepaymentamount:(NSString *)cdefaulteditablepaymentamount defaultattendancestatus:(NSString *)cdefaultattendancestatus launchmessagemode:(NSString *)claunchmessagemode enableattendanceextend:(BOOL)cenableattendanceextend renewmonthlyroundup:(BOOL)crenewmonthlyroundup enableautobatchrenew:(BOOL)cenableautobatchrenew autobatchrenewdaystoinclude:(NSString *)cautobatchrenewdaystoinclude monthlymodeweeklyscheduletuitiondenominator:(int)cmonthlymodeweeklyscheduletuitiondenominator defaultstudentgrade:(NSString *)cdefaultstudentgrade noofroundoffdigit:(int)cnoofroundoffdigit enablestaffsalaryrate:(BOOL)cenablestaffsalaryrate enablescantotakeattendance:(BOOL)cenablescantotakeattendance scantottakeattendancebeforethreshold:(int)cscantottakeattendancebeforethreshold scantottakeattendanceafterthreshold:(int)cscantottakeattendanceafterthreshold scantype:(NSString *)cscantype autofillstudentid:(BOOL)cautofillstudentid enableistafftakingattendance:(BOOL)cenableistafftakingattendance latefee:(NSString *)clatefee latefeegraceperiod:(NSString *)clatefeegraceperiod iparentusercanupdatepersonalinformation:(BOOL)ciparentusercanupdatepersonalinformation reservedcalendardate:(BOOL)creservedcalendardate autofillleadid:(BOOL)cautofillleadid parentappdefault:(BOOL)cparentappdefault studentpromotiondefault:(BOOL)cstudentpromotiondefault leadpromotiondefault:(BOOL)cleadpromotiondefault studentassessmentform:(BOOL)cstudentassessmentform enrollmentvalidity:(BOOL)cenrollmentvalidity iparentshowenrollmenttuitionfee:(BOOL)ciparentshowenrollmenttuitionfee enrollmultiplesubjectsatsametimeslot:(BOOL)cenrollmultiplesubjectsatsametimeslot enablemakeup:(BOOL)cenablemakeup autorenewal_date_for_monthlycourse:(NSString *)cautorenewal_date_for_monthlycourse editmonthlycourseclassdate:(BOOL)ceditmonthlycourseclassdate iparentclassalert:(BOOL)ciparentclassalert iparentleavemode:(NSString *)ciparentleavemode enablemakeupquota:(BOOL)cenablemakeupquota mindaytoapplyleave:(NSInteger)cmindaytoapplyleave maxdayformakeup:(NSInteger)cmaxdayformakeup noofdayafteroriginalclassformakeup:(NSString *)cnoofdayafteroriginalclassformakeup noofpastdayincludediniparentclassschedule:(NSInteger)cnoofpastdayincludediniparentclassschedule smsdefault:(BOOL)csmsdefault iparentshowclassroom:(BOOL)ciparentshowclassroom standaloneparentappid:(NSString *)cstandaloneparentappid autosendereceipt:(BOOL)cautosendereceipt enableaccountreceivablecodes:(BOOL)cenableaccountreceivablecodes iparentshowclassschedule:(BOOL)ciparentshowclassschedule iparentshowmessages:(BOOL)ciparentshowmessages iparentshowphotocorner:(BOOL)ciparentshowphotocorner iparentshowenrollmentrecords:(BOOL)ciparentshowenrollmentrecords iparentshowsalesrecords:(BOOL)ciparentshowsalesrecords duepayment:(NSString *)cduepayment showdiscountdetailsinreceipt:(BOOL)cshowdiscountdetailsinreceipt showdiscountdetailsininvoice:(BOOL)cshowdiscountdetailsininvoice leaveapprovalmode:(NSString *)cleaveapprovalmode enableparentsendmessage:(BOOL)cenableparentsendmessage expiringclassreminder:(BOOL)cexpiringclassreminder firstreminderbeforeexpiry:(NSInteger)cfirstreminderbeforeexpiry expiringclassreminderrecursiveday:(NSInteger)cexpiringclassreminderrecursiveday studentnamedisplayorder:(NSMutableArray *)cstudentnamedisplayorder showcontactindailyscheduleprintout:(BOOL)cshowcontactindailyscheduleprintout showduepaymentindailyscheduleprintout:(BOOL)cshowduepaymentindailyscheduleprintout defaultstudentmessagechannel:(NSString *)cdefaultstudentmessagechannel defaultleadmessagechannel:(NSString *)cdefaultleadmessagechannel leadnamedisplayorder:(NSMutableArray *)cleadnamedisplayorder scannerpoweroffcode:(NSString *)cscannerpoweroffcode defaultreceiptremarksasinvoiceremarksforcourseenrollment:(BOOL)cdefaultreceiptremarksasinvoiceremarksforcourseenrollment defaultreceiptremarksasinvoiceremarksforproductsales:(BOOL)cdefaultreceiptremarksasinvoiceremarksforproductsales invoicefontsize:(NSInteger)cinvoicefontsize tncfontsize_invoice:(NSInteger)ctncfontsize_invoice showlevelininvoice:(BOOL)cshowlevelininvoice receiptfontsize:(NSInteger)creceiptfontsize tncfontsize_receipt:(NSInteger)ctncfontsize_receipt showlevelinreceipt:(BOOL)cshowlevelinreceipt showstaffnameinreceipt:(BOOL)cshowstaffnameinreceipt showvalidityininvoicereceipt:(BOOL)cshowvalidityininvoicereceipt enablevideomessage:(BOOL)cenablevideomessage enableparentsendvideomessage:(BOOL)cenableparentsendvideomessage enablevoicemessage:(BOOL)cenablevoicemessage enableparentsendvoicemessage:(BOOL)cenableparentsendvoicemessage sendparentappinvitesms:(BOOL)csendparentappinvitesms ddaenabled:(BOOL)cddaenabled studentsendmessagedefault:(BOOL)cstudentsendmessagedefault printclassdatemode:(NSString *)cprintclassdatemode enablelessonnumber:(BOOL)cenablelessonnumber schoolregnumber:(NSString *)cschoolregnumber autosendeinvoice:(BOOL)cautosendeinvoice showclassdatesinreceipt:(NSInteger)cshowclassdatesinreceipt showclassdatesininvoice:(NSInteger)cshowclassdatesininvoice showlastpaymentonlyinreceipt:(BOOL)cshowlastpaymentonlyinreceipt secondaryinstructor:(BOOL)csecondaryinstructor iparentshowonlynondroppedenrollment:(BOOL)ciparentshowonlynondroppedenrollment studentextrafield1:(BOOL)cstudentextrafield1 fullday:(BOOL)cfullday lessonnumbermode:(NSInteger)clessonnumbermode markexpiredclassabsent:(BOOL)cmarkexpiredclassabsent paymentmethods:(NSArray *)cpaymentmethods updateclassafterschedulechange:(BOOL)cupdateclassafterschedulechange standalonestaffappid:(NSString *)cstandalonestaffappid renewevenifthereistbdclass:(BOOL)crenewevenifthereistbdclass ecoupon:(BOOL)cecoupon consolidatestockcountformultipleaccountcodes:(BOOL)cconsolidatestockcountformultipleaccountcodes enablechatbot:(BOOL)cenablechatbot enablemembershippoint:(BOOL)cenablemembershippoint addpointwithactiveparentapp:(BOOL)caddpointwithactiveparentapp spendingtopointratio:(NSString *)cspendingtopointratio spendingtopointratio_sales:(NSString *)cspendingtopointratio_sales defaultpointexpirydays:(NSString *)cdefaultpointexpirydays maxdayrangefortrialclass:(NSInteger)cmaxdayrangefortrialclass autoenrollmentfeeforfirstenrollment:(BOOL)cautoenrollmentfeeforfirstenrollment couponexpiryfirstreminder:(NSInteger)ccouponexpiryfirstreminder couponexpiryrecursivereminder:(NSInteger)ccouponexpiryrecursivereminder pointexpiryfirstreminder:(NSInteger)cpointexpiryfirstreminder pointexpiryrecursivereminder:(NSInteger)cpointexpiryrecursivereminder addpointforonlinepaymentonly:(BOOL)caddpointforonlinepaymentonly addpointforontimepaymentonly:(BOOL)caddpointforontimepaymentonly timetablefielddisplayorder:(NSMutableArray *)ctimetablefielddisplayorder printclassdateendtime:(BOOL)cprintclassdateendtime skipmakeupforrenewal_prepare:(BOOL)cskipmakeupforrenewal_prepare transferpointforinternaltransferpayment:(BOOL)ctransferpointforinternaltransferpayment cloneenrollmentcopydiscountdefault:(BOOL)ccloneenrollmentcopydiscountdefault invoiceprefix:(NSString *)cinvoiceprefix receiptprefix:(NSString *)creceiptprefix iparentshowuserdefinedschedulename:(BOOL)ciparentshowuserdefinedschedulename pointearn_qrcodecheckin:(NSString *)cpointearn_qrcodecheckin icenterversioncheck:(BOOL)cicenterversioncheck jumptonextlevelduringrenewal:(BOOL)cjumptonextlevelduringrenewal iparentreturnrenewalremindernotifications:(BOOL)ciparentreturnrenewalremindernotifications makeupdelayhour:(NSInteger)cmakeupdelayhour parentappcolorschemekey:(NSInteger)cparentappcolorschemekey iparentshowclassendtime:(BOOL)ciparentshowclassendtime showcenteraveragescore:(BOOL)cshowcenteraveragescore sidprefix:(NSString *)csidprefix staffcompetencyvalues:(NSString *)cstaffcompetencyvalues enablestaffcompetency:(BOOL)cenablestaffcompetency waiveenrollmentfeeminmonth:(NSInteger)cwaiveenrollmentfeeminmonth defaultcsshowintimetableifnoenrollment:(BOOL)cdefaultcsshowintimetableifnoenrollment defaultcsmakeupschedule:(BOOL)cdefaultcsmakeupschedule lockclassperiod:(NSString *)clockclassperiod usereserveddayduringrenewal:(BOOL)cusereserveddayduringrenewal usereserveddayduringenrollment:(BOOL)cusereserveddayduringenrollment maplat:(NSString *)cmaplat maplong:(NSString *)cmaplong minstudentcontact:(NSInteger)cminstudentcontact removecouponifnotpaidbeforeexpiry:(BOOL)cremovecouponifnotpaidbeforeexpiry markrenewalreserveddaytomakeup:(BOOL)cmarkrenewalreserveddaytomakeup Centerhour_line4left:(NSString *)ccenterhour_line4left Centerhour_line4right:(NSString *)ccenterhour_line4right Centerhour_line5left:(NSString *)ccenterhour_line5left Centerhour_line5right:(NSString *)ccenterhour_line5right Centerhour_line4left_chinese:(NSString *)ccenterhour_line4left_chinese Centerhour_line4right_chinese:(NSString *)ccenterhour_line4right_chinese Centerhour_line5left_chinese:(NSString *)ccenterhour_line5left_chinese Centerhour_line5right_chinese:(NSString *)ccenterhour_line5right_chinese markenrollmentreserveddaytomakeup:(BOOL)cmarkenrollmentreserveddaytomakeup fcgroup:(NSString *)cfcgroup removeunpaidandexpiredpromotion:(BOOL)cremoveunpaidandexpiredpromotion enablemembershiptier:(BOOL)cenablemembershiptier tierspendinginterval:(NSInteger)ctierspendinginterval maxuploadfilesize:(NSInteger)cmaxuploadfilesize studentextrafield2:(NSString *)cstudentextrafield2 trialdelayhour:(NSInteger)ctrialdelayhour timetabletbdinstructorcolorcode:(NSInteger)ctimetabletbdinstructorcolorcode timetabletbdclassroomcolorcode:(NSInteger)ctimetabletbdclassroomcolorcode noofpastdayincludedinistaffmystudentclass:(NSInteger)cnoofpastdayincludedinistaffmystudentclass staffpasswordexpirationday:(NSString *)cstaffpasswordexpirationday caneditmonthlycoursestartdate:(BOOL)ccaneditmonthlycoursestartdate attendance_qrcode_refresh_minute:(NSString *)cattendance_qrcode_refresh_minute center_qrcode_refresh_minute:(NSString *)ccenter_qrcode_refresh_minute autodropenrollmentday:(NSString *)cautodropenrollmentday licensetype:(NSString *)clicensetype pointearn_selfmakeup:(NSString *)cpointearn_selfmakeup mark_noattendancetaking_to:(NSString *)cmark_noattendancetaking_to eenrollmentformdest:(NSString *)ceenrollmentformdest
{
    
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        entitykey=centitykey;
        centername=ccentername;
        centershortname_english=ccentershortname_english;
        centershortname_chinese=ccentershortname_chinese;
        classstarttime=cclassstarttime;
        classendtime=cclassendtime;
        classtimeinterval=cclasstimeinterval;
        centeraddress=ccenteraddress;
        centeraddress_chinese=ccenteraddress_chinese;
        centercontact=ccentercontact;
        centerfax=ccenterfax;
        centerwhatsapp=ccenterwhatsapp;
        centeremail=ccenteremail;
        centerwebsite=ccenterwebsite;
        centerothers=ccenterothers;
        centerdb=ccenterdb;
        centerhour_line1left=ccenterhour_line1left;
        centerhour_line1right=ccenterhour_line1right;
        centerhour_line2left=ccenterhour_line2left;
        centerhour_line2right=ccenterhour_line2right;
        centerhour_line3left=ccenterhour_line3left;
        centerhour_line3right=ccenterhour_line3right;
        centerhour_line4left=ccenterhour_line4left;
        centerhour_line4right=ccenterhour_line4right;
        centerhour_line5left=ccenterhour_line5left;
        centerhour_line5right=ccenterhour_line5right;
        launchimage_landscape=claunchimage_landscape;
        launchimage_portrait=claunchimage_portrait;
        centerhour_line1left_chinese=ccenterhour_line1left_chinese;
        centerhour_line1right_chinese=ccenterhour_line1right_chinese;
        centerhour_line2left_chinese=ccenterhour_line2left_chinese;
        centerhour_line2right_chinese=ccenterhour_line2right_chinese;
        centerhour_line3left_chinese=ccenterhour_line3left_chinese;
        centerhour_line3right_chinese=ccenterhour_line3right_chinese;
        centerhour_line4left_chinese=ccenterhour_line4left_chinese;
        centerhour_line4right_chinese=ccenterhour_line4right_chinese;
        centerhour_line5left_chinese=ccenterhour_line5left_chinese;
        centerhour_line5right_chinese=ccenterhour_line5right_chinese;
        shopfrontimage=cshopfrontimage;
        mapimage=cmapimage;
        printlogoimage=cprintlogoimage;
        chequepayable=cchequepayable;
        enrollmentfee=cenrollmentfee;
        latefee_enable=clatefee_enable;
        receipttnc=creceipttnc;
        invoicetnc=cinvoicetnc;
        defaulteditablepaymentamount=cdefaulteditablepaymentamount;
        defaultattendancestatus=cdefaultattendancestatus;
        launchmessagemode=claunchmessagemode;
        enableattendanceextend=cenableattendanceextend;
        renewmonthlyroundup=crenewmonthlyroundup;
        enableautobatchrenew=cenableautobatchrenew;
        autobatchrenewdaystoinclude=cautobatchrenewdaystoinclude;
        monthlymodeweeklyscheduletuitiondenominator=cmonthlymodeweeklyscheduletuitiondenominator;
        defaultstudentgrade=cdefaultstudentgrade;
        noofroundoffdigit=cnoofroundoffdigit;
        enablestaffsalaryrate=cenablestaffsalaryrate;
        enablescantotakeattendance=cenablescantotakeattendance;
        scantotakeattendancebeforethreshold=cscantottakeattendancebeforethreshold;
        scantotakeattendanceafterthreshold=cscantottakeattendanceafterthreshold;
        scantype=cscantype;
        autofillstudentid=cautofillstudentid;
        enableistafftakingattendance=cenableistafftakingattendance;
        latefee=clatefee;
        latefeegraceperiod=clatefeegraceperiod;
        iparentusercanupdatepersonalinformation=ciparentusercanupdatepersonalinformation;
        reservedcalendardate=creservedcalendardate;
        autofillleadid=cautofillleadid;
        parentappdefault=cparentappdefault;
        studentpromotiondefault=cstudentpromotiondefault;
        leadpromotiondefault=cleadpromotiondefault;
        studentassessmentform=cstudentassessmentform;
        enrollmentvalidity=cenrollmentvalidity;
        iparentshowenrollmenttuitionfee=ciparentshowenrollmenttuitionfee;
        enrollmultiplesubjectsatsametimeslot=cenrollmultiplesubjectsatsametimeslot;
        enablemakeup=cenablemakeup;
        autorenewal_date_for_monthlycourse=cautorenewal_date_for_monthlycourse;
        editmonthlycourseclassdate=ceditmonthlycourseclassdate;
        iparentclassalert=ciparentclassalert;
        iparentleavemode=ciparentleavemode;
        enablemakeupquota=cenablemakeupquota;
        mindaytoapplyleave=cmindaytoapplyleave;
        maxdayformakeup=cmaxdayformakeup;
        noofdayafteroriginalclassformakeup=cnoofdayafteroriginalclassformakeup;
        noofpastdayincludediniparentclassschedule=cnoofpastdayincludediniparentclassschedule;
        smsdefault=csmsdefault;
        iparentshowclassroom=ciparentshowclassroom;
        standaloneparentappid=cstandaloneparentappid;
        autosendereceipt=cautosendereceipt;
        enableaccountreceivablecodes=cenableaccountreceivablecodes;
        iparentshowclassschedule=ciparentshowclassschedule;
        iparentshowmessages=ciparentshowmessages;
        iparentshowphotocorner=ciparentshowphotocorner;
        iparentshowenrollmentrecords=ciparentshowenrollmentrecords;
        iparentshowsalesrecords=ciparentshowsalesrecords;
        duepayment=cduepayment;
        showdiscountdetailsininvoice=cshowdiscountdetailsininvoice;
        showdiscountdetailsinreceipt=cshowdiscountdetailsinreceipt;
        leaveapprovalmode=cleaveapprovalmode;
        enableparentsendmessage=cenableparentsendmessage;
        firstreminderbeforeexpiry=cfirstreminderbeforeexpiry;
        expiringclassreminder=cexpiringclassreminder;
        expiringclassreminderrecursiveday=cexpiringclassreminderrecursiveday;
        studentnamedisplayorder=cstudentnamedisplayorder;
        showcontactindailyscheduleprintout=cshowcontactindailyscheduleprintout;
        showduepaymentindailyscheduleprintout=cshowduepaymentindailyscheduleprintout;
        defaultstudentmessagechannel=cdefaultstudentmessagechannel;
        defaultleadmessagechannel=cdefaultleadmessagechannel;
        leadnamedisplayorder=cleadnamedisplayorder;
        scannerpoweroffcode=cscannerpoweroffcode;
        defaultreceiptremarksasinvoiceremarksforcourseenrollment=cdefaultreceiptremarksasinvoiceremarksforcourseenrollment;
        defaultreceiptremarksasinvoiceremarksforproductsales=cdefaultreceiptremarksasinvoiceremarksforproductsales;
        invoicefontsize=cinvoicefontsize;
        receiptfontsize=creceiptfontsize;
        tncfontsize_receipt=ctncfontsize_receipt;
        tncfontsize_invoice=ctncfontsize_invoice;
        showlevelininvoice=cshowlevelininvoice;
        showlevelinreceipt=cshowlevelinreceipt;
        showstaffnameinreceipt=cshowstaffnameinreceipt;
        showvalidityininvoicereceipt=cshowvalidityininvoicereceipt;
        enablevideomessage=cenablevideomessage;
        enableparentsendvideomessage=cenableparentsendvideomessage;
        enablevoicemessage=cenablevoicemessage;
        enableparentsendvoicemessage=cenableparentsendvoicemessage;
        sendparentappinvitesms=csendparentappinvitesms;
        ddaenabled=cddaenabled;
        studentsendmessagedefault=cstudentsendmessagedefault;
        printclassdatemode=cprintclassdatemode;
        enablelessonnumber=cenablelessonnumber;
        schoolregnumber=cschoolregnumber;
        autosendeinvoice=cautosendeinvoice;
        showclassdatesinreceipt=cshowclassdatesinreceipt;
        showclassdatesininvoice=cshowclassdatesininvoice;
        showlastpaymentonlyinreceipt=cshowlastpaymentonlyinreceipt;
        secondaryinstructor=csecondaryinstructor;
        iparentshowonlynondroppedenrollment=ciparentshowonlynondroppedenrollment;
        studentextrafield1=cstudentextrafield1;
        fullday=cfullday;
        lessonnumbermode=clessonnumbermode;
        markexpiredclassabsent=cmarkexpiredclassabsent;
        paymentmethods=cpaymentmethods;
        updateclassafterschedulechange=cupdateclassafterschedulechange;
        standalonestaffappid=cstandalonestaffappid;
        renewevenifthereistbdclass=crenewevenifthereistbdclass;
        ecoupon=cecoupon;
        consolidatestockcountformultipleaccountcodes=cconsolidatestockcountformultipleaccountcodes;
        enablechatbot=cenablechatbot;
        enablemembershippoint=cenablemembershippoint;
        addpointwithactiveparentapp=caddpointwithactiveparentapp;
        spendingtopointratio=cspendingtopointratio;
        spendingtopointratio_sales=cspendingtopointratio_sales;
        defaultpointexpirydays=cdefaultpointexpirydays;
        maxdayrangefortrialclass=cmaxdayrangefortrialclass;
        autoenrollmentfeeforfirstenrollment=cautoenrollmentfeeforfirstenrollment;
        couponexpiryfirstreminder=ccouponexpiryfirstreminder;
        couponexpiryrecursivereminder=ccouponexpiryrecursivereminder;
        pointexpiryfirstreminder=cpointexpiryfirstreminder;
        pointexpiryrecursivereminder=cpointexpiryrecursivereminder;
        addpointforonlinepaymentonly=caddpointforonlinepaymentonly;
        addpointforontimepaymentonly=caddpointforontimepaymentonly;
        timetablefielddisplayorder=ctimetablefielddisplayorder;
        printclassdateendtime=cprintclassdateendtime;
        skipmakeupforrenewal_prepare=cskipmakeupforrenewal_prepare;
        transferpointforinternaltransferpayment=ctransferpointforinternaltransferpayment;
        cloneenrollmentcopydiscountdefault=ccloneenrollmentcopydiscountdefault;
        invoiceprefix=cinvoiceprefix;
        receiptprefix=creceiptprefix;
        iparentshowuserdefinedschedulename=ciparentshowuserdefinedschedulename;
        pointearn_qrcodecheckin=cpointearn_qrcodecheckin;
        icenterversioncheck=cicenterversioncheck;
        jumptonextlevelduringrenewal=cjumptonextlevelduringrenewal;
        iparentreturnrenewalremindernotifications=ciparentreturnrenewalremindernotifications;
        makeupdelayhour=cmakeupdelayhour;
        parentappcolorschemekey=cparentappcolorschemekey;
        iparentshowclassendtime=ciparentshowclassendtime;
        showcenteraveragescore=cshowcenteraveragescore;
        sidprefix=csidprefix;
        staffcompetencyvalues=cstaffcompetencyvalues;
        enablestaffcompetency=cenablestaffcompetency;
        waiveenrollmentfeeminmonth=cwaiveenrollmentfeeminmonth;
        defaultcsshowintimetableifnoenrollment=cdefaultcsshowintimetableifnoenrollment;
        defaultcsmakeupschedule=cdefaultcsmakeupschedule;
        lockclassperiod=clockclassperiod;
        usereserveddayduringrenewal=cusereserveddayduringrenewal;
        usereserveddayduringenrollment=cusereserveddayduringenrollment;
        maplat=cmaplat;
        maplong=cmaplong;
        minstudentcontact=cminstudentcontact;
        removecouponifnotpaidbeforeexpiry=cremovecouponifnotpaidbeforeexpiry;
        markrenewalreserveddaytomakeup=cmarkrenewalreserveddaytomakeup;
        markenrollmentreserveddaytomakeup=cmarkenrollmentreserveddaytomakeup;
        fcgroup=cfcgroup;
        removeunpaidandexpiredpromotion=cremoveunpaidandexpiredpromotion;
        enablemembershiptier=cenablemembershiptier;
        tierspendinginterval=ctierspendinginterval;
        maxuploadfilesize=cmaxuploadfilesize;
        studentextrafield2=cstudentextrafield2;
        trialdelayhour=ctrialdelayhour;
        timetabletbdclassroomcolorcode=ctimetabletbdclassroomcolorcode;
        timetabletbdinstructorcolorcode=ctimetabletbdinstructorcolorcode;
        noofpastdayincludedinistaffmystudentclass=cnoofpastdayincludedinistaffmystudentclass;
        staffpasswordexpirationday=cstaffpasswordexpirationday;
        caneditmonthlycoursestartdate=ccaneditmonthlycoursestartdate;
        attendance_qrcode_refresh_minute=cattendance_qrcode_refresh_minute;
        center_qrcode_refresh_minute=ccenter_qrcode_refresh_minute;
        autodropenrollmentday=cautodropenrollmentday;
        licensetype=clicensetype;
        pointearn_selfmakeup=cpointearn_selfmakeup;
        mark_noattendancetaking_to=cmark_noattendancetaking_to;
        eenrollmentformdest=ceenrollmentformdest;
    }
    return self;
}

@end

@implementation CenterSettings
@synthesize centerkey,fcbrand,grade,skipmakeupforrenewal,presentalert,absentalert,makeupalert,photoalert;

-(id)initCenterSettingswithCenterkey:(NSString *)ccenterkey FCBrand:(NSString *)cfcbrand Grade:(NSString *)cgrade skipmakeupforrenewal:(BOOL)cskipmakeupforrenewal presentalert:(BOOL)cpresentalert absentalert:(BOOL)cabsentalert makeupalert:(BOOL)cmakeupalert photoalert:(BOOL)cphotoalert

{
    
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        fcbrand=cfcbrand;
        grade=cgrade;
        skipmakeupforrenewal=cskipmakeupforrenewal;
        presentalert=cpresentalert;
        absentalert=cabsentalert;
        makeupalert=cmakeupalert;
        photoalert=cphotoalert;
    }
    return self;
}

@end

@implementation GlobalSettings
@synthesize startupserver,latestappversion,latestappurl,broadcastmessagemode,broadcastmessageenglish,broadcastmessagechinese;

-(id) initGlobalSettingswithStartupServer:(NSString *)cstartupserver LatestAppVersion:(NSString *)clatestappversion LatestAppUrl:(NSString *)clatestappurl BroadcastMessageMode:(NSString *)cbroadcastmessagemode BroadcastMessageEnglish:(NSString *)cbroadcastmessageenglish BroadcastMessageChinese:(NSString *)cbroadcastmessagechinese
{
    
    self =[super init];
    if (self)
    {
        startupserver=cstartupserver;
        latestappversion=clatestappversion;
        latestappurl=clatestappurl;
        broadcastmessagemode=cbroadcastmessagemode;
        broadcastmessageenglish=cbroadcastmessageenglish;
        broadcastmessagechinese=cbroadcastmessagechinese;
    }
    return self;
}

@end



@implementation TuitionRecord
@synthesize subject_shortname,method,scale,tuitionfee,newtuitionfee,effectivedate;

-(id)initTuitionRecordwithSubject_Shortname:(NSString *)csubject_shortname Method:(NSString *)cmethod Scale:(NSString *)cscale TuitionFee:(NSString *)ctuitionfee newtuitionfee:(NSString *)cnewtuitionfee effectivedate:(NSString *)ceffectivedate
{
    
    self =[super init];
    if (self)
    {
        subject_shortname=csubject_shortname;
        method=cmethod;
        scale=cscale;
        tuitionfee=ctuitionfee;
        newtuitionfee=cnewtuitionfee;
        effectivedate=ceffectivedate;
    }
    return self;
}

@end

@implementation LevelRecord
@synthesize level,earlieststartdate;

-(id)initLevelRecordwithLevel:(NSString *)clevel earlieststartdate:(NSString *)cearlieststartdate
{
    
    self =[super init];
    if (self)
    {
        level=clevel;
        earlieststartdate=cearlieststartdate;
    }
    return self;
}

@end

@implementation MaxLevelRecord
@synthesize subject,levelctm,levelmain;

-(id)initMaxLevelRecordwithSubject:(NSString *)csubject LevelMain:(NSString *)clevelmain LevelCTM:(NSString *)clevelctm;
{
    
    self =[super init];
    if (self)
    {
        subject=csubject;
        levelmain=clevelmain;
        levelctm=clevelctm;
    }
    return self;
}

@end

@implementation LastLevelRecord
@synthesize date,levelctm,levelmain;

-(id)initLastLevelRecordwithDate:(NSDate *)cdate LevelMain:(NSString *)clevelmain LevelCTM:(NSString *)clevelctm;
{
    
    self =[super init];
    if (self)
    {
        date=cdate;
        levelmain=clevelmain;
        levelctm=clevelctm;
    }
    return self;
}

@end


@implementation AllClassRemarksRecord
@synthesize subject,allclassremarks;

-(id) initMaxLevelRecordwithSubject:(NSString *)csubject AllClassRemarks:(NSString *)callclassremarks
{
    
    self =[super init];
    if (self)
    {
        subject=csubject;
        allclassremarks=callclassremarks;
    }
    return self;
}

@end


@implementation CategoryCountRecord
@synthesize type,count;

-(id) initCategoryCountRecordwithType:(NSString *)ctype Count:(NSString *)ccount;
{
    
    self =[super init];
    if (self)
    {
        type=ctype;
        count=ccount;
    }
    return self;
}

@end

@implementation SubjectRecord
@synthesize centerkey,subjectkey,subject_englishname,subject_chinesename,subject_shortname,enrollmentmode,tuition_method,tuition_mode,studentcapacity,standardnoofclassormonth,classduration, classduration_assessment,classduration_trial, status, levelArray,tuitionArray,remarks,scheduleArray,subject_category,weeklyautorenewdefault,validity,makeup_quota_value,makeup_quota_unit,leaveday_by_classdate,leaveday_by_makeupschedule,leaveday_follow_teacher,leaveday_by_enrolledschedule,leaveday_by_staffschedule,leaveday_follow_level,colorcode,fcsubject,lessonnumberDict,leaveday_follow_lesson,leaveday_follow_category,allowsameschedule,subject_fulldescription,publishinchatbot,chatbot_category,chatbot_tag1,subject_image,trial_by_existinglesson,trial_by_definedschedule,trialcapacity,chatbot_enabletrial,showmakeupbuttonifnotimeslot,btspromotioncode831,btspromotioncode1031,showabsentbuttononarrangeleave,pregenperiodcount,autolevelupgrade;

-(id) initSubjectRecordwithCenterkey:(NSString *)ccenterkey Subjectkey:(NSString *)csubjectkey Subject_Englishname:(NSString *)csubject_englishname Subject_Chinesename:(NSString *)csubject_chinesename Subject_shortname:(NSString *)csubject_shortname Enrollmentmode:(NSString *)cenrollmentmode Tuition_method:(NSString *)ctuition_method Tuition_mode:(NSString *)ctuition_mode Studentcapacity:(NSString *)cstudentcapacity StandardNoOfClassOrMonth:(NSString *)cstandardnoofclassormonth ClassDuration:(NSString *)cclassduration ClassDurationAssessment:(NSString *)cclassdurationassessment ClassDurationTrial:(NSString *)cclassdurationtrial Status:(NSString *)cstatus LevelArray:(NSMutableArray *)clevelArray TuitionArray:(NSMutableArray *)ctuitionArray Remarks:(NSString *)cremarks ScheduleArray:(NSMutableArray *)cschedulearray Subject_Category:(NSString *)csubject_category WeeklyAutoRenewDefault:(BOOL)cweeklyautorenewdefault validity:(NSString *)cvalidity makeup_quota_unit:(NSString *)cmakeup_quota_unit makeup_quota_value:(NSString *)cmakeup_quota_value leaveday_by_makeupschedule:(BOOL)cleaveday_by_makeupschedule leaveday_by_classdate:(BOOL)cleaveday_by_classdate leaveday_follow_teacher:(BOOL)cleaveday_follow_teacher leaveday_by_enrolledschedule:(BOOL)cleaveday_by_enrolledschedule leaveday_by_staffschedule:(BOOL)cleaveday_by_staffschedule leaveday_follow_level:(BOOL)cleaveday_follow_level leaveday_follow_lesson:(BOOL)cleaveday_follow_lesson colorcode:(NSInteger)scolorcode fcsubject:(NSString *)cfcsubject lessonnumberDict:(NSMutableDictionary *)clessonnumberDict leaveday_follow_category:(BOOL)cleaveday_follow_category allowsameschedule:(BOOL)callowsameschedule subject_fulldescription:(NSString *)csubject_fulldescription subject_image:(NSString *)csubject_image publishinchatbot:(BOOL)cpublishinchatbot chatbot_category:(NSString *)cchatbot_category chatbot_tag1:(NSString *)cchatbot_tag1 trial_by_existinglesson:(BOOL)ctrial_by_existinglesson trial_by_definedschedule:(BOOL)ctrial_by_definedschedule trialcapacity:(NSString *)ctrialcapacity chatbot_enabletrial:(BOOL)cchatbot_enabletrial showmakeupbuttonifnotimeslot:(BOOL)cshowmakeupbuttonifnotimeslot btspromotioncode831:(NSString *)cbtspromotioncode831 btspromotioncode1031:(NSString *)cbtspromotioncode1031 showabsentbuttononarrangeleave:(BOOL)cshowabsentbuttononarrangeleave pregenperiodcount:(NSInteger)cpregenperiodcount autolevelupgrade:(NSString *)cautolevelupgrade
{
    
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        subjectkey=csubjectkey;
        subject_chinesename=csubject_chinesename;
        subject_englishname=csubject_englishname;
        subject_shortname=csubject_shortname;
        enrollmentmode=cenrollmentmode;
        tuition_method=ctuition_method;
        tuition_mode=ctuition_mode;
        studentcapacity=cstudentcapacity;
        standardnoofclassormonth=cstandardnoofclassormonth;
        classduration=cclassduration;
        classduration_assessment=cclassdurationassessment;
        classduration_trial=cclassdurationtrial;
        status=cstatus;
        levelArray=clevelArray;
        tuitionArray=ctuitionArray;
        remarks=cremarks;
        scheduleArray=cschedulearray;
        subject_category=csubject_category;
        weeklyautorenewdefault=cweeklyautorenewdefault;
        validity=cvalidity;
        makeup_quota_value=cmakeup_quota_value;
        makeup_quota_unit=cmakeup_quota_unit;
        leaveday_by_makeupschedule=cleaveday_by_makeupschedule;
        leaveday_by_classdate=cleaveday_by_classdate;
        leaveday_follow_teacher=cleaveday_follow_teacher;
        leaveday_by_enrolledschedule=cleaveday_by_enrolledschedule;
        leaveday_by_staffschedule=cleaveday_by_staffschedule;
        leaveday_follow_level=cleaveday_follow_level;
        colorcode=scolorcode;
        fcsubject=cfcsubject;
        lessonnumberDict=clessonnumberDict;
        leaveday_follow_lesson=cleaveday_follow_lesson;
        leaveday_follow_category=cleaveday_follow_category;
        allowsameschedule=callowsameschedule;
        subject_image=csubject_image;
        subject_fulldescription=csubject_fulldescription;
        publishinchatbot=cpublishinchatbot;
        chatbot_category=cchatbot_category;
        chatbot_tag1=cchatbot_tag1;
        trial_by_existinglesson=ctrial_by_existinglesson;
        trial_by_definedschedule=ctrial_by_definedschedule;
        trialcapacity=ctrialcapacity;
        chatbot_enabletrial=cchatbot_enabletrial;
        showmakeupbuttonifnotimeslot=cshowmakeupbuttonifnotimeslot;
        btspromotioncode831=cbtspromotioncode831;
        btspromotioncode1031=cbtspromotioncode1031;
        showabsentbuttononarrangeleave=cshowabsentbuttononarrangeleave;
        pregenperiodcount=cpregenperiodcount;
        autolevelupgrade=cautolevelupgrade;
    }
    return self;
}

@end



@implementation ProductRecord
@synthesize centerkey,productkey,category,englishname,chinesename,code,price,status,remarks,autorenew,avatar,alertthreshold,stockcount,allstockcounts;

-(id) initProductRecordwithCenterkey:(NSString *)ccenterkey Productkey:(NSString *)cproductkey Category:(NSString *)ccategory Englishname:(NSString *)cenglishname Chinesename:(NSString *)cchinesename Code:(NSString *)ccode Price:(NSString *)cprice Status:(NSString *)cstatus Remarks:(NSString *)cremarks Autorenew:(NSString *)cautorenew avatar:(NSString *)cavatar stockCount:(NSString *)cstockcount alertThreshold:(NSString *)calertthreshold allstockcounts:(NSString *)callstockcounts
{
    
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        productkey=cproductkey;
        category=ccategory;
        chinesename=cchinesename;
        englishname=cenglishname;
        code=ccode;
        price=cprice;
        status=cstatus;
        remarks=cremarks;
        autorenew=cautorenew;
        avatar=cavatar;
        alertthreshold=calertthreshold;
        stockcount=cstockcount;
        allstockcounts=callstockcounts;
    }
    return self;
}

@end

@implementation SalesRecord
@synthesize saleskey,studentkey,orderdate,productfullname,productcode,productcategory,price,quantity,oneoffdiscount,oneoffpercentagediscount,paid,total,remarks,invoiceremarks,status,reverseadjustment,autorenew,paymentrecords,promotiondiscountrecords,givenout,couponrecords,invoicenumber,invoiceprefix;

-(id) initSalesRecordWithstudentkey:(NSString *)cstudentkey saleskey:(NSString *)csaleskey orderdate:(NSString *)corderdate productfullname:(NSString *)cproductfullname productcode:(NSString *)cproductcode productcategory:(NSString *)cproductcategory price:(NSString *)cprice quantity:(NSString *)cquantity oneoffdiscount:(NSString *)coneoffdiscount oneoffpercentagediscount:(NSString *)coneoffpercentagediscount paid:(NSString *)cpaid total:(NSString *)ctotal remarks:(NSString *)cremarks invoiceremarks:(NSString *)cinvoiceremarks status:(NSString *)cstatus reverseadjustment:(NSString *)creverseadjustment autorenew:(NSString *)cautorenew paymentrecords:(NSMutableArray *)cpaymentrecords promotiondiscountrecords:(NSMutableArray *)cpromotiondiscountrecords givenout:(NSString *)cgivenout couponrecords:(NSMutableArray *)ccouponrecords invoicenumber:(NSString *)cinvoicenumber invoiceprefix:(NSString *)cinvoiceprefix
{
    
    self =[super init];
    if (self)
    {
        saleskey=csaleskey;
        studentkey=cstudentkey;
        orderdate=corderdate;
        productfullname=cproductfullname;
        productcode=cproductcode;
        productcategory=cproductcategory;
        price=cprice;
        quantity=cquantity;
        oneoffdiscount=coneoffdiscount;
        oneoffpercentagediscount=coneoffpercentagediscount;
        paid=cpaid;
        total=ctotal;
        remarks=cremarks;
        invoiceremarks=cinvoiceremarks;
        status=cstatus;
        reverseadjustment=creverseadjustment;
        paymentrecords=cpaymentrecords;
        promotiondiscountrecords=cpromotiondiscountrecords;
        autorenew=cautorenew;
        givenout=cgivenout;
        couponrecords=ccouponrecords;
        invoicenumber=cinvoicenumber;
        invoiceprefix=cinvoiceprefix;
    }
    return self;
}

@end



@implementation LicenseRecord
@synthesize appname,licensedcount,usedcount,remainingcount;

-(id) initLicenseRecordWithappname:(NSString *)cappname licensecount:(NSString *)clicensecount usedcount:(NSString *)cusedcount remainingcont:(NSString *)cremainingcount
{
    
    self =[super init];
    if (self)
    {
        appname=cappname;
        licensedcount=clicensecount;
        usedcount=cusedcount;
        remainingcount=cremainingcount;

    }
    return self;
}

@end

@implementation DeviceRecord
@synthesize userdevicekey,stafforstudentname,deviceidentifier,devicename,deviceos,deviceversion,lastlogin,stafforstudentkey,appname,usertokenkey,contact,relationship;

-(id)initDeviceRecordWithuserdevicekey:(NSString *)cuserdevicekey stafforstudentname:(NSString *)cstafforstudentname  deviceidentifier:(NSString *)cdeviceidentifier devicename:(NSString *)cdevicename deviceos:(NSString *)cdeviceos deviceversion:(NSString *)cdeviceversion lastlogin:(NSString *)clastlogin stafforstudentkey:(NSString *)cstafforstudentkey appname:(NSString *)cappname usertokenkey:(NSString *)cusertokenkey contact:(NSString *)ccontact relationship:(NSString *)crelationship
{
    self =[super init];
    if (self)
    {
        userdevicekey=cuserdevicekey;
        stafforstudentname=cstafforstudentname;
        deviceidentifier=cdeviceidentifier;
        devicename=cdevicename;
        deviceos=cdeviceos;
        deviceversion=cdeviceversion;
        lastlogin=clastlogin;
        stafforstudentkey=cstafforstudentkey;
        appname=cappname;
        usertokenkey=cuserdevicekey;
        relationship=crelationship;
        contact=ccontact;
    }
    return self;
}

@end

@implementation TabRecord
@synthesize tabid,headerlistarray,mode,selecteddate;

-(id)initTabRecordWithtabid:(NSString *)ctabid headerlistarray:(NSMutableArray *)cheaderlistarray mode:(NSString *)cmode selecteddate:(NSString *)cselecteddate
{
    self =[super init];
    if (self)
    {
        tabid=ctabid;
        headerlistarray=cheaderlistarray;
        mode=cmode;
        selecteddate=cselecteddate;
    }
    return self;
}

@end

@implementation ClassReceiptRecord
@synthesize studentkey,studentname,studentid,preferredlanguage,parentemail,enrollmentkey,enrollmentdate,tuitionfee,enrollmentfee,latefee,discount,totalfee,subject_shortname,startdate,noofclass,enddate,classtime,classday,levelmain,paymentkey,paiddate,paid,paidmethod,totalpaid,staffname,receiptremarks,image,checkstatus,validity,enrollmentrecord,paymentremarks,subjectname;

-(id)initClassReceiptRecordWithstudentkey:(NSString *)cstudentkey studentname:(NSString *)cstudentname studentid:(NSString *)cstudentid parentemail:(NSString *)cparentemail preferredlanguage:(NSString *)cpreferredlanguage enrollmentkey:(NSString *)cenrollmentkey enrollmentdate:(NSString *)cenrollmentdate tuitionfee:(NSString *)ctuitionfee enrollmentfee:(NSString *)cenrollmentfee latefee:(NSString *)clatefee discount:(NSString *)cdiscount totalfee:(NSString *)ctotalfee subject_shortname:(NSString *)csubject_shortname startdate:(NSString *)cstartdate noofclass:(NSString *)cnoofclass enddate:(NSString *)cenddate classtime:(NSString *)cclasstime classday:(NSString *)cclassday levelmain:(NSString *)clevelmain paymentkey:(NSString *)cpaymentkey paiddate:(NSString *)cpaiddate paid:(NSString *)cpaid paidmethod:(NSString *)cpaidmethod totalpaid:(NSString *)ctotalpaid staffname:(NSString *)cstaffname receiptremarks:(NSString *)creceiptremarks image:(NSString *)cimage checkstatus:(NSString *)ccheckstatus validity:(NSString *)cvalidity enrollmentrecord:(EnrollmentRecord *)cenrollmentrecord paymentremarks:(NSString *)cpaymentremarks subjectname:(NSString *)csubjectname
{
    self =[super init];
    if (self)
    {
        studentkey=cstudentkey;
        studentname=cstudentname;
        studentid=cstudentid;
        parentemail=cparentemail;
        preferredlanguage=cpreferredlanguage;
        enrollmentkey=cenrollmentkey;
        enrollmentdate=cenrollmentdate;
        tuitionfee=ctuitionfee;
        enrollmentfee=cenrollmentfee;
        latefee=clatefee;
        discount=cdiscount;
        totalfee=ctotalfee;
        subject_shortname=csubject_shortname;
        startdate=cstartdate;
        noofclass=cnoofclass;
        enddate=cenddate;
        classtime=cclasstime;
        classday=cclassday;
        levelmain=clevelmain;
        paymentkey=cpaymentkey;
        paiddate=cpaiddate;
        paid=cpaid;
        paidmethod=cpaidmethod;
        totalpaid=ctotalpaid;
        staffname=cstaffname;
        receiptremarks=creceiptremarks;
        image=cimage;
        checkstatus=ccheckstatus;
        validity=cvalidity;
        enrollmentrecord=cenrollmentrecord;
        paymentremarks=cpaymentremarks;
        subjectname=csubjectname;
    }
    return self;
}

@end

@implementation SalesReceiptRecord
@synthesize studentkey,studentname,studentid,parentemail,preferredlanguage,saleskey,orderdate,price,discount,totalfee,productcode,quantity,paymentkey,paiddate,paid,paidmethod,totalpaid,staffname,receiptremarks,image,checkstatus,salesrecord,paymentremarks,productname;

-(id)initSalesReceiptRecordWithstudentkey:(NSString *)cstudentkey studentname:(NSString *)cstudentname studentid:(NSString *)cstudentid parentemail:(NSString *)cparentemail preferredlanguage:(NSString *)cpreferredlanguage saleskey:(NSString *)csaleskey orderdate:(NSString *)corderdate price:(NSString *)cprice discount:(NSString *)cdiscount totalfee:(NSString *)ctotalfee productcode:(NSString *)cproductcode quantity:(NSString *)cquantity paymentkey:(NSString *)cpaymentkey paiddate:(NSString *)cpaiddate paid:(NSString *)cpaid paidmethod:(NSString *)cpaidmethod totalpaid:(NSString *)ctotalpaid staffname:(NSString *)cstaffname receiptremarks:(NSString *)creceiptremarks image:(NSString *)cimage checkstatus:(NSString *)ccheckstatus salesrecord:(SalesRecord *)csalesrecord paymentremarks:(NSString *)cpaymentremarks productname:(NSString *)cproductname
{
    self =[super init];
    if (self)
    {
        studentkey=cstudentkey;
        studentname=cstudentname;
        studentid=cstudentid;
        parentemail=cparentemail;
        preferredlanguage=cpreferredlanguage;
        saleskey=csaleskey;
        orderdate=corderdate;
        price=cprice;
        discount=cdiscount;
        totalfee=ctotalfee;
        productcode=cproductcode;
        quantity=cquantity;
        paymentkey=cpaymentkey;
        paiddate=cpaiddate;
        paid=cpaid;
        paidmethod=cpaidmethod;
        totalpaid=ctotalpaid;
        staffname=cstaffname;
        receiptremarks=creceiptremarks;
        image=cimage;
        checkstatus=ccheckstatus;
        salesrecord=csalesrecord;
        paymentremarks=cpaymentremarks;
        productname=cproductname;
    }
    return self;
}

@end

@implementation ClassInvoiceRecord
@synthesize studentkey,studentname,studentid,parentemail,preferredlanguage,enrollmentkey,enrollmentdate,tuitionfee,enrollmentfee,latefee,discount,totalfee,subject_shortname,startdate,noofclass,enddate,classtime,classday,levelmain,outstandingamount,invoiceremarks,image,checkstatus,validity,enrollmentrecord,subjectname;

-(id)initClassInvoiceRecordWithstudentkey:(NSString *)cstudentkey studentname:(NSString *)cstudentname studentid:(NSString *)cstudentid parentemail:(NSString *)cparentemail preferredlanguage:(NSString *)cpreferredlanguage enrollmentkey:(NSString *)cenrollmentkey enrollmentdate:(NSString *)cenrollmentdate tuitionfee:(NSString *)ctuitionfee enrollmentfee:(NSString *)cenrollmentfee latefee:(NSString *)clatefee discount:(NSString *)cdiscount totalfee:(NSString *)ctotalfee subject_shortname:(NSString *)csubject_shortname startdate:(NSString *)cstartdate noofclass:(NSString *)cnoofclass enddate:(NSString *)cenddate classtime:(NSString *)cclasstime classday:(NSString *)cclassday levelmain:(NSString *)clevelmain outstandingamount:(NSString *)coutstandingamount invoiceremarks:(NSString *)cinvoiceremarks image:(NSString *)cimage checkstatus:(NSString *)ccheckstatus validity:(NSString *)cvalidity enrollmentrecord:(EnrollmentRecord *)cenrollmentrecord subjectname:(NSString *)csubjectname
{
    self =[super init];
    if (self)
    {
        studentkey=cstudentkey;
        studentname=cstudentname;
        studentid=cstudentid;
        parentemail=cparentemail;
        preferredlanguage=cpreferredlanguage;
        enrollmentkey=cenrollmentkey;
        enrollmentdate=cenrollmentdate;
        tuitionfee=ctuitionfee;
        enrollmentfee=cenrollmentfee;
        latefee=clatefee;
        discount=cdiscount;
        totalfee=ctotalfee;
        subject_shortname=csubject_shortname;
        startdate=cstartdate;
        noofclass=cnoofclass;
        enddate=cenddate;
        classtime=cclasstime;
        classday=cclassday;
        levelmain=clevelmain;
        outstandingamount=coutstandingamount;
        invoiceremarks=cinvoiceremarks;
        image=cimage;
        checkstatus=ccheckstatus;
        validity=cvalidity;
        enrollmentrecord=cenrollmentrecord;
        subjectname=csubjectname;
    }
    return self;
}

@end

@implementation SalesInvoiceRecord
@synthesize studentkey,studentname,studentid,parentemail,preferredlanguage,saleskey,orderdate,price,discount,totalfee,productcode,quantity,outstandingamount,invoiceremarks,image,checkstatus,salesrecord,productname;

-(id)initSalesInvoiceRecordWithstudentkey:(NSString *)cstudentkey studentname:(NSString *)cstudentname studentid:(NSString *)cstudentid parentemail:(NSString *)cparentemail preferredlanguage:(NSString *)cpreferredlanguage saleskey:(NSString *)csaleskey orderdate:(NSString *)corderdate price:(NSString *)cprice discount:(NSString *)cdiscount totalfee:(NSString *)ctotalfee productcode:(NSString *)cproductcode quantity:(NSString *)cquantity outstandingamount:(NSString *)coutstandingamount invoiceremarks:(NSString *)cinvoiceremarks image:(NSString *)cimage checkstatus:(NSString *)ccheckstatus salesrecord:(SalesRecord *)csalesrecord productname:(NSString *)cproductname
{
    self =[super init];
    if (self)
    {
        studentkey=cstudentkey;
        studentname=cstudentname;
        studentid=cstudentid;
        parentemail=cparentemail;
        preferredlanguage=cpreferredlanguage;
        saleskey=csaleskey;
        orderdate=corderdate;
        price=cprice;
        discount=cdiscount;
        totalfee=ctotalfee;
        productcode=cproductcode;
        quantity=cquantity;
        outstandingamount=coutstandingamount;
        invoiceremarks=cinvoiceremarks;
        image=cimage;
        checkstatus=ccheckstatus;
        salesrecord=csalesrecord;
        productname=cproductname;
    }
    return self;
}

@end

@implementation ClassPaymentRecord
@synthesize studentkey,studentname,studentid,parentemail,preferredlanguage,enrollmentkey,enrollmentdate,tuitionfee,totalfee,subject_shortname,startdate,noofclass,enddate,classtime,classday,levelmain,outstandingamount,image,paidamount,paidmethod,receiptremarks,paymentremarks,paiddate,checkstatus,enrollmentrecord;

-(id)initClassPaymentRecordWithstudentkey:(NSString *)cstudentkey studentname:(NSString *)cstudentname studentid:(NSString *)cstudentid parentemail:(NSString *)cparentemail preferredlanguage:(NSString *)cpreferredlanguage enrollmentkey:(NSString *)cenrollmentkey enrollmentdate:(NSString *)cenrollmentdate tuitionfee:(NSString *)ctuitionfee totalfee:(NSString *)ctotalfee subject_shortname:(NSString *)csubject_shortname startdate:(NSString *)cstartdate noofclass:(NSString *)cnoofclass enddate:(NSString *)cenddate classtime:(NSString *)cclasstime classday:(NSString *)cclassday levelmain:(NSString *)clevelmain outstandingamount:(NSString *)coutstandingamount image:(NSString *)cimage paidamount:(NSString *)cpaidamount paidmethod:(NSString *)cpaidmethod paymentremarks:(NSString *)cpaymentremarks receiptremarks:(NSString *)creceiptremarks paiddate:(NSString *)cpaiddate checkstatus:(NSString *)ccheckstatus enrollmentrecord:(EnrollmentRecord *)cenrollmentrecord
{
    self =[super init];
    if (self)
    {
        studentkey=cstudentkey;
        studentname=cstudentname;
        studentid=cstudentid;
        parentemail=cparentemail;
        preferredlanguage=cpreferredlanguage;
        enrollmentkey=cenrollmentkey;
        enrollmentdate=cenrollmentdate;
        tuitionfee=ctuitionfee;
        totalfee=ctotalfee;
        subject_shortname=csubject_shortname;
        startdate=cstartdate;
        noofclass=cnoofclass;
        enddate=cenddate;
        classtime=cclasstime;
        classday=cclassday;
        levelmain=clevelmain;
        outstandingamount=coutstandingamount;
        image=cimage;
        paidamount=cpaidamount;
        paidmethod=cpaidmethod;
        receiptremarks=creceiptremarks;
        paymentremarks=cpaymentremarks;
        paiddate=cpaiddate;
        checkstatus=ccheckstatus;
        enrollmentrecord=cenrollmentrecord;
    }
    return self;
}

@end

@implementation SalesPaymentRecord
@synthesize studentkey,studentname,studentid,parentemail,preferredlanguage,saleskey,orderdate,price,totalfee,productcode,quantity,outstandingamount,image,paidamount,paidmethod,receiptremarks,paymentremarks,paiddate,checkstatus,salesrecord;

-(id)initSalesPaymentRecordWithstudentkey:(NSString *)cstudentkey studentname:(NSString *)cstudentname studentid:(NSString *)cstudentid parentemail:(NSString *)cparentemail preferredlanguage:(NSString *)cpreferredlanguage saleskey:(NSString *)csaleskey orderdate:(NSString *)corderdate price:(NSString *)cprice totalfee:(NSString *)ctotalfee productcode:(NSString *)cproductcode quantity:(NSString *)cquantity outstandingamount:(NSString *)coutstandingamount image:(NSString *)cimage paidamount:(NSString *)cpaidamount paidmethod:(NSString *)cpaidmethod paymentremarks:(NSString *)cpaymentremarks receiptremarks:(NSString *)creceiptremarks paiddate:(NSString *)cpaiddate checkstatus:(NSString *)ccheckstatus salesrecord:(SalesRecord *)csalesrecord
{
    self =[super init];
    if (self)
    {
        studentkey=cstudentkey;
        studentname=cstudentname;
        studentid=cstudentid;
        parentemail=cparentemail;
        preferredlanguage=cpreferredlanguage;
        saleskey=csaleskey;
        orderdate=corderdate;
        price=cprice;
        totalfee=ctotalfee;
        productcode=cproductcode;
        quantity=cquantity;
        outstandingamount=coutstandingamount;
        image=cimage;
        paidamount=cpaidamount;
        paidmethod=cpaidmethod;
        receiptremarks=creceiptremarks;
        paymentremarks=cpaymentremarks;
        paiddate=cpaiddate;
        checkstatus=ccheckstatus;
        salesrecord=csalesrecord;
    }
    return self;
}

@end




@implementation DocumentFolder
@synthesize classinvoicearray,classreceiptarray,salesinvoicearray,salesreceiptarray,classpaymentarray,salespaymentarray,defaultcheckedsalesinvoicesaleskeys,defaultcheckedsalespaymentsaleskeys,defaultcheckedclassreceiptenrollmentkeys,defaultcheckedsalesreceiptsaleskeys,defaultcheckedclassinvoiceenrollmentkeys,defaultcheckedclasspaymentenrollmentkeys;

-(id)initDocumentFolderWithClassInvoiceArray:(NSMutableArray *)cclassinvoicearray ClassReceiptArray:(NSMutableArray *)cclassreceiptarray SalesInvoiceArray:(NSMutableArray *)csalesinvoicearray SalesReceiptArray:(NSMutableArray *)csalesreceiptarray ClassPaymentArray:(NSMutableArray *)cclasspaymentarray SalesPaymentArray:(NSMutableArray *)csalespaymentarray defaultcheckedclassinvoiceenrollmentkeys:(NSMutableArray *)cdefaultcheckedclassinvoiceenrollmentkeys defaultcheckedclasspaymentenrollmentkeys:(NSMutableArray *)cdefaultcheckedclasspaymentenrollmentkeys defaultcheckedsalesinvoicesaleskeys:(NSMutableArray *)cdefaultcheckedsalesinvoicesaleskeys defaultcheckedsalespaymentsaleskeys:(NSMutableArray *)cdefaultcheckedsalespaymentsaleskeys defaultcheckedclassreceiptenrollmentkeys:(NSMutableArray *)cdefaultcheckedclassreceiptenrollmentkeys defaultcheckedsalesreceiptsaleskeys:(NSMutableArray *)cdefaultcheckedsalesreceiptsaleskeys
{
    self =[super init];
    if (self)
    {
        classinvoicearray=cclassinvoicearray;
        classreceiptarray=cclassreceiptarray;
        salesinvoicearray=csalesinvoicearray;
        salesreceiptarray=csalesreceiptarray;
        classpaymentarray=cclasspaymentarray;
        salespaymentarray=csalespaymentarray;
        defaultcheckedclasspaymentenrollmentkeys=cdefaultcheckedclasspaymentenrollmentkeys;
        defaultcheckedsalespaymentsaleskeys=cdefaultcheckedsalespaymentsaleskeys;
        defaultcheckedclassinvoiceenrollmentkeys=cdefaultcheckedclassinvoiceenrollmentkeys;
        defaultcheckedsalesinvoicesaleskeys=cdefaultcheckedsalesinvoicesaleskeys;
        defaultcheckedclassreceiptenrollmentkeys=cdefaultcheckedclassreceiptenrollmentkeys;
        defaultcheckedsalesreceiptsaleskeys=cdefaultcheckedsalesreceiptsaleskeys;
    }
    return self;
}

@end


@implementation CallLogRecord
@synthesize calllogkey,calledon,calledby,details,calledbyfullname;

-(id)initCallLogRecordWithcalllogkey:(NSString *)ccalllogkey calledon:(NSString *)ccalledon calledby:(NSString *)ccalledby details:(NSString *)cdetails calledbyfullname:(NSString *)ccalledbyfullname
{
    self =[super init];
    if (self)
    {
        calllogkey=ccalllogkey;
        calledon=ccalledon;
        calledby=ccalledby;
        details=cdetails;
        calledbyfullname=ccalledbyfullname;
    }
    return self;
}

@end

@implementation Lead
@synthesize leadkey,firstname,lastname,othername,gender,dateofbirth,age,grade,preferredlanguage,school,parentname,parentcontact,parentemail,parentaddress,remarks,flag,promotion,status,image,leadid,leadmedia,leadsource,studentkey,photoalbumrecord,centerkey,iso_code,avatar;


-(id)initLeadWithleadkey:(NSString *)sleadkey firstname:(NSString *)sfirstname lastname:(NSString *)slastname othername:(NSString *)sothername gender:(NSString *)sgender dateofbirth:(NSString *)sdateofbirth age:(NSString *)sage grade:(NSString *)sgrade preferredlanguage:(NSString *)spreferredlanguage school:(NSString *)sschool parentname:(NSString *)sparentname parentcontact:(NSString *)sparentcontact parentemail:(NSString *)sparentemail parentaddress:(NSString *)sparentaddress remarks:(NSString *)sremarks flag:(NSString *)sflag promotion:(NSString *)spromotion status:(NSString *)sstatus image:(NSString *)simage leadid:(NSString *)sleadid leadmedia:(NSString *)sleadmedia leadsource:(NSString *)sleadsource studentkey:(NSString *)sstudentkey photoalbumrecord:(ClassValidateRecord *)sphotoalbumrecord centerkey:(NSString *)scenterkey iso_code:(NSString *)siso_code avatar:(NSString *)savatar;
{
    self =[super init];
    if (self)
    {
        leadkey=sleadkey;
        othername=sothername;
        firstname=sfirstname;
        lastname=slastname;
        gender=sgender;
        dateofbirth=sdateofbirth;
        age=sage;
        grade=sgrade;
        preferredlanguage=spreferredlanguage;
        school=sschool;
        parentname=sparentname;
        parentcontact=sparentcontact;
        parentemail=sparentemail;
        parentaddress=sparentaddress;
        remarks=sremarks;
        flag=sflag;
        promotion=spromotion;
        status=sstatus;
        image=simage;
        leadid=sleadid;
        leadmedia=sleadmedia;
        leadsource=sleadsource;
        studentkey=sstudentkey;
        photoalbumrecord=sphotoalbumrecord;
        centerkey=scenterkey;
        iso_code=siso_code;
        avatar=savatar;
    }
    
    return self;
    
}

@end

@implementation MarketingRecord
@synthesize centerkey,marketingkey,category,description,description_chinese,startdate,enddate,remarks,promotionfixeddiscount,promotionpercentagediscount,usedcount,promotionquota,code,recursive,effectivefrom,effectiveto,subcategory,redeemable,redeempoint,perstudentquota,cannotuseconjunctionwithothercoupons,subjectarray,productarray,couponallowcredit,perclassorquantity,earlybirdlastdate,buymorepayless,estartdate,eenddate,enablebuymorepayless,minnoofclass,bmsmacrossothersubjects,bmsmminsubjectno,bmsmsamebillmonth,bmsmminnoofclasspersubject,manualapply;

-(id)initMarketingRecordWithcenterkey:(NSString *)ccenterkey marketingkey:(NSString *)cmarketingkey category:(NSString *)ccategory description:(NSString *)cdescription description_chinese:(NSString *)cdescription_chinese startdate:(NSString *)cstartdate enddate:(NSString *)cenddate remarks:(NSString *)cremarks promotionfixeddiscount:(NSString *)cpromotionfixeddiscount promotionpercentagediscount:(NSString *)cpromotionpercentagediscount usedcount:(NSString *)cusedcount promotionquota:(NSString *)cpromotionquota code:(NSString *)ccode recursive:(NSString *)crecursive effectivefrom:(NSString *)ceffectivefrom effectiveto:(NSString *)ceffectiveto subcategory:(NSString *)csubcategory redeemable:(BOOL)credeemable redeempoint:(NSString *)credeempoint perstudentquota:(NSString *)cperstudentquota cannotuseconjunctionwithothercoupons:(BOOL)ccannotuseconjunctionwithothercoupons subjectarray:(NSMutableArray *)csubjectarray productarray:(NSMutableArray *)cproductarray couponallowcredit:(NSString *)ccouponallowcredit perclassorquantity:(BOOL)cperclassorquantity earlybirdlastdate:(NSString *)cearlybirdlastdate buymorepayless:(BOOL)cbuymorepayless estartdate:(NSString *)cestartdate eenddate:(NSString *)ceenddate enablebuymorepayless:(BOOL)cenablebuymorepayless minnoofclass:(NSInteger)cminnoofclass bmsmacrossothersubjects:(BOOL)cbmsmacrossothersubjects bmsmminsubjectno:(NSInteger)cbmsmminsubjectno bmsmminnoofclasspersubject:(NSInteger)cbmsmminnoofclasspersubject bmsmsamebillmonth:(BOOL)cbmsmsamebillmonth manualapply:(BOOL)cmanualapply
{
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        marketingkey=cmarketingkey;
        category=ccategory;
        description=cdescription;
        description_chinese=cdescription_chinese;
        startdate=cstartdate;
        enddate=cenddate;
        remarks=cremarks;
        promotionfixeddiscount=cpromotionfixeddiscount;
        promotionpercentagediscount=cpromotionpercentagediscount;
        usedcount=cusedcount;
        promotionquota=cpromotionquota;
        code=ccode;
        recursive=crecursive;
        effectivefrom=ceffectivefrom;
        effectiveto=ceffectiveto;
        subcategory=csubcategory;
        redeemable=credeemable;
        redeempoint=credeempoint;
        perstudentquota=cperstudentquota;
        cannotuseconjunctionwithothercoupons=ccannotuseconjunctionwithothercoupons;
        subjectarray=csubjectarray;
        productarray=cproductarray;
        couponallowcredit=ccouponallowcredit;
        perclassorquantity=cperclassorquantity;
        earlybirdlastdate=cearlybirdlastdate;
        buymorepayless=cbuymorepayless;
        estartdate=cestartdate;
        eenddate=ceenddate;
        minnoofclass=cminnoofclass;
        enablebuymorepayless=cenablebuymorepayless;
        bmsmacrossothersubjects=cbmsmacrossothersubjects;
        bmsmminsubjectno=cbmsmminsubjectno;
        bmsmminnoofclasspersubject=cbmsmminnoofclasspersubject;
        bmsmsamebillmonth=cbmsmsamebillmonth;
        manualapply=cmanualapply;
    }
    return self;
}

@end

@implementation CouponRecord
@synthesize centerkey,marketingkey,couponkey,effectiveto,issuedate,dateused,effectivefrom,remarks,marketing,usedsequence,studentkey,cannotuseconjunctionwithothercoupons,creditable;

-(id)initCouponRecordWithcenterkey:(NSString *)ccenterkey marketingkey:(NSString *)cmarketingkey couponkey:(NSString *)ccouponkey issuedate:(NSString *)cissuedate effectiveto:(NSString *)ceffectiveto dateused:(NSString *)cdateused effectivefrom:(NSString *)ceffectivefrom remarks:(NSString *)cremarks marketing:(MarketingRecord *)cmarketing usedsequence:(NSString *)cusedsequence studentkey:(NSString *)cstudentkey cannotuseconjunctionwithothercoupons:(BOOL)ccannotuseconjunctionwithothercoupons creditable:(BOOL)ccreditable
{
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        marketingkey=cmarketingkey;
        couponkey=ccouponkey;
        effectiveto=ceffectiveto;
        issuedate=cissuedate;
        dateused=cdateused;
        effectivefrom=ceffectivefrom;
        remarks=cremarks;
        marketing=cmarketing;
        usedsequence=cusedsequence;
        studentkey=cstudentkey;
        cannotuseconjunctionwithothercoupons=ccannotuseconjunctionwithothercoupons;
        creditable=ccreditable;
    }
    return self;
}

@end

@implementation ClassroomRecord
@synthesize centerkey,classroomkey,classroom,status,remarks,capacity,colorcode;

-(id)initClassroomRecordWithcenterkey:(NSString *)ccenterkey classroomkey:(NSString *)cclassroomkey classroom:(NSString *)cclassroom status:(NSString *)cstatus remarks:(NSString *)cremarks capacity:(NSString *)ccapacity colorcode:(NSInteger)scolorcode
{
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        classroomkey=cclassroomkey;
        classroom=cclassroom;
        status=cstatus;
        remarks=cremarks;
        capacity=ccapacity;
        colorcode=scolorcode;
    }
    return self;
}

@end

@implementation LanguageTitleRecord
@synthesize centerkey,chinese,english,title,schinese;

-(id)initLanguageTitleRecordwithCenterkey:(NSString *)ccenterkey Title:(NSString *)ctitle Chinese:(NSString *)cchinese English:(NSString *)cenglish SChinese:(NSString *)cschinese
{
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        title=ctitle;
        chinese=cchinese;
        english=cenglish;
        schinese=cschinese;
    }
    return self;
}

@end

@implementation LessonRecord
@synthesize lessonkey,classdate,classtime,subject,instructor,classroom,classcount,subjecttype,checkouttime,remarks,classduration,sinstructor;

-(id)initLessonRecordwithlessonkey:(NSString *)clessonkey classdate:(NSString *)cclassdate classtime:(NSString *)cclasstime subject:(NSString *)csubject instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom classcount:(NSString *)cclasscount subjecttype:(NSString *)csubjecttype checkouttime:(NSString *)ccheckouttime remarks:(NSString *)cremarks classduration:(NSString *)cclassduration sinstructor:(NSString *)csinstructor

{
    self =[super init];
    if (self)
    {
        lessonkey=clessonkey;
        classdate=cclassdate;
        classtime=cclasstime;
        subject=csubject;
        instructor=cinstructor;
        classroom=cclassroom;
        classcount=cclasscount;
        subjecttype=csubjecttype;
        checkouttime=ccheckouttime;
        remarks=cremarks;
        classduration=cclassduration;
        sinstructor=csinstructor;
    }
    return self;
}

@end

@implementation LessonAndClassRecord
@synthesize lesson,classScheduleRecordArray;

-(id)initLessonAndClassRecordwithLesson:(LessonRecord *)clesson ClassScheduleRecordArray:(NSMutableArray *)cclassschedulerecordarray

{
    self =[super init];
    if (self)
    {
        lesson=clesson;
        classScheduleRecordArray=cclassschedulerecordarray;
    }
    return self;
}

@end





@implementation AttendanceButtonObject
@synthesize buttonname,sectorcolor,imagename;

-(id)initAttendanceButtonObjectwithbuttonname:(NSString *)cbuttonname sectorcolor:(UIColor *)csectorcolor imagename:(NSString *)cimagename

{
    self =[super init];
    if (self)
    {
        buttonname=cbuttonname;
        sectorcolor=csectorcolor;
        imagename=cimagename;
    }
    return self;
}

@end

@implementation ContactRecord
@synthesize type,relationship,contact,enableparentapp,primarycontact,parentapplastlogin,enablesms,iso_code,enablewechat;

-(id)initContactRecordwithtype:(NSString *)ctype relationship:(NSString *)crelationship contact:(NSString *)ccontact enableparentapp:(BOOL)cenableparentapp primarycontact:(BOOL)cprimarycontact parentapplastlogin:(NSString *)cparentapplastlogin enablesms:(BOOL)cenablesms iso_code:(NSString *)ciso_code enablewechat:(BOOL)cenablewechat

{
    self =[super init];
    if (self)
    {
        type=ctype;
        relationship=crelationship;
        contact=ccontact;
        enableparentapp=cenableparentapp;
        primarycontact=cprimarycontact;
        parentapplastlogin=cparentapplastlogin;
        enablesms=cenablesms;
        iso_code=ciso_code;
        enablewechat=cenablewechat;
    }
    return self;
}

@end

/*
@implementation ScheduleDayRecord
@synthesize mon,tue,wed,thu,fri,sat,sun;

-(id)initScheduleDayRecordwithmon:(NSString *)cmon tue:(NSString *)ctue wed:(NSString *)cwed thu:(NSString *)cthu fri:(NSString *)cfri sat:(NSString *)csat sun:(NSString *)csun

{
    self =[super init];
    if (self)
    {
        mon=cmon;
        tue=ctue;
        wed=cwed;
        thu=cthu;
        fri=cfri;
        sat=csat;
        sun=csun;
    }
    return self;
}

@end*/

@implementation ScheduleDetailsRecord
@synthesize dayofweek,classtime,instructor,classroom,sinstructor;

-(id)initScheduleDetailsRecordwithdayofweek:(NSString *)cdayofweek classtime:(NSString *)cclasstime instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom sinstructor:(NSString *)csinstructor

{
    self =[super init];
    if (self)
    {
        dayofweek=cdayofweek;
        classtime=cclasstime;
        instructor=cinstructor;
        classroom=cclassroom;
        sinstructor=csinstructor;
    }
    return self;
}

@end



@implementation ScheduleRecord
@synthesize schedulekey,name,autorenew,daytimearray,action,startdate,enddate,makeupschedule,active,type,showintimetableifnoenrollment,onlinetrialschedule,levelarray;

-(id)initScheduleRecordwithScheduleKey:(NSString *)cschedulekey Name:(NSString *)cname AutoRenew:(NSString *)cautorenew DayTimeArray:(NSMutableArray *)cdaytimearray Action:(NSString *)caction StartDate:(NSString *)cstartdate EndDate:(NSString *)cenddate makeupschedule:(BOOL)cmakeupschedule active:(BOOL)cactive type:(NSString *)ctype showintimetableifnoenrollment:(BOOL)cshowintimetableifnoenrollment onlinetrialschedule:(BOOL)conlinetrialschedule levelarray:(NSMutableArray *)clevelarray

{
    self =[super init];
    if (self)
    {
        schedulekey=cschedulekey;
        name=cname;
        autorenew=cautorenew;
        daytimearray=cdaytimearray;
        action=caction;
        startdate=cstartdate;
        enddate=cenddate;
        makeupschedule=cmakeupschedule;
        active=cactive;
        type=ctype;
        showintimetableifnoenrollment=cshowintimetableifnoenrollment;
        onlinetrialschedule=conlinetrialschedule;
        levelarray=clevelarray;
    }
    return self;
}

@end

@implementation RenewalLog
@synthesize timeconnectionid,subject,studentkey,firstname,lastname,lastclass,renewalresultenglish,renewalresultchinese,newenrollmentkey,oldenrollmentkey,standardnoofclassormonth,enrollmentmode,schedulekey,username,firstclass,levelmain,image,batchcutoffdate,status,lateststartdate;

-(id)initRenewalLogwithtimeconnectionid:(NSString *)ctimeconnectionid subject:(NSString *)csubject studentkey:(NSString *)cstudentkey firstname:(NSString *)cfirstname lastname:(NSString *)clastname lastclass:(NSString *)clastclass renewalresultenglish:(NSString *)crenewalresultenglish renewalresultchinese:(NSString *)crenewalresultchinese newenrollmentkey:(NSString *)cnewenrollmentkey oldenrollmentkey:(NSString *)coldenrollmentkey standardnoofclassormonth:(NSString *)cstandardnoofclassormonth enrollmentmode:(NSString *)cenrollmentmode schedulekey:(NSString *)cschedulekey username:(NSString *)cusername firstclass:(NSString *)cfirstclass image:(NSString *)cimage levelmain:(NSString *)clevelmain batchcutoffdate:(NSString *)cbatchcutoffdate status:(NSString *)cstatus lateststartdate:(NSString *)clateststartdate

{
    self =[super init];
    if (self)
    {
        timeconnectionid=ctimeconnectionid;
        subject=csubject;
        studentkey=cstudentkey;
        firstname=cfirstname;
        lastname=clastname;
        lastclass=clastclass;
        renewalresultenglish=crenewalresultenglish;
        renewalresultchinese=crenewalresultchinese;
        newenrollmentkey=cnewenrollmentkey;
        oldenrollmentkey=coldenrollmentkey;
        standardnoofclassormonth=cstandardnoofclassormonth;
        enrollmentmode=cenrollmentmode;
        schedulekey=cschedulekey;
        username=cusername;
        firstclass=cfirstclass;
        levelmain=clevelmain;
        image=cimage;
        batchcutoffdate=cbatchcutoffdate;
        status=cstatus;
        lateststartdate=clateststartdate;
        
    }
    return self;
}

@end




@implementation RenewalGroupLog
@synthesize timeconnectionid,username,successfulcount,failcount,renewallogarray,batchcutoffdate,filtervalue;

-(id)initRenewalGroupLogwithtimeconnectionid:(NSString *)ctimeconnectionid username:(NSString *)cusername successfulcount:(NSString *)csuccesfulcount failcount:(NSString *)cfailcount renewallogarray:(NSMutableArray *)crenewallogarray batchcutoffdate:(NSString *)cbatchcutoffdate filtervalue:(NSString *)cfiltervalue

{
    self =[super init];
    if (self)
    {
        timeconnectionid=ctimeconnectionid;
        username=cusername;
        successfulcount=csuccesfulcount;
        failcount=cfailcount;
        renewallogarray=crenewallogarray;
        batchcutoffdate=cbatchcutoffdate;
        filtervalue=cfiltervalue;
        
    }
    return self;
}

@end

@implementation ClassPhotoRecord
@synthesize centerkey,classphotokey,takenby,createdatetime,title,tag,favourite,like,hotnews,hn_expiry_date,filearray;

-(id)initClassPhotoRecordwithcenterkey:(NSString *)ccenterkey classphotokey:(NSString *)cclassphotokey takenby:(NSString *)ctakenby createdatetime:(NSDate *)ccreatedatetime title:(NSString *)ctitle tag:(NSString *)ctag favourite:(NSString *)cfavourite like:(NSString *)clike hotnews:(BOOL)chotnews hn_expiry_date:(NSString *)chn_expiry_date filearray:(NSMutableArray *)cfilearray

{
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        classphotokey=cclassphotokey;
        takenby=ctakenby;
        createdatetime=ccreatedatetime;
        title=ctitle;
        tag=ctag;
        favourite=cfavourite;
        like=clike;
        hotnews=chotnews;
        hn_expiry_date=chn_expiry_date;
        filearray=cfilearray;
    }
    return self;
}

@end

@implementation LastUpdateRecord
@synthesize centerkey,calendar,staff,classroom,languagetitle,subject,product,classimage,centerimage,marketing,studentimage,leadimage,centerrecord,centersettings,userroleandprivilege,student,lead,leavenature,arcode,messagecontact;

-(id)initLastUpdateRecordwithCenterkey:(NSString *)ccenterkey Calendar:(NSString *)ccalendar Staff:(NSString *)cstaff Classroom:(NSString *)cclassroom LanguageTitle:(NSString *)clanguagetitle Subject:(NSString *)csubject Product:(NSString *)cproduct Marketing:(NSString *)cmarketing Centerimage:(NSString *)ccenterimage StudentImage:(NSString *)cstudentimage LeadImage:(NSString *)cleadimage ClassImage:(NSString *)cclassimage Centerrecord:(NSString *)ccenterrecord Centersettings:(NSString *)ccentersettings Userroleandprivilege:(NSString *)cuserroleandprivilege Student:(NSString *)cstudent Lead:(NSString *)clead LeaveNature:(NSString *)cleavenature ARCode:(NSString *)carcode MessageContact:(NSString *)cmessagecontact
{
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        calendar=ccalendar;
        staff=cstaff;
        classroom=cclassroom;
        languagetitle=clanguagetitle;
        subject=csubject;
        product=cproduct;
        classimage=cclassimage;
        centerimage=ccenterimage;
        studentimage=cstudentimage;
        leadimage=cleadimage;
        marketing=cmarketing;
        centerrecord=ccenterrecord;
        centersettings=ccentersettings;
        userroleandprivilege=cuserroleandprivilege;
        student=cstudent;
        lead=clead;
        leavenature=cleavenature;
        arcode=carcode;
        messagecontact=cmessagecontact;
    }
    return self;
}

@end


@implementation UserPrivilege
@synthesize centerkey,privilegekey,role;

-(id)initPrivilegewithCenterkey:(NSString *)ccenterkey Privilegekey:(NSString *)cprivilegekey Role:(NSString *)crole
{
    self=[super init];
    if (self) {
        centerkey=ccenterkey;
        privilegekey=cprivilegekey;
        role=crole;
    }
    return self;
}

@end


@implementation PrivilegeRecord
@synthesize centerkey,usertype,privilegekey,showallothertaskinnotificationview,showallothertaskintaskassignmentview,addstaff,editstaff,addsubject,editsubject,addproduct,editproduct,viewstudentprofile,viewdailyclassschedule,viewclasstimetable,viewclassrenewal,viewpaymentinformation,viewmessagecenter,viewtaskassignment,viewleadprofile,viewassessment,viewcenterinformation,viewsettings,viewallinstructorclass,viewclassphoto,viewcontactindailyschedule,voidenrollment,voidsales,deleteenrollment,deletesales,vieweditsalaryrate,editstudentsubjectlevel,istafftakingattendance,sendmessage,editcenterinformation,editcenterpolicy,biviewmanagerfolder,showstudentcategorycount,istaffsendstaffmessage,istaffsendleadmessage,istaffsendstudentmessage,overrideextensiontime,istaffsendparentnote,istaffshowstudentcontact,overrideassessmentresponse,istaffextendclass,istaffmakeupmode,istaffclassalert,transferenrollment,closeothertask,deletemessage,withdrawcash,showdailyscheduletotalcount,promotestudentgrade,istaffshowoutstanding,editmakeupquota,enablerequestaction,istaffshowclasslevel,publishinphotocorner,editothersphotocornerpost,istaffshowadditionalstudentinfo,classchangealert,istaffviewalloutboxmessage,istaffedithotnews,istaffviewallstudents,istaffviewcentermessage,receiveparentmessage,sendvideomessage,istaffsendvideomessage,sendvoicemessage,istaffsendvoicemessage,showpaymentreceivedchart,addnewstudent,showstudentpage,istaffshowmystudentpage,addclassroom,editclassroom,addmarketing,editmarketing,addlicense,sendmessagecenterrole,viewsetupsubscription,viewchangelog,bistandarddreports,bistandardereports,bistandardireports,bistandardlreports,bistandardqreports,bistandardsreports,showenrollmentcountchart,editdiscount,editpaiddate,editcentercalendar,issuepoint,issuecoupon,applycoupon,showwhatsnew,allowdatebackpaiddate,receiveallstudentnotifications,istaffreceiveallstudentnotifications,edituserschedule,editonetimediscount,editenrollmentfee,showcenterstaffpage,showautonotificationsettings,bimgtmareports,bimgtmdreports,bimgtmireports,bimgtmpreports,bimgtmsreports,editlockedclass,editlockclassperiod,showcentercoursepage,showcenterpolicypage,showcenterproductpage,showcenterclassroompage,showcentermarketingpage,bimgtmtreports,editdiscountifpaid,sendbroadcastmessage,istaffsendbroadcastmessage,editbilldate,editenrollmentdate,editclassforexpiredpromotion,editstaffprivilege,editclassforpaidenrollment,edittimetablesubjectcolor,edittimetableclassroomcolor,edittimetableinstructorcolor,editmakeupsettings,changesalesproduct;

-(id)initPrivilegeRecordwithCenterkey:(NSString *)ccenterkey UserType:(NSString *)cusertype Privilegekey:(NSString *)cprivilegekey ShowAllOtherTaskInNotificationView:(BOOL)cshowallothertaskinnotificationview ShowAllOtherTaskInTaskAssignmentView:(BOOL)cshowallothertaskintaskassignmentview AddSubject:(BOOL)caddsubject EditSubject:(BOOL)ceditsubject AddStaff:(BOOL)caddstaff EditStaff:(BOOL)ceditstaff AddProduct:(BOOL)caddproduct EditProduct:(BOOL)ceditproduct viewstudentprofile:(BOOL)cviewstudentprofile viewdailyclasschedule:(BOOL)cviewdailyclassschedule viewclasstimetable:(BOOL)cviewclasstimetable viewclassrenewal:(BOOL)cviewclassrenewal viewpaymentinformation:(BOOL)cviewpaymentinformation viewmessagecenter:(BOOL)cviewmessagecenter viewtaskassignment:(BOOL)cviewtaskassignment viewleadprofile:(BOOL)cviewleadprofile viewassessment:(BOOL)cviewassessment viewcenterinformation:(BOOL)cviewcenterinformation viewsettings:(BOOL)cviewsettings viewallinstructorclass:(BOOL)cviewallinstructorclass viewclassphoto:(BOOL)cviewclassphoto viewcontactindailyschedule:(BOOL)cviewcontactindailyschedule voidenrollment:(BOOL)cvoidenrollment voidsales:(BOOL)cvoidsales deleteenrollment:(BOOL)cdeleteenrollment deletesales:(BOOL)cdeletesales vieweditsalaryrate:(BOOL)cvieweditsalaryrate editstudentsubjectlevel:(BOOL)ceditstudentsubjectlevel istafftakingattendance:(BOOL)cistafftakingattendance sendmessage:(BOOL)csendmessage editcenterinformation:(BOOL)ceditcenterinformation editcenterpolicy:(BOOL)ceditcenterpolicy biviewmanagerfolder:(BOOL)cbiviewmanagerfolder showstudentcategorycount:(BOOL)cshowstudentcategorycount istaffsendstaffmessage:(BOOL)cistaffsendstaffmessage istaffsendstudentmessage:(BOOL)cistaffsendstudentmessage istaffsendleadmessage:(BOOL)cistaffsendleadmessage overrideextensiontime:(BOOL)coverrideextensiontime istaffsendparentnote:(BOOL)cistaffsendparentnote istaffshowstudentcontact:(BOOL)cistaffshowstudentcontact overrideassessmentresponse:(BOOL)coverrideassessmentresponse istaffextendclass:(BOOL)cistaffextendclass istaffmakeupmode:(NSString *)cistaffmakeupmode istaffclassalert:(BOOL)cistaffclassalert transferenrollment:(BOOL)ctransferenrollment closeothertask:(BOOL)ccloseothertask deletemessage:(BOOL)cdeletemessage withdrawcash:(BOOL)cwithdrawcash showdailyscheduletotalcount:(BOOL)cshowdailyscheduletotalcount promotestudentgrade:(BOOL)cpromotestudentgrade istaffshowoutstanding:(BOOL)cistaffshowoutstanding editmakeupquota:(BOOL)ceditmakeupquota enablerequestaction:(BOOL)cenablerequestaction istaffshowclasslevel:(BOOL)cistaffshowclasslevel publishinphotocorner:(BOOL)cpublishinphotocorner editothersphotocornerpost:(BOOL)ceditothersphotocornerpost istaffshowadditionalstudentinfo:(BOOL)cistaffshowadditionalstudentinfo classchangealert:(BOOL)cclasschangeclart istaffviewalloutboxmessage:(BOOL)cistaffviewalloutboxmessage istaffedithotnews:(BOOL)cistaffedithotnews istaffviewallstudents:(BOOL)cistaffviewallstudents istaffviewcentermessage:(BOOL)cistaffviewcentermessage receiveparentmessage:(BOOL)creceiveparentmessage sendvideomessage:(BOOL)csendvideomessage istaffsendvideomessage:(BOOL)cistaffsendvideomessage sendvoicemessage:(BOOL)csendvoicemessage istaffsendvoicemessage:(BOOL)cistaffsendvoicemessage showpaymentreceivedchart:(BOOL)cshowpaymentreceivedchart addnewstudent:(BOOL)caddnewstudent showstudentpage:(BOOL)cshowstudentpage istaffshowmystudentpage:(BOOL)cistaffshowmystudentpage addclassroom:(BOOL)caddclassroom editclassroom:(BOOL)ceditclassroom addmarketing:(BOOL)caddmarketing editmarketing:(BOOL)ceditmarketing addlicense:(BOOL)caddlicense sendmessagecenterrole:(BOOL)csendmessagecenterrole viewsetupsubscription:(BOOL)cviewsetupsubscription viewchangelog:(BOOL)cviewchangelog bistandarddreports:(BOOL)cbistandarddreports bistandardireports:(BOOL)cbistandardireports bistandardsreports:(BOOL)cbistandardsreports bistandardereports:(BOOL)cbistandardereports bistandardlreports:(BOOL)cbistandardlreports bistandardqreports:(BOOL)cbistandardqreports showenrollmentcountchart:(BOOL)cshowenrollmentcountchart editdiscount:(BOOL)ceditdiscount editpaiddate:(BOOL)ceditpaiddate editcentercalendar:(BOOL)ceditcentercalendar issuepoint:(BOOL)cissuepoint issuecoupon:(BOOL)cissuecoupon applycoupon:(BOOL)capplycoupon showwhatsnew:(BOOL)cshowwhatsnew allowdatebackpaiddate:(BOOL)callowdatebackpaiddate receiveallstudentnotifications:(BOOL)creceiveallstudentnotifications istaffreceiveallstudentnotifications:(BOOL)cistaffreceiveallstudentnotifications edituserschedule:(BOOL)cedituserschedule editonetimediscount:(BOOL)ceditonetimediscount editenrollmentfee:(BOOL)ceditenrollmentfee showcenterstaffpage:(BOOL)cshowcenterstaffpage showautonotificationsettings:(BOOL)cshowautonotificationsettings bimgtmsreports:(BOOL)cbimgtmsreports bimgtmdreports:(BOOL)cbimgtmdreports bimgtmpreports:(BOOL)cbimgtmpreports bimgtmareports:(BOOL)cbimgtmareports bimgtmireports:(BOOL)cbimgtmireports editlockclassperiod:(BOOL)ceditlockclassperiod editlockedclass:(BOOL)ceditlockedclass showcentercoursepage:(BOOL)cshowcentercoursepage showcenterclassroompage:(BOOL)cshowcenterclassroompage showcenterproductpage:(BOOL)cshowcenterproductpage showcenterpolicypage:(BOOL)cshowcenterpolicypage showcentermarketingpage:(BOOL)cshowcentermarketingpage bimgtmtreports:(BOOL)cbimgtmtreports editdiscountifpaid:(BOOL)ceditdiscountifpaid sendbroadcastmessage:(BOOL)csendbroadcastmessage istaffsendbroadcastmessage:(BOOL)cistaffsendbroadcastmessage editbilldate:(BOOL)ceditbilldate editenrollmentdate:(BOOL)ceditenrollmentdate editclassforexpiredpromotion:(BOOL)ceditclassforexpiredpromotion editstaffprivilege:(BOOL)ceditstaffprivilege editclassforpaidenrollment:(BOOL)ceditclassforpaidenrollment edittimetableinstructorcolor:(BOOL)cedittimetableinstructorcolor edittimetablesubjectcolor:(BOOL)cedittimetablesubjectcolor edittimetableclassroomcolor:(BOOL)cedittimetableclassroomcolor editmakeupsettings:(BOOL)ceditmakeupsettings changesalesproduct:(BOOL)cchangesalesproduct
{
    self=[super init];
    if (self) {
        centerkey=ccenterkey;
        usertype=cusertype;
        privilegekey=cprivilegekey;
        showallothertaskintaskassignmentview=cshowallothertaskintaskassignmentview;
        showallothertaskinnotificationview=cshowallothertaskinnotificationview;
        addsubject=caddsubject;
        editsubject=ceditsubject;
        addstaff=caddstaff;
        editstaff=ceditstaff;
        addproduct=caddproduct;
        editproduct=ceditproduct;
        viewstudentprofile=cviewstudentprofile;
        viewdailyclassschedule=cviewdailyclassschedule;
        viewclasstimetable=cviewclasstimetable;
        viewclassrenewal=cviewclassrenewal;
        viewpaymentinformation=cviewpaymentinformation;
        viewmessagecenter=cviewmessagecenter;
        viewtaskassignment=cviewtaskassignment;
        viewleadprofile=cviewleadprofile;
        viewassessment=cviewassessment;
        viewcenterinformation=cviewcenterinformation;
        viewsettings=cviewsettings;
        viewallinstructorclass=cviewallinstructorclass;
        viewclassphoto=cviewclassphoto;
        viewcontactindailyschedule=cviewcontactindailyschedule;
        voidenrollment=cvoidenrollment;
        voidsales=cvoidsales;
        deleteenrollment=cdeleteenrollment;
        deletesales=cdeletesales;
        vieweditsalaryrate=cvieweditsalaryrate;
        editstudentsubjectlevel=ceditstudentsubjectlevel;
        istafftakingattendance=cistafftakingattendance;
        sendmessage=csendmessage;
        editcenterpolicy=ceditcenterpolicy;
        editcenterinformation=ceditcenterinformation;
        biviewmanagerfolder=cbiviewmanagerfolder;
        showstudentcategorycount=cshowstudentcategorycount;
        istaffsendstaffmessage=cistaffsendstaffmessage;
        istaffsendstudentmessage=cistaffsendstudentmessage;
        istaffsendleadmessage=cistaffsendleadmessage;
        overrideextensiontime=coverrideextensiontime;
        istaffsendparentnote=cistaffsendparentnote;
        istaffshowstudentcontact=cistaffshowstudentcontact;
        overrideassessmentresponse=coverrideassessmentresponse;
        istaffextendclass=cistaffextendclass;
        istaffmakeupmode=cistaffmakeupmode;
        istaffclassalert=cistaffclassalert;
        transferenrollment=ctransferenrollment;
        closeothertask=ccloseothertask;
        deletemessage=cdeletemessage;
        withdrawcash=cwithdrawcash;
        showdailyscheduletotalcount=cshowdailyscheduletotalcount;
        promotestudentgrade=cpromotestudentgrade;
        istaffshowoutstanding=cistaffshowoutstanding;
        editmakeupquota=ceditmakeupquota;
        enablerequestaction=cenablerequestaction;
        istaffshowclasslevel=cistaffshowclasslevel;
        editothersphotocornerpost=ceditothersphotocornerpost;
        publishinphotocorner=cpublishinphotocorner;
        istaffshowadditionalstudentinfo=cistaffshowadditionalstudentinfo;
        classchangealert=cclasschangeclart;
        istaffviewalloutboxmessage=cistaffviewalloutboxmessage;
        istaffedithotnews=cistaffedithotnews;
        istaffviewallstudents=cistaffviewallstudents;
        istaffviewcentermessage=cistaffviewcentermessage;
        receiveparentmessage=creceiveparentmessage;
        sendvideomessage=csendvideomessage;
        istaffsendvideomessage=cistaffsendvideomessage;
        sendvoicemessage=csendvoicemessage;
        istaffsendvoicemessage=cistaffsendvoicemessage;
        showpaymentreceivedchart=cshowpaymentreceivedchart;
        addnewstudent=caddnewstudent;
        showstudentpage=cshowstudentpage;
        istaffshowmystudentpage=cistaffshowmystudentpage;
        addclassroom=caddclassroom;
        editclassroom=ceditclassroom;
        addmarketing=caddmarketing;
        editmarketing=ceditmarketing;
        addlicense=caddlicense;
        sendmessagecenterrole=csendmessagecenterrole;
        viewsetupsubscription=cviewsetupsubscription;
        viewchangelog=cviewchangelog;
        bistandarddreports=cbistandarddreports;
        bistandardireports=cbistandardireports;
        bistandardsreports=cbistandardsreports;
        bistandardereports=cbistandardereports;
        bistandardlreports=cbistandardlreports;
        bistandardqreports=cbistandardqreports;
        showenrollmentcountchart=cshowenrollmentcountchart;
        editdiscount=ceditdiscount;
        editpaiddate=ceditpaiddate;
        editdiscount=ceditdiscount;
        editpaiddate=ceditpaiddate;
        editcentercalendar=ceditcentercalendar;
        issuepoint=cissuepoint;
        issuecoupon=cissuecoupon;
        applycoupon=capplycoupon;
        showwhatsnew=cshowwhatsnew;
        allowdatebackpaiddate=callowdatebackpaiddate;
        receiveallstudentnotifications=creceiveallstudentnotifications;
        istaffreceiveallstudentnotifications=cistaffreceiveallstudentnotifications;
        edituserschedule=cedituserschedule;
        editonetimediscount=ceditonetimediscount;
        editenrollmentfee=ceditenrollmentfee;
        showcenterstaffpage=cshowcenterstaffpage;
        showautonotificationsettings=cshowautonotificationsettings;
        bimgtmsreports=cbimgtmsreports;
        bimgtmdreports=cbimgtmdreports;
        bimgtmpreports=cbimgtmpreports;
        bimgtmareports=cbimgtmareports;
        bimgtmireports=cbimgtmireports;
        editlockclassperiod=ceditlockclassperiod;
        editlockedclass=ceditlockedclass;
        showcentercoursepage=cshowcentercoursepage;
        showcenterpolicypage=cshowcenterpolicypage;
        showcenterproductpage=cshowcenterproductpage;
        showcentermarketingpage=cshowcentermarketingpage;
        showcenterclassroompage=cshowcenterclassroompage;
        bimgtmtreports=cbimgtmtreports;
        editdiscountifpaid=ceditdiscountifpaid;
        sendbroadcastmessage=csendbroadcastmessage;
        istaffsendbroadcastmessage=cistaffsendbroadcastmessage;
        editbilldate=ceditbilldate;
        editenrollmentdate=ceditenrollmentdate;
        editclassforexpiredpromotion=ceditclassforexpiredpromotion;
        editstaffprivilege=ceditstaffprivilege;
        editclassforpaidenrollment=ceditclassforpaidenrollment;
        edittimetablesubjectcolor=cedittimetablesubjectcolor;
        edittimetableclassroomcolor=cedittimetableclassroomcolor;
        edittimetableinstructorcolor=cedittimetableinstructorcolor;
        editmakeupsettings=ceditmakeupsettings;
        changesalesproduct=cchangesalesproduct;
    }
    
    return self;
}

@end

@implementation ExtendedClassRecord
@synthesize extendkey,centerkey,fromclasskey,toclasskey,classdate,classtime,extensiontime,extendedminute,schedulekey,subject;

-(id)initExtendedClassRecordwithCenterkey:(NSString *)ccenterkey Extendkey:(NSString *)cextendkey FromClasskey:(NSString *)cfromclasskey ToClasskey:(NSString *)ctoclasskey Classdate:(NSString *)cclassdate Classtime:(NSString *)cclasstime Extensiontime:(int)cextensiontime Extendedminute:(int)cextendedminute Schedulekey:(NSString *)cschedulekey Subject:(NSString *)csubject
{
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        extendkey=cextendkey;
        fromclasskey=cfromclasskey;
        toclasskey=ctoclasskey;
        classdate=cclassdate;
        classtime=cclasstime;
        extensiontime=cextensiontime;
        extendedminute=cextendedminute;
        schedulekey=cschedulekey;
        subject=csubject;
    }
    return self;
}

@end

@implementation SortingRecord
@synthesize item,order;

-(id)initSortingRecordwithItem:(NSString *)citem Order:(NSString *)corder
{
    self =[super init];
    if (self)
    {
        item=citem;
        order=corder;
    }
    return self;
}

@end

@implementation SiblingRecord
@synthesize studentname,studentkey,relationship;

-(id)initSiblingRecordwithStudentname:(NSString *)cstudentname Studentkey:(NSString *)cstudentkey Relationship:(NSString *)crelationship
{
    self =[super init];
    if (self)
    {
        studentname=cstudentname;
        studentkey=cstudentkey;
        relationship=crelationship;
    }
    return self;
}

@end

@implementation ViewHistoryRecord
@synthesize typekey,name,ID,gender;

-(id)initViewHistoryRecordwithTypekey:(NSString *)ctypekey Name:(NSString *)cname ID:(NSString *)cID Gender:(NSString *)cgender
{
    self =[super init];
    if (self)
    {
        typekey=ctypekey;
        name=cname;
        ID=cID;
        gender=cgender;
    }
    return self;
}

@end

@implementation ScanHistoryRecord
@synthesize studentkey,studentid,studentname,image,gender,status,success;

-(id)initScanHistoryRecordwithStudentkey:(NSString *)cstudentkey StudentName:(NSString *)cstudentname StudentID:(NSString *)cstudentid Image:(NSString *)cimage Gender:(NSString *)cgender Status:(NSString *)cstatus Success:(BOOL)csuccess
{
    self =[super init];
    if (self)
    {
        studentkey=cstudentkey;
        studentid=cstudentid;
        studentname=cstudentname;
        image=cimage;
        gender=cgender;
        status=cstatus;
        success=csuccess;
    }
    return self;
}

@end


@implementation SubjectCategoryRecord
@synthesize centerkey,scategorykey,englishname,chinesename,colorcode,bundleforapppayment;

-(id)initSubjectCategoryRecordwithCenterkey:(NSString *)ccenterkey SCategoryKey:(NSString *)cscategorykey Englishname:(NSString *)cenglishname Chinesename:(NSString *)cchinesename colorcode:(NSInteger)ccolorcode bundleforapppayment:(BOOL)cbundleforapppayment
{
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        scategorykey=cscategorykey;
        englishname=cenglishname;
        chinesename=cchinesename;
        colorcode=ccolorcode;
        bundleforapppayment=cbundleforapppayment;
    }
    return self;
}

@end

@implementation AssessmentFormRowObject
@synthesize formitemkey,title,questiontype,valuearray,responsearray;

-(id)initAssessmentFormRowObjectwithFormItemKey:(NSString *)cformitemkey Title:(NSString *)ctitle QuestionType:(NSString *)cquestiontype ValueArray:(NSMutableArray *)cvaluearray ResponseArray:(NSMutableArray *)cresponsearray
{
    self =[super init];
    if (self)
    {
        formitemkey=cformitemkey;
        title=ctitle;
        questiontype=cquestiontype;
        valuearray=cvaluearray;
        responsearray=cresponsearray;
    }
    return self;
}

@end

@implementation AssessmentFormSectionObject
@synthesize title,questionarray;

-(id)initAssessmentFormSectionObjectwithTitle:(NSString *)ctitle QuestionArray:(NSMutableArray *)cquestinarray
{
    self =[super init];
    if (self)
    {
        title=ctitle;
        questionarray=cquestinarray;
    }
    return self;
}

@end

@implementation AssessmentFormListObject
@synthesize formkey,formname,lastsubmittedtime,submitter,formtype,subjectarray,active,gradearray,remarks;

-(id)initAssessmentFormListObjectwithFormKey:(NSString *)cformkey FormName:(NSString *)cformname LastSubmittedTime:(NSString *)clastsubmittedtime Submitter:(NSString *)csubmitter formType:(NSString *)cformtype subjectarray:(NSMutableArray *)csubjectarray active:(BOOL)cactive gradearray:(NSMutableArray *)cgradearray remarks:(NSString *)cremarks
{
    self =[super init];
    if (self)
    {
        formkey=cformkey;
        formname=cformname;
        lastsubmittedtime=clastsubmittedtime;
        submitter=csubmitter;
        formtype=cformtype;
        subjectarray=csubjectarray;
        active=cactive;
        gradearray=cgradearray;
        remarks=cremarks;
    }
    return self;
}

@end

@implementation NoOfMonthLesson
@synthesize totallesson,nooflesson;

-(id)initNoOfMonthLessonwithtotallesson:(float)ctotallesson nooflesson:(float)cnooflesson
{
    self =[super init];
    if (self)
    {
        totallesson=ctotallesson;
        nooflesson=cnooflesson;
    }
    return self;
}

@end

@implementation GroupRecord
@synthesize groupkey,groupname,makeuparrangementnotification,autorenewalfailurenotification,description,onlineenrollmentnotification,onlinepaymentnotification;

-(id)initGroupRecordwithgroupkey:(NSString *)cgroupkey groupname:(NSString *)cgroupname description:(NSString *)cdescription makeuparrangementnotification:(BOOL)cmakeuparrangementnotification autorenewalfailurenotification:(BOOL)cautorenewalfailurenotification onlineenrollmentnotification:(BOOL)conlineenrollmentnotification onlinepaymentnotification:(BOOL)conlinepaymentnotification
{
    self =[super init];
    if (self)
    {
        groupkey=cgroupkey;
        groupname=cgroupname;
        description=cdescription;
        makeuparrangementnotification=cmakeuparrangementnotification;
        autorenewalfailurenotification=cautorenewalfailurenotification;
        onlineenrollmentnotification=conlineenrollmentnotification;
        onlinepaymentnotification=conlinepaymentnotification;
    }
    return self;
}

@end

@implementation GroupMemberRecord
@synthesize groupkey,leader;

-(id)initGroupMemberRecordwithgroupkey:(NSString *)cgroupkey leader:(BOOL)cleader
{
    self =[super init];
    if (self)
    {
        groupkey=cgroupkey;
        leader=cleader;
    }
    return self;
}

@end

@implementation StudentRequestRecord
@synthesize studentrequestkey,centerkey,request_for_value,request_for_leavenaturelistkey,request_time,request_status,request_for_type,requestor_username,requesting_category,requesting_categorykey,request_for_value_reason,actiontime,actionby,studentfullname,subjectfullname,classrecord,requestingdatetime,actionbyfullname,request_for_classroom,request_for_instructor,count_quota,request_from_value,request_from_date,request_from_time,request_from_instructor,request_from_classroom;

-(id)initStudentRequestRecordWithStudentRequestKey:(NSInteger)cstudentrequestkey CenterKey:(NSString *)ccenterkey requesting_category:(NSString *)crequesting_category requesting_categorykey:(NSInteger)crequesting_categorykey request_for_type:(NSString *)crequest_for_type request_for_value:(NSString *)crequest_for_value request_for_leavenaturelistkey:(NSString *)crequest_for_leavenaturelistkey request_for_value_reason:(NSString *)crequest_for_value_reason requestingdatetime:(NSDate *)crequestingdatetime request_status:(NSString *)crequest_status requestor_username:(NSString *)crequestor_username request_time:(NSDate *)crequest_time actionby:(NSString *)cactionby actiontime:(NSDate *)cactiontime studentfullname:(NSString *)cstudentfullname subjectfullname:(NSString *)csubjectfullname actionbyfullname:(NSString *)cactionbyfullname classrecord:(ClassRecord *)cclassrecord request_for_instructor:(NSString *)crequest_for_instructor request_for_classroom:(NSString *)crequest_for_classroom count_quota:(BOOL)ccount_quota request_from_date:(NSString *)crequest_from_date request_from_time:(NSString *)crequest_from_time request_from_value:(NSString *)crequest_from_value request_from_instructor:(NSString *)crequest_from_instructor request_from_classroom:(NSString *)crequest_from_classroom
{
    self =[super init];
    if (self)
    {
        studentrequestkey=cstudentrequestkey;
        centerkey=ccenterkey;
        requesting_category=crequesting_category;
        requesting_categorykey=crequesting_categorykey;
        request_for_type=crequest_for_type;
        request_for_value=crequest_for_value;
        request_for_leavenaturelistkey=crequest_for_leavenaturelistkey;
        request_for_value_reason=crequest_for_value_reason;
        requestingdatetime=crequestingdatetime;
        classrecord=cclassrecord;
        request_status=crequest_status;
        requestor_username=crequestor_username;
        request_time=crequest_time;
        actionby=cactionby;
        actiontime=cactiontime;
        studentfullname=cstudentfullname;
        subjectfullname=csubjectfullname;
        actionbyfullname=cactionbyfullname;
        request_for_instructor=crequest_for_instructor;
        request_for_classroom=crequest_for_classroom;
        count_quota=ccount_quota;
        request_from_date=crequest_from_date;
        request_from_time=crequest_from_time;
        request_from_value=crequest_from_value;
        request_from_instructor=crequest_from_instructor;
        request_from_classroom=crequest_from_classroom;
    }
    return self;
}

@end

@implementation LeaveNatureRecord
@synthesize leavenaturelistkey,centerkey,nature_desc_chinese,nature_desc_english,remarks,listorder,is_student_request,configdict;

-(id)initLeaveNatureRecordWithLeaveNatureListKey:(NSString *)cleavenaturelistkey centerKey:(NSString *)ccenterkey nature_desc_english:(NSString *)cnature_desc_english nature_desc_chinese:(NSString *)cnature_desc_chinese is_student_request:(BOOL)cis_student_request remarks:(NSString *)cremarks listOrder:(NSString *)clistorder configDict:(NSMutableDictionary *)cconfigdict
{
    self =[super init];
    if (self)
    {
        leavenaturelistkey=cleavenaturelistkey;
        centerkey=ccenterkey;
        nature_desc_chinese=cnature_desc_chinese;
        nature_desc_english=cnature_desc_english;
        is_student_request=cis_student_request;
        remarks=cremarks;
        listorder=clistorder;
        configdict=cconfigdict;
    }
    return self;
}

@end

@implementation LeaveNatureConfig
@synthesize leavenatureconfigkey,leavenaturelistkey,attendance,count_quota,default_nature_for_student,default_nature_for_staff,require_approval;

-(id)initLeaveNatureConfigWithLeaveNatureConfigKey:(NSString *)cleavenatureconfigkey leaveNatureLeaveKey:(NSString *)cleavenaturelistkey attendance:(NSString *)cattendance count_quota:(BOOL)ccount_quota default_nature_for_student:(BOOL)cdefault_nature_for_student default_nature_for_staff:(BOOL)cdefault_nature_for_staff require_approval:(BOOL)crequire_approval
{
    self =[super init];
    if (self)
    {
        leavenatureconfigkey=cleavenatureconfigkey;
        leavenaturelistkey=cleavenaturelistkey;
        attendance=cattendance;
        count_quota=ccount_quota;
        default_nature_for_student=cdefault_nature_for_student;
        default_nature_for_staff=cdefault_nature_for_staff;
        require_approval=crequire_approval;
    }
    return self;
}

@end

@implementation LessonRecord2
@synthesize datetime,instructor,classroom,level,sinstructor;

-(id)initLessonRecord2withdatetime:(NSString *)cdatetime instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom level:(NSString *)clevel sinstructor:(NSString *)csinstructor

{
    self =[super init];
    if (self)
    {
        datetime=cdatetime;
        instructor=cinstructor;
        classroom=cclassroom;
        level=clevel;
        sinstructor=csinstructor;
    }
    return self;
}

@end

@implementation ARCodeRecord
@synthesize arckey,centerkey,arcode;

-(id)initARCodeRecordwitharckey:(NSString *)carckey centerkey:(NSString *)ccenterkey arcode:(NSString *)carcode

{
    self =[super init];
    if (self)
    {
        arcode=carcode;
        arckey=carckey;
        centerkey=ccenterkey;
    }
    return self;
}

@end

@implementation ClassKeys
@synthesize enrollmentkey,classkey;

-(id)initClassKeysWithEnrollmentkey:(NSString *)cenrollmentkey Classkey:(NSString *)cclasskey

{
    self =[super init];
    if (self)
    {
        enrollmentkey=cenrollmentkey;
        classkey=cclasskey;
    }
    return self;
}

@end

@implementation AvailabilityRecord
@synthesize date,starttime,endtime;

-(id)initAvailabilityRecordWithDate:(NSString *)cdate StartTime:(NSString *)cstarttime EndTime:(NSString *)cendtime
{
    self =[super init];
    if (self)
    {
        date=cdate;
        starttime=cstarttime;
        endtime=cendtime;
    }
    return self;
}

@end

@implementation DiscountRecord
@synthesize discount,description,description_chinese;

-(id)initDiscountRecordRecordWithDiscount:(NSString *)cdiscount Description:(NSString *)cdescription Description_Chinese:(NSString *)cdescription_chinese
{
    self =[super init];
    if (self)
    {
        discount=cdiscount;
        description=cdescription;
        description_chinese=cdescription_chinese;
    }
    return self;
}

@end

@implementation InvoiceLogRecord
@synthesize invoicelogkey,invoicenumber,createtime,staff,totalpaid,totalamount,itemarray;

-(id)initInvoiceLogRecordWithInvoiceLogKey:(NSString *)cinvoicelogkey InvoiceNumber:(NSString *)cinvoicenumber CreateTime:(NSDate *)ccreatetime Staff:(NSString *)cstaff TotalAmount:(float)ctotalamount TotalPaid:(float)ctotalpaid ItemArray:(NSMutableArray *)citemarray
{
    self =[super init];
    if (self)
    {
        invoicelogkey=cinvoicelogkey;
        invoicenumber=cinvoicenumber;
        createtime=ccreatetime;
        staff=cstaff;
        totalamount=ctotalamount;
        totalpaid=ctotalpaid;
        itemarray=citemarray;
    }
    return self;
}

@end

@implementation InvoiceLogItem
@synthesize studentkey,type,typekey,itemcode,amount,paid,studentfullname,itemdescription,lastpaymentkey;

-(id)initInvoiceLogItemWithStudentKey:(NSString *)cstudentkey Type:(NSString *)ctype TypeKey:(NSString *)ctypekey ItemCode:(NSString *)citemcode Amount:(float)camount Paid:(float)cpaid studentfullname:(NSString *)cstudentfullname itemdescription:(NSString *)citemdescription lastpaymentkey:(NSString *)clastpaymentkey
{
    self =[super init];
    if (self)
    {
        studentkey=cstudentkey;
        type=ctype;
        typekey=ctypekey;
        itemcode=citemcode;
        amount=camount;
        paid=cpaid;
        studentfullname=cstudentfullname;
        itemdescription=citemdescription;
        lastpaymentkey=clastpaymentkey;
    }
    return self;
}

@end

@implementation SlidePhotoRecord
@synthesize centerkey,typekey,type,filename,title,postdate,width,height,editable,hn_expiry_date,filetype,thumbnailurl,fileurl;

-(id)initSlidePhotoRecordwithcenterkey:(NSString *)ccenterkey type:(NSString *)ctype typekey:(NSString *)ctypekey filename:(NSString *)cfilename title:(NSString *)ctitle postdate:(NSString *)cpostdate width:(NSString *)cwidth height:(NSString *)cheight hn_expiry_date:(NSString *)chn_expiry_date editable:(BOOL)ceditable filetype:(NSString *)cfiletype thumbnailurl:(NSString *)cthumbnailurl fileurl:(NSString *)cfileurl

{
    self =[super init];
    if (self)
    {
        centerkey=ccenterkey;
        type=ctype;
        typekey=ctypekey;
        filename=cfilename;
        title=ctitle;
        postdate=cpostdate;
        width=cwidth;
        height=cheight;
        hn_expiry_date=chn_expiry_date;
        editable=ceditable;
        filetype=cfiletype;
        thumbnailurl=cthumbnailurl;
        fileurl=cfileurl;
    }
    return self;
}

@end

@implementation PhotoCornerFileRecord
@synthesize photocornerfilekey,fileurl,imageview,width,height,filetype,internalurl,filename,thumbnailurl,action,downloadfiletype,centerkey,title;

-(id)initPhotoCornerFileRecordWithCenterKey:(NSString *)scenterkey PhotoCornerFileKey:(NSString *)sphotocornerfilekey FileURL:(NSString *)sfileurl ImageView:(UIImageView *)simageview Width:(CGFloat)swidth Height:(CGFloat)sheight FileType:(NSString *)sfiletype InternalURL:(NSURL *)sinternalurl FileName:(NSString *)sfilename ThumbnailURL:(NSString *)sthumbnailurl Action:(NSString *)saction DownloadFileType:(NSString *)sdownloadfiletype title:(NSString *)stitle
{
    self =[super init];
    if (self)
    {
        centerkey=scenterkey;
        photocornerfilekey=sphotocornerfilekey;
        fileurl=sfileurl;
        imageview=simageview;
        width=swidth;
        height=sheight;
        filetype=sfiletype;
        internalurl=sinternalurl;
        filename=sfilename;
        thumbnailurl=sthumbnailurl;
        action=saction;
        downloadfiletype=sdownloadfiletype;
        title=stitle;
    }
    
    return self;
    
}

@end

@implementation FullScreenFileRecord
@synthesize centerkey,typekey,fileurl,imageview,width,height,filetype,internalurl,filename,thumbnailurl,action,downloadfiletype,title;

-(id)initFullScreenFileRecordWithCenterkey:(NSString *)scenterkey TypeKey:(NSString *)stypekey FileURL:(NSString *)sfileurl ImageView:(UIImageView *)simageview Width:(CGFloat)swidth Height:(CGFloat)sheight FileType:(NSString *)sfiletype InternalURL:(NSURL *)sinternalurl FileName:(NSString *)sfilename ThumbnailURL:(NSString *)sthumbnailurl Action:(NSString *)saction DownloadFileType:(NSString *)sdownloadfiletype Title:(NSString *)stitle
{
    self =[super init];
    if (self)
    {
        centerkey=scenterkey;
        typekey=stypekey;
        fileurl=sfileurl;
        imageview=simageview;
        width=swidth;
        height=sheight;
        filetype=sfiletype;
        internalurl=sinternalurl;
        filename=sfilename;
        thumbnailurl=sthumbnailurl;
        action=saction;
        downloadfiletype=sdownloadfiletype;
        title=stitle;
    }
    
    return self;
    
}

@end

@implementation CountryCodeRecord
@synthesize countrycodekey,country_name,iso_code,country_code;

-(id)initCountryCodeRecordwithcountrycodekey:(NSString *)ccountrycodekey country_code:(NSString *)ccountry_code country_name:(NSString *)ccountry_name iso_code:(NSString *)ciso_code

{
    self =[super init];
    if (self)
    {
        countrycodekey=ccountrycodekey;
        country_name=ccountry_name;
        iso_code=ciso_code;
        country_code=ccountry_code;
    }
    return self;
}

@end

@implementation PaymentReceivedDetailsRecord
@synthesize paymentkey,paiddate,studentkey,paymenttype,subject,noofclass,product,quantity,paymentremarks,receiptremarks,remarks,staffname,paidmethod,paidamount,studentfullname,itemdescription,paymenttypekey;

-(id)initPaymentReceivedDetailsRecordwithpaymentkey:(NSString *)cpaymentkey paiddate:(NSString *)cpaiddate studentkey:(NSString *)cstudentkey paymenttype:(NSString *)cpaymenttype subject:(NSString *)csubject noofclass:(NSString *)cnoofclass product:(NSString *)cproduct quantity:(NSString *)cquantity paymentremarks:(NSString *)cpaymentremarks receiptremarks:(NSString *)creceiptremarks remarks:(NSString *)cremarks staffname:(NSString *)cstaffname paidmethod:(NSString *)cpaidmethod paidamount:(NSString *)cpaidamount studentfullname:(NSString *)cstudentfullname itemdescription:(NSString *)citemdescription paymenttypekey:(NSString *)cpaymenttypekey

{
    self =[super init];
    if (self)
    {
        paymentkey=cpaymentkey;
        paiddate=cpaiddate;
        studentkey=cstudentkey;
        paymenttype=cpaymenttype;
        subject=csubject;
        noofclass=cnoofclass;
        product=cproduct;
        quantity=cquantity;
        paymentremarks=cpaymentremarks;
        receiptremarks=creceiptremarks;
        remarks=cremarks;
        staffname=cstaffname;
        paidmethod=cpaidmethod;
        paidamount=cpaidamount;
        studentfullname=cstudentfullname;
        itemdescription=citemdescription;
        paymenttypekey=cpaymenttypekey;
    }
    return self;
}

@end

@implementation PaymentReceivedRecord
@synthesize paiddate,paiddict,paymentrecords;

-(id)initPaymentReceivedRecordwithpaiddate:(NSString *)cpaiddate paymentrecords:(NSMutableArray *)cpaymentrecords paiddict:(NSMutableDictionary *)cpaiddict

{
    self =[super init];
    if (self)
    {
        paiddate=cpaiddate;
        paymentrecords=cpaymentrecords;
        paiddict=cpaiddict;
    }
    return self;
}

@end

@implementation AutoNotificationSettingsRecord
@synthesize ansettingkey,message_type,schedule_time,day_before_event,repeat_day,channel,message_en,message_zh,enable,paymentreminder;

-(id)initAutoNotificationSettingsRecordwithansettingkey:(NSString *)cansettingkey message_type:(NSString *)cmessage_type schedule_time:(NSString *)cschedule_time day_before_event:(NSString *)cday_before_event repeat_day:(NSString *)crepeat_day channel:(NSString *)cchannel message_en:(NSString *)cmessage_en message_zh:(NSString *)cmessage_zh enable:(BOOL)cenable paymentreminder:(BOOL)cpaymentreminder

{
    self =[super init];
    if (self)
    {
        ansettingkey=cansettingkey;
        message_type=cmessage_type;
        schedule_time=cschedule_time;
        day_before_event=cday_before_event;
        repeat_day=crepeat_day;
        channel=cchannel;
        message_en=cmessage_en;
        message_zh=cmessage_zh;
        enable=cenable;
        paymentreminder=cpaymentreminder;
    }
    return self;
}

@end

@implementation WhatsNewRecord
@synthesize version,title,description,imagefile,imagewidth,imageheight,videourl;

-(id)initWhatsnewRecordwithversion:(NSString *)cversion title:(NSString *)ctitle description:(NSString *)cdescription imagefile:(NSString *)cimagefile imagewidth:(NSString *)cimagewidth imageheight:(NSString *)cimageheight videourl:(NSString *)cvideourl

{
    self =[super init];
    if (self)
    {
        version=cversion;
        title=ctitle;
        description=cdescription;
        imagefile=cimagefile;
        imagewidth=cimagewidth;
        imageheight=cimageheight;
        videourl=cvideourl;
    }
    return self;
}

@end

@implementation MultiCoordinate
@synthesize x,y,z;

-(id)initMultiCoordinatewithx:(NSInteger)cx y:(NSInteger)cy z:(NSInteger)cz

{
    self =[super init];
    if (self)
    {
        x=cx;
        y=cy;
        z=cz;
    }
    return self;
}

@end

@implementation TrainingCategory
@synthesize category,itemrecords;

-(id)initTrainingCategorywithCategory:(NSString *)ccategory itemrecords:(NSMutableArray *)citemrecords
{
    self =[super init];
    if (self)
    {
        category=ccategory;
        itemrecords=citemrecords;
    }
    return self;
}

@end

@implementation TrainingItem
@synthesize title,fileurl,filetype;

-(id)initTrainingItemwithTitle:(NSString *)ctitle fileurl:(NSString *)cfileurl filetype:(NSString *)cfiletype
{
    self =[super init];
    if (self)
    {
        title=ctitle;
        fileurl=cfileurl;
        filetype=cfiletype;
    }
    return self;
}

@end

@implementation ChangeLogRecord
@synthesize date,username,studentkey,type,action,change,subject,product,enrollmentkey,saleskey,classkey,subtype,subtypekey,useractivity,apiaction;

-(id)initChangeLogRecordWithDate:(NSString *)cdate username:(NSString *)cusername studentkey:(NSString *)cstudentkey type:(NSString *)ctype action:(NSString *)caction change:(NSString *)cchange subject:(NSString *)csubject product:(NSString *)cproduct enrollmentkey:(NSString *)cenrollmentkey saleskey:(NSString *)csaleskey classkey:(NSString *)cclasskey subtype:(NSString *)csubtype subtypekey:(NSString *)csubtypekey useractivity:(NSString *)cuseractivity apiaction:(NSString *)capiaction

{
    self =[super init];
    if (self)
    {
        date=cdate;
        username=cusername;
        studentkey=cstudentkey;
        subject=csubject;
        type=ctype;
        product=cproduct;
        action=caction;
        product=cproduct;
        change=cchange;
        enrollmentkey=cenrollmentkey;
        saleskey=csaleskey;
        classkey=cclasskey;
        subtype=csubtype;
        subtypekey=csubtypekey;
        useractivity=cuseractivity;
        apiaction=capiaction;
    }
    return self;
}

@end

@implementation PointRecord
@synthesize pointkey,issuedatetime,type,subtype,point,expirydate,remarks,unusedpoint;

-(id)initPointRecordWithpointkey:(NSString *)cpointkey issuedatetime:(NSString *)cissuedatetime type:(NSString *)ctype subtype:(NSString *)csubtype point:(NSString *)cpoint expirydate:(NSString *)cexpirydate remarks:(NSString *)cremarks unusedpoint:(NSString *)cunusedpoint

{
    
    self =[super init];
    if (self)
    {
        pointkey=cpointkey;
        issuedatetime=cissuedatetime;
        type=ctype;
        subtype=csubtype;
        point=cpoint;
        expirydate=cexpirydate;
        remarks=cremarks;
        unusedpoint=cunusedpoint;
    }
    return self;
}

@end

@implementation MembershipTierRecord
@synthesize tierkey,title,title_chinese,requirement,pointmultiplier,birthdaypoint,image,totalspending;

-(id)initMembershipTierRecordRecordwithtierkey:(NSString *)ctierkey title:(NSString *)ctitle title_chinese:(NSString *)ctitle_chinese requirement:(NSString *)crequirement pointmultiplier:(NSString *)cpointmulitplier birthdaypoint:(NSString *)cbirthdaypoint image:(NSString *)cimage totalspending:(NSString *)ctotalspending

{
    self =[super init];
    if (self)
    {
        tierkey=ctierkey;
        title=ctitle;
        title_chinese=ctitle_chinese;
        requirement=crequirement;
        pointmultiplier=cpointmulitplier;
        birthdaypoint=cbirthdaypoint;
        image=cimage;
        totalspending=ctotalspending;
    }
    return self;
}

@end

@implementation ColorScheme
@synthesize colorschemekey,main_color;

-(id)initColorSchemeWithColorSchemeKey:(NSString *)ccolorschemekey colorScheme:(UIColor *)cmain_color
{
    self =[super init];
    if (self)
    {
        colorschemekey=ccolorschemekey;
        main_color=cmain_color;
    }
    return self;
}

@end

@implementation GlobalVariables
{
    GlobalVariables *anotherSingle;
}

@synthesize classdate,classtime,subject,instructor,primaryserverpath,secondaryserverpath,serverpath,generalphpfilename,generalphpfullpath,activeserver,reloadcenterdata,username,password,lastlogin,lastlogout,deviceToken,centerrecord,globalsettings,deviceidentifier,userdevicekey,newlogin,centerdayofweekarray,documentfolder,language,reloadleftmenu,subjectlistarray,productlistarray,stafflistarray,classroomlistarray,backfromappstore,leftmenuindex,CenterDict,lastupdatedict,userprivilegearray,centersettingsarray,rawusername,lastviewcontroller,marketinglistarray,appbecomeactiveaction,languagetitledictionary,subjectcategoryarray,privilegearray,studentlistarray,leadlistarray,isdb,loadingindicatorview,centerdaydictionary,addhocschedulerecord,audioplayer,boyimage,girlimage,leavenaturearray,arcodelistarray,countrycodearray,languagepackdictionary,colorcodearray,firstredirectscreen,unreadmessagecountview,lastgetunreadmessagecountdatetime,contactrelationshiparray,unreadmessagecount,documentfolderdict,messagecontactlist,selectedmessagecontact,messageArray,filteredMessageArray,messagecontactrecord,pendingrequestcount,pendingrequestcountview,passwordexpirydate,passwordexpirylastshowndate,lastunixtimestampreceived,lastunixtimestampreceivedtime,mediaDomain;

+(GlobalVariables *)singleObj
{
    static GlobalVariables *single=nil;
    @synchronized(self)
    {
        if (!single) {
            single=[[GlobalVariables alloc]init];
        }
    }
    return single;
}

@end

