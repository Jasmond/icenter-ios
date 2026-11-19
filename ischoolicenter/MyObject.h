//
//  MyObject.h
//  ELTestX
//
//  Created by Jasmond Luk on 5/7/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import <AVFoundation/AVFoundation.h>

//#import "SDImageCache.h"

@interface ClassValidateMessage : NSObject{
    
    NSString *overenrollmentmessage;
    NSString *sameinstructormulticlassmessage;
    NSString *alreadyenrolledmessage;
    NSString *sameclassroommulticlassmessage;
    NSString *hasextendedchildclassmessage;
    NSString *classroomexceedcapacitymessage;
    NSString *makeupquotaexceedmessage;
    
    
}
@property (strong,nonatomic) NSString *overenrollmentmessage;
@property (strong,nonatomic) NSString *sameinstructormulticlassmessage;
@property (strong,nonatomic) NSString *alreadyenrolledmessage;
@property (strong,nonatomic) NSString *sameclassroommulticlassmessage;
@property (strong,nonatomic) NSString *hasextendedchildclassmessage;
@property (strong,nonatomic) NSString *classroomexceedcapacitymessage;
@property (strong,nonatomic) NSString *makeupquotaexceedmessage;

#pragma mark -
#pragma mark Class Methods

-(id)initClassValidateMessagewithoverenrollmentmessage:(NSString *)coverenrollmentmessage sameinstructormulticlassmessage:(NSString *)csameinstructormulticlassmessage alreadyenrolledmessage:(NSString *)calreadyenrolledmessage sameclassroommulticlassmessage:(NSString *)csameclassroommulticlassmessage hasextendedchildclassmessage:(NSString *)chasextendedchildclassmessage classroomexceedcapacitymessage:(NSString *)cclassroomexceedcapacitymessage makeupquotaexceedmessage:(NSString *)cmakeupquotaexceedmessage;

@end

@interface ClassValidateStatus : NSObject{
    
    NSString *overenrollmentstatus;
    NSString *sameinstructormulticlassstatus;
    NSString *alreadyenrolledstatus;
    NSString *sameclassroommulticlassstatus;
    NSString *hasextendedchildclassstatus;
    NSString *classroomexceedcapacitystatus;
    NSString *makeupquotaexceedstatus;
    
    
}
@property (strong,nonatomic) NSString *overenrollmentstatus;
@property (strong,nonatomic) NSString *sameinstructormulticlassstatus;
@property (strong,nonatomic) NSString *alreadyenrolledstatus;
@property (strong,nonatomic) NSString *sameclassroommulticlassstatus;
@property (strong,nonatomic) NSString *hasextendedchildclassstatus;
@property (strong,nonatomic) NSString *classroomexceedcapacitystatus;
@property (strong,nonatomic) NSString *makeupquotaexceedstatus;

#pragma mark -
#pragma mark Class Methods

-(id)initClassValidateStatuswithoverenrollmentstatus:(NSString *)coverenrollmentstatus sameinstructormulticlassstatus:(NSString *)csameinstructormulticlassstatus alreadyenrolledstatus:(NSString *)calreadyenrolledstatus sameclassroommulticlassstatus:(NSString *)csameclassroommulticlassstatus hasextendedchildclassstatus:(NSString *)chasextendedchildclassstatus classroomexceedcapacitystatus:(NSString *)cclassroomexceedcapacitystatus makeupquotaexceedstatus:(NSString *)cmakeupquotaexceedstatus;

@end

@interface ClassValidateRecord : NSObject{
    
    NSString *classkey;
    NSString *status;
    ClassValidateStatus *classvalidatestatus;
    ClassValidateMessage *classvalidatemessage;
    
    
}
@property (strong,nonatomic) NSString *classkey;
@property (strong,nonatomic) NSString *status;
@property (strong,nonatomic) ClassValidateStatus *classvalidatestatus;
@property (strong,nonatomic) ClassValidateMessage *classvalidatemessage;

#pragma mark -
#pragma mark Class Methods

-(id)initClassValidateRecordwithstatus:(NSString *)cstatus classvalidatestatus:(ClassValidateStatus *)cclassvalidatestatus classvalidmessage:(ClassValidateMessage *)cclassvalidmessage classkey:(NSString *)cclasskey;

@end


@interface ClassExtendRecord : NSObject{
    
    NSString *classkey;
    NSArray *classkeyarray;
    
}
@property (strong,nonatomic) NSString *classkey;
@property (strong,nonatomic) NSArray *classkeyarray;

#pragma mark -
#pragma mark Class Methods

-(id)initClassExtendRecordwithclasskey:(NSString *)cclasskey classkeyarray:(NSArray *)cclasskeyarray;

@end

@interface Student : NSObject{
    NSString *studentkey;
    NSString *studentid;
    NSString *firstname;
    NSString *lastname;
    NSString *othername;
    NSString *gender;
    NSString *dateofbirth;
    NSString *age;
    NSString *grade;
    NSString *preferredlanguage;
    NSString *school;
    
    NSString *parentname;
    NSString *parentname2;
    //NSString *parentcontact;
    NSMutableArray *phonearray;
    NSString *parentemail;
    NSString *parentaddress;
    
    NSString *remarks;
    NSString *flag;
    NSString *status;
    NSString *promotion;
    NSString *image;

//    NSString *math_hq;
//    NSString *eng_hq;
//    NSString *playmath_hq;
//    NSString *spark_hq;
//    NSString *htalk_hq;
    NSString *leadkey;
    NSString *studentmedia;
    NSString *studentsource;
    NSMutableArray *siblingarray;
    ClassValidateRecord *photoalbumrecord;
    NSString *centerkey;
    NSString *due;
    NSString *avatar;
    BOOL sendmessage;
    NSString *displayfullname;
    NSString *fcmemberid;
    BOOL ddaenabled;
    NSString *ddaaccountno;
    NSString *ddaaccountname;
    NSString *ddadebtorreference;
    NSString *ddalimit;
    NSString *extrafield1;
    NSString *validcouponcount;
    NSString *extrafield2;
    float creditamount;
}

@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * studentid;
@property (strong,nonatomic) NSString * firstname;
@property (strong,nonatomic) NSString * lastname;
@property (strong,nonatomic) NSString * othername;
@property (strong,nonatomic) NSString * gender;
@property (strong,nonatomic) NSString * dateofbirth;
@property (strong,nonatomic) NSString * age;
@property (strong,nonatomic) NSString * grade;
@property (strong,nonatomic) NSString * preferredlanguage;
@property (strong,nonatomic) NSString * school;

@property (strong,nonatomic) NSString * parentname;
@property (strong,nonatomic) NSString * parentname2;
@property (strong,nonatomic) NSMutableArray * phonearray;
@property (strong,nonatomic) NSString * parentemail;
@property (strong,nonatomic) NSString * parentaddress;

@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * flag;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) NSString * promotion;
@property (strong,nonatomic) NSString * image;

//@property (strong,nonatomic) NSString * math_hq;
//@property (strong,nonatomic) NSString * eng_hq;
//@property (strong,nonatomic) NSString * playmath_hq;
//@property (strong,nonatomic) NSString * spark_hq;
//@property (strong,nonatomic) NSString * htalk_hq;
@property (strong,nonatomic) NSString * leadkey;
@property (strong,nonatomic) NSString * studentmedia;
@property (strong,nonatomic) NSString * studentsource;
@property (strong,nonatomic) NSMutableArray * siblingarray;
@property (strong,nonatomic) ClassValidateRecord *photoalbumrecord;
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * due;
@property (strong,nonatomic) NSString * avatar;
@property (nonatomic) BOOL sendmessage;
@property (strong,nonatomic) NSString * displayfullname;
@property (strong,nonatomic) NSString * fcmemberid;
@property (nonatomic) BOOL ddaenabled;
@property (strong,nonatomic) NSString * ddaaccountno;
@property (strong,nonatomic) NSString * ddaaccountname;
@property (strong,nonatomic) NSString * ddadebtorreference;
@property (strong,nonatomic) NSString * ddalimit;
@property (strong,nonatomic) NSString * extrafield1;
@property (strong,nonatomic) NSString *validcouponcount;
@property (strong,nonatomic) NSString * extrafield2;
@property (nonatomic) float creditamount;

#pragma mark -
#pragma mark Class Methods

-(id)initStudentWithstudentkey:(NSString *)sstudentkey studentid:(NSString *)sstudentid firstname:(NSString *)sfirstname lastname:(NSString *)slastname othername:(NSString *)sothername gender:(NSString *)sgender dateofbirth:(NSString *)sdateofbirth age:(NSString *)sage grade:(NSString *)sgrade preferredlanguage: (NSString *)spreferredlanguage school:(NSString *)sschool parentname:(NSString *)sparentname phonearray:(NSMutableArray *)sphonearray parentemail:(NSString *)sparentemail parentaddress:(NSString *)sparentaddress remarks:(NSString *)sremarks flag:(NSString *)sflag status:(NSString *)sstatus promotion:(NSString *)spromotion image:(NSString *)simage leadkey:(NSString *)sleadkey studentmedia:(NSString *)sstudentmedia studentsource:(NSString *)sstudentsource siblingarray:(NSMutableArray *)ssiblingarray photoalbumrecord:(ClassValidateRecord *)sphotoalbumrecord centerkey:(NSString *)scenterkey due:(NSString *)sdue avatar:(NSString *)savatar sendmessage:(BOOL)ssendmessage displayfullname:(NSString *)sdisplayfullname fcmemberid:(NSString *)sfcmemberid ddaenabled:(BOOL)sddaenabled ddaaccountno:(NSString *)sddaaccountno ddaaccountname:(NSString *)sddaaccountname ddadebtorreference:(NSString *)sddadebtorreference ddalimit:(NSString *)sddalimit extrafield1:(NSString *)sextrafield1 parentname2:(NSString *)sparentname2 validcouponcount:(NSString *)svalidcouponcount extrafield2:(NSString *)sextrafield2 creditamount:(float)screditamount;


@end

@interface Instructor : NSObject
{
    
    NSString *staffkey;
    NSString *firstname;
    NSString *lastname;
    NSString *username;
    NSString *phone;
    NSString *valid;
    BOOL staffschedule;
    ClassValidateRecord *photoalbumrecord;
}

@property (strong,nonatomic) NSString * staffkey;
@property (strong,nonatomic) NSString * firstname;
@property (strong,nonatomic) NSString * lastname;
@property (strong,nonatomic) NSString * username;
@property (strong,nonatomic) NSString * phone;
@property (nonatomic) BOOL staffschedule;
@property (strong,nonatomic) NSString * valid;
@property (strong,nonatomic) ClassValidateRecord *photoalbumrecord;


#pragma mark -
#pragma mark Class Methods

-(id)initInstructortWithstaffkey:(NSString *)sstaffkey firstname:(NSString *)sfirstname lastname:(NSString *)slastname username:(NSString *)susername phone:(NSString *)sphone valid:(NSString *)svalid photoalbumrecord:(ClassValidateRecord *)sphotoalbumrecord staffschedule:(BOOL)sstaffschedule;


@end

@interface Staff : NSObject
{
    NSString *centerkey;
    NSString *staffkey;
    NSString *firstname;
    NSString *lastname;
    NSString *status;
    NSString *role;
    NSString *username;
    NSString *privilege;
    NSMutableArray *grouparray;
    NSString *phone;
    BOOL centerapp;
    BOOL staffapp;
    BOOL biapp;
    BOOL staffschedule;
    BOOL confirmmakeuprequest;
    NSString *salaryrate;
    NSString *remarks;
    NSMutableDictionary *staffscheduledict;
    NSString *iso_code;
    NSInteger colorcode;
    NSString *avatar;
    
    BOOL showlastclass;
    BOOL showfirstclass;
    BOOL showoutstandingclass;
    BOOL showpendingrenewalclass;
    BOOL showassessclass;
    BOOL showtrialclass;
    BOOL showmakeupclass;
    BOOL showabsentclass;
    NSString *classtimetabledaystodisplay;
//    BOOL showtimetablelevel;
    NSString *studentlistsortingorder;
    NSString *leadlistsortingorder;
    NSInteger timetablezoommode;
//    BOOL showtimetableinstructor;
//    BOOL showtimetableclassroom;
    NSString *effectiveresignationdate;
    NSMutableArray *competencyarray;
}

@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * staffkey;
@property (strong,nonatomic) NSString * firstname;
@property (strong,nonatomic) NSString * lastname;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) NSString * role;
@property (strong,nonatomic) NSString * username;
@property (strong,nonatomic) NSString * privilege;
@property (strong,nonatomic) NSMutableArray * grouparray;
@property (strong,nonatomic) NSString * phone;
@property (nonatomic) BOOL centerapp;
@property (nonatomic) BOOL staffapp;
@property (nonatomic) BOOL biapp;
@property (nonatomic) BOOL staffschedule;
@property (strong,nonatomic) NSString * salaryrate;
@property (strong,nonatomic) NSString * remarks;
@property (nonatomic) BOOL confirmmakeuprequest;
@property (strong,nonatomic) NSMutableDictionary * staffscheduledict;
@property (strong,nonatomic) NSString * iso_code;
@property (nonatomic) NSInteger colorcode;
@property (strong,nonatomic) NSString * avatar;
@property (nonatomic) BOOL showlastclass;
@property (nonatomic) BOOL showfirstclass;
@property (nonatomic) BOOL showoutstandingclass;
@property (nonatomic) BOOL showpendingrenewalclass;
@property (nonatomic) BOOL showassessclass;
@property (nonatomic) BOOL showtrialclass;
@property (nonatomic) BOOL showmakeupclass;
@property (nonatomic) BOOL showabsentclass;
@property (strong,nonatomic) NSString * classtimetabledaystodisplay;
@property (strong,nonatomic) NSString *defaultarckey;
@property (nonatomic) NSInteger a4trayfora5printing_invoice;
@property (nonatomic) NSInteger a4trayfora5printing_receipt;
//@property (nonatomic) BOOL showtimetablelevel;
@property (strong,nonatomic) NSString * studentlistsortingorder;
@property (strong,nonatomic) NSString * leadlistsortingorder;
@property (nonatomic) NSInteger timetablezoommode;
//@property (nonatomic) BOOL showtimetableinstructor;
//@property (nonatomic) BOOL showtimetableclassroom;
@property (strong,nonatomic) NSString *effectiveresignationdate;
@property (strong,nonatomic) NSMutableArray * competencyarray;

#pragma mark -
#pragma mark Class Methods

-(id)initStaffWithCenterkey:(NSString *)scenterkey Staffkey:(NSString *)sstaffkey firstname:(NSString *)sfirstname lastname:(NSString *)slastname status:(NSString *)sstatus role:(NSString *)srole username:(NSString *)susername privilege:(NSString *)sprivilege grouparray:(NSMutableArray *)sgrouparray phone:(NSString *)sphone centerapp:(BOOL)scenterapp staffapp:(BOOL)sstaffapp biapp:(BOOL)sbiapp salaryrate:(NSString *)ssalaryrate remarks:(NSString *)sremarks staffschedule:(BOOL)sstaffschedule confirmmakeuprequest:(BOOL)sconfirmmakeuprequest staffscheduledict:(NSMutableDictionary *)sstaffscheduledict iso_code:(NSString *)siso_code colorcode:(NSInteger)scolorcode avatar:(NSString *)savatar showlastclass:(BOOL)sshowlastclass showfirstclass:(BOOL)sshowfirstclass showoutstandingclass:(BOOL)sshowoutstandingclass showpendingrenewalclass:(BOOL)sshowpendingrenewalclass showassessclass:(BOOL)sshowassessclass showtrialclass:(BOOL)sshowtrialclass showmakeupclass:(BOOL)sshowmakeupclass showabsentclass:(BOOL)sshowabsentclass classtimetabledaystodisplay:(NSString *)sclasstimetabledaystodisplay defaultarckey:(NSString *)sdefaultarckey a4trayfora5printing_invoice:(NSInteger)sa4trayfora5printing_invoice a4trayfora5printing_receipt:(NSInteger)sa4trayfora5printing_receipt studentlistsortingorder:(NSString *)sstudentlistsortingorder leadlistsortingorder:(NSString *)sleadlistsortingorder timetablezoommode:(NSInteger)stimetablezoommode effectiveresignationdate:(NSString *)seffectiveresignationdate competencyarray:(NSMutableArray *)scompetencyarray;

@end

@interface RecipientGroupRecord : NSObject{
    NSMutableArray *individualarray;
    NSMutableArray *subjectarray;
    NSMutableArray *instructorarray;
    NSMutableArray *classdatearray;
    NSMutableArray *gradearray;
    NSMutableArray *studentstatusarray;
    NSMutableArray *leadstatusarray;
    NSMutableArray *staffgrouparray;
    NSMutableArray *droparray;
    NSMutableArray *activearray;
    NSMutableArray *paymentstatusarray;
    NSMutableArray *productarray;
}

@property (strong,nonatomic) NSMutableArray * individualarray;
@property (strong,nonatomic) NSMutableArray * subjectarray;
@property (strong,nonatomic) NSMutableArray * instructorarray;
@property (strong,nonatomic) NSMutableArray * classdatearray;
@property (strong,nonatomic) NSMutableArray * gradearray;
@property (strong,nonatomic) NSMutableArray * studentstatusarray;
@property (strong,nonatomic) NSMutableArray * leadstatusarray;
@property (strong,nonatomic) NSMutableArray * staffgrouparray;
@property (strong,nonatomic) NSMutableArray * droparray;
@property (strong,nonatomic) NSMutableArray * activearray;
@property (strong,nonatomic) NSMutableArray * paymentstatusarray;
@property (strong,nonatomic) NSMutableArray * productarray;

-(id)initRecipientGroupRecordwithIndividualArray:(NSMutableArray *)sindividualarray SubjectArray:(NSMutableArray *)ssubjectarray InstructorArray:(NSMutableArray *)sinstructorarray ClassDateArray:(NSMutableArray *)sclassdatearray GradeArray:(NSMutableArray *)sgradearray StudentStatusArray:(NSMutableArray *)sstudentstatusarray LeadStatusArray:(NSMutableArray *)sleadstatusarray StaffGroupArray:(NSMutableArray *)sstaffgrouparray DropArray:(NSMutableArray *)sdroparray ActiveArray:(NSMutableArray *)sactivearray paymentstatusarray:(NSMutableArray *)spaymentstatusarray productarray:(NSMutableArray *)sproductarray;


@end

@interface OutboxMessageRecord : NSObject{
    NSString *outboxmessagekey;
    NSString *messagetype;
    NSString *messagechinese;
    NSString *messageenglish;
    NSString *messagecreatetime;
    NSString *messagestarttime;
    NSString *automessageflag;
    NSString *recipienttype;
    NSString *channel;
    NSString *status;
    RecipientGroupRecord *recipientgroup;
    NSString *sender;
    NSMutableArray *photoarray;
    BOOL hotnews;
    NSString *hn_expiry_date;
    NSString *readstatus;
    NSString *composer;
    
}

@property (strong,nonatomic) NSString * outboxmessagekey;
@property (strong,nonatomic) NSString * messagetype;
@property (strong,nonatomic) NSString * messageenglish;
@property (strong,nonatomic) NSString * messagechinese;
@property (strong,nonatomic) NSString * messagecreatetime;
@property (strong,nonatomic) NSString * messagestarttime;
@property (strong,nonatomic) NSString * automessageflag;
@property (strong,nonatomic) NSString * channel;
@property (strong,nonatomic) NSString * recipienttype;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) RecipientGroupRecord *recipientgroup;
@property (strong,nonatomic) NSString *sender;
@property (strong,nonatomic) NSMutableArray *photoarray;
@property (nonatomic) BOOL hotnews;
@property (strong,nonatomic) NSString * hn_expiry_date;
@property (strong,nonatomic) NSString * readstatus;
@property (strong,nonatomic) NSString * composer;

-(id)initOutboxMessageRecordwithOutboxMessagekey:(NSString *)soutboxmessagekey Messagetype:(NSString *)smessagetype MessageEnglish:(NSString *)smessageenglish MessageChinese:(NSString *)smessagechinese MessageCreateTime:(NSString *)smessagecreatetime MessageStartTime:(NSString *)smessagestarttime AutoMessageFlag:(NSString *)sautomessageflag Channel:(NSString *)schannel ReciptientType:(NSString *)srecipienttype Status:(NSString *)sstatus RecipientGroup:(RecipientGroupRecord *)srecipientgroup Sender:(NSString *)ssender photoarray:(NSMutableArray *)sphotoarray hotnews:(BOOL)shotnews hn_expiry_date:(NSString *)shn_expiry_date readstatus:(NSString *)sreadstatus composer:(NSString *)scomposer;


@end

@interface ClassRecord : NSObject{
    NSString *studentkey;
    NSString *enrollmentkey;
    NSString *classkey;
    NSString *subject;
    NSString *levelmain;
    NSString *levelctm;
    NSString *startdate;
    NSString *classday;
    NSString *classtime;
    NSString *instructor;
    //NSString *absent;
    //NSString *makeup;
    NSString *attendance;
    NSString *makeupattendance;
    NSString *makeupdate;
    NSString *makeuptime;
    NSString *remarks;
    NSString *allclassremarks;
    NSString *makeupinstructor;
    NSString *makeupclassroom;
    NSString *absentmakeupreason;
    NSString *draft;
    NSString *classroom;
    NSString *schedulekey;
    NSString *status;
    NSString *extendedminute;
    NSString *extensiontime;
    NSString *orderdatetime;
    NSString *instructorfullname;
    NSString *makeupinstructorfullname;
    NSString *subjectfullname;
    NSString *parentnote;
    int assessmentformcount;
    NSString * leavenaturelistkey;
    BOOL makeupquotaavailable;
    OutboxMessageRecord *voiceparentnotemessage;
    NSString *lesson;
    NSString *sinstructor;
    NSString *makeupsinstructor;
    BOOL locked;
    BOOL enrollmentpaid;
    BOOL expiredpromotion;
    BOOL hasextendedclass;
}

@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * enrollmentkey;
@property (strong,nonatomic) NSString * classkey;
@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * levelmain;
@property (strong,nonatomic) NSString * levelctm;
@property (strong,nonatomic) NSString * startdate;
@property (strong,nonatomic) NSString * classday;
@property (strong,nonatomic) NSString * classtime;
@property (strong,nonatomic) NSString * instructor;
//@property (strong,nonatomic) NSString * absent;
//@property (strong,nonatomic) NSString * makeup;
@property (strong,nonatomic) NSString *attendance;
@property (strong,nonatomic) NSString *makeupattendance;
@property (strong,nonatomic) NSString * makeupdate;
@property (strong,nonatomic) NSString * makeuptime;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * allclassremarks;
@property (strong,nonatomic) NSString * makeupinstructor;
@property (strong,nonatomic) NSString * makeupclassroom;
@property (strong,nonatomic) NSString * absentmakeupreason;
@property (strong,nonatomic) NSString * draft;
@property (strong,nonatomic) NSString * classroom;
@property (strong,nonatomic) NSString * schedulekey;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) NSString * extendedminute;
@property (strong,nonatomic) NSString * extensiontime;
@property (strong,nonatomic) NSString * orderdatetime;
@property (strong,nonatomic) NSString * instructorfullname;
@property (strong,nonatomic) NSString * makeupinstructorfullname;
@property (strong,nonatomic) NSString * subjectfullname;
@property (strong,nonatomic) NSString * parentnote;
@property (nonatomic) int assessmentformcount;
@property (strong,nonatomic) NSString * leavenaturelistkey;
@property (nonatomic) BOOL makeupquotaavailable;
@property (strong,nonatomic) OutboxMessageRecord * voiceparentnotemessage;
@property (strong,nonatomic) NSString * lesson;
@property (strong,nonatomic) NSString *sinstructor;
@property (strong,nonatomic) NSString *makeupsinstructor;
@property (nonatomic) BOOL locked;
@property (nonatomic) BOOL enrollmentpaid;
@property (nonatomic) BOOL expiredpromotion;
@property (nonatomic) BOOL hasextendedclass;

#pragma mark -
#pragma mark Class Methods

-(id)initClassWithstudentkey: (NSString *)cstudentkey andenrollmentkey: (NSString *)cenrollmentkey andclasskey: (NSString *)cclasskey andsubject: (NSString *)csubject andlevelmain: (NSString *)clevelmain andlevelctm: (NSString *)clevelctm andstartdate: (NSString *)cstartdate andclassday: (NSString *)cclassday andclasstime: (NSString *)cclasstime andinstructor: (NSString *)cinstructor andattendance: (NSString *)cattendance andmakeupattendance: (NSString *)cmakeupattendance andmakeupdate: (NSString *)cmakeupdate andmakeuptime: (NSString *)cmakeuptime andremarks: (NSString *)cremarks andallclassremarks: (NSString *)callclassremarks andmakeupinstructor:(NSString *)cmakeupinstructor andmakeupclassroom:(NSString *)cmakeupclassroom andabsentmakeupreason:(NSString *)cabsentmakeupreason anddraft:(NSString *)cdraft andclassroom:(NSString *)cclassroom andschedulekey:(NSString *)cschedulekey andstatus:(NSString *)cstatus andextendedminute:(NSString *)cextendedminute andextensiontime:(NSString *)cextensiontime orderdatetime:(NSString *)corderdatetime instructorfullname:(NSString *)cinstructorfullname makeupinstructorfullname:(NSString *)cmakeupinstructorfullname subjectfullname:(NSString *)csubjectfullname parentnote:(NSString *)cparentnote assessmentformcount:(int)cassessmentformcount leavenaturelistkey:(NSString *)cleavenaturelistkey makeupquotaavailable:(BOOL)cmakeupquotaavailable voiceparentnotemessage:(OutboxMessageRecord *)cvoiceparentnotemessage lesson:(NSString *)clesson  sinstructor:(NSString *)csinstructor makeupsinstructor:(NSString *)cmakeupsinstructor locked:(BOOL)clocked enrollmentpaid:(BOOL)cenrollmentpaid expiredpromotion:(BOOL)cexpiredpromotion hasextendedclass:(BOOL)chasextendedclass;


@end

@interface ClassRecord2 : NSObject{
    NSString *classtype;
    NSString *type;
    NSString *typekey;
    NSString *classtypekey;
    NSString *subject;
    NSString *attendance;
    NSString *duration;
    NSString *extendedminute;
    NSString *startdate;
    NSString *classtime;
    NSString *instructor;
    NSString *classroom;
    NSString *makeupattendance;
    NSString *makeupdate;
    NSString *makeuptime;
    NSString *makeupinstructor;
    NSString *makeupclassroom;
    NSString *remarks;
    NSString *allclassremarks;
    NSString *absentmakeupreason;
    NSString *parentnote;
    NSString *request_status;
    NSString *request_for_value;
    NSString *request_for_leavenaturelistkey;
    NSString *request_for_value_reason;
    NSString *request_for_date;
    NSString *request_for_time;
    NSString *leavenaturelistkey;
}

@property (strong,nonatomic) NSString *classtype;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *typekey;
@property (strong,nonatomic) NSString *classtypekey;
@property (strong,nonatomic) NSString *subject;
@property (strong,nonatomic) NSString *attendance;
@property (strong,nonatomic) NSString *duration;
@property (strong,nonatomic) NSString *extendedminute;
@property (strong,nonatomic) NSString *startdate;
@property (strong,nonatomic) NSString *classtime;
@property (strong,nonatomic) NSString *instructor;
@property (strong,nonatomic) NSString *classroom;
@property (strong,nonatomic) NSString *makeupattendance;
@property (strong,nonatomic) NSString *makeupdate;
@property (strong,nonatomic) NSString *makeuptime;
@property (strong,nonatomic) NSString *makeupinstructor;
@property (strong,nonatomic) NSString *makeupclassroom;
@property (strong,nonatomic) NSString *remarks;
@property (strong,nonatomic) NSString *allclassremarks;
@property (strong,nonatomic) NSString *absentmakeupreason;
@property (strong,nonatomic) NSString *parentnote;
@property (strong,nonatomic) NSString *request_status;
@property (strong,nonatomic) NSString *request_for_value;
@property (strong,nonatomic) NSString *request_for_leavenaturelistkey;
@property (strong,nonatomic) NSString *request_for_value_reason;
@property (strong,nonatomic) NSString *request_for_date;
@property (strong,nonatomic) NSString *request_for_time;
@property (strong,nonatomic) NSString *leavenaturelistkey;


#pragma mark -
#pragma mark Class Methods

-(id)initClassWithclasstype:(NSString *)cclasstype type:(NSString *)ctype typekey:(NSString *)ctypekey classtypekey:(NSString *)cclasstypekey subject:(NSString *)csubject attendance:(NSString *)cattendance duration:(NSString *)cduration extendedminute:(NSString *)cextendedminute startdate:(NSString *)cstartdate classtime:(NSString *)cclasstime instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom makeupattendance:(NSString *)cmakeupattendance makeupdate:(NSString *)cmakeupdate makeuptime:(NSString *)cmakeuptime makeupinstructor:(NSString *)cmakeupinstructor makeupclassroom:(NSString *)cmakeupclassroom remarks:(NSString *)cremarks allclassremarks:(NSString *)callclassremarks absentmakeupreason:(NSString *)cabsentmakeupreason parentnote:(NSString *)cparentnote request_status:(NSString *)crequest_status request_for_value:(NSString *)crequest_for_value request_for_leavenaturelistkey:(NSString *)crequest_for_leavenaturelistkey request_for_value_reason:(NSString *)crequest_for_value_reason request_for_date:(NSString *)crequest_for_date request_for_time:(NSString *)crequest_for_time leavenaturelistkey:(NSString *)cleavenaturelistkey;


@end

@interface EnrollmentRecord : NSObject{
    NSString *studentkey;
    NSString *enrollmentkey;
    NSString *enrollmentdate;
    NSString *schedulekey;
    NSString *subject;
    NSString *levelmain;
    NSString *levelctm;
    NSString *grade;
    NSString *startdate;
    NSString *noofclass;
    NSString *enddate;
    NSString *classday;
    NSString *classtime;
    NSString *instructor;
    NSString *enrollmentfee;
    NSString *tuitionfee;
    NSString *oneoffdiscount;
    NSString *recursivediscount;
    NSString *oneoffpercentagediscount;
    NSString *latefee;
    NSString *totalfee;
    NSString *paid;
    NSString *dropclassstatus;
    NSString *dropclassdate;
    NSString *remarks;
    NSString *draft;
    NSString *invoiceremarks;
    NSString *classroom;
    NSString *autorenew;
    NSString *status;
    NSString *reverseadjustment;
    NSString *instructorfullname;
    NSString *subjectfullname;
    NSString *validity;
    NSString *refundamount;
    NSString *refundmethod;
    NSString *makeup_quota;
    NSString *makeup_quota_used;
    //NSString *dropclassreason;
    NSMutableArray *paymentrecords;
    NSMutableArray *promotiondiscountrecords;
    NSMutableArray *classrecords;
    NSString *sinstructor;
    NSString *transferredfromenrollmentkey;
    NSString *enrollmentmode;
    NSString *standardnoofclassormonth;
    NSMutableArray *couponrecords;
    NSString *invoicenumber;
    NSString *invoiceprefix;
    BOOL locked;
    NSString *billdate;
    NSString *resumeclassdate;
    NSString *outstandingmakeupclasses;
}

@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * enrollmentkey;
@property (strong,nonatomic) NSString * enrollmentdate;
@property (strong,nonatomic) NSString * schedulekey;
@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * levelmain;
@property (strong,nonatomic) NSString * levelctm;
@property (strong,nonatomic) NSString * grade;
@property (strong,nonatomic) NSString * startdate;
@property (strong,nonatomic) NSString * noofclass;
@property (strong,nonatomic) NSString * enddate;
@property (strong,nonatomic) NSString * classday;
@property (strong,nonatomic) NSString * classtime;
@property (strong,nonatomic) NSString * instructor;
@property (strong,nonatomic) NSString * enrollmentfee;
@property (strong,nonatomic) NSString * tuitionfee;
@property (strong,nonatomic) NSString * oneoffdiscount;
@property (strong,nonatomic) NSString * recursivediscount;
@property (strong,nonatomic) NSString * oneoffpercentagediscount;
@property (strong,nonatomic) NSString * latefee;
@property (strong,nonatomic) NSString * totalfee;
@property (strong,nonatomic) NSString * paid;
@property (strong,nonatomic) NSString * dropclassstatus;
@property (strong,nonatomic) NSString * dropclassdate;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * draft;
@property (strong,nonatomic) NSString * invoiceremarks;
@property (strong,nonatomic) NSString * classroom;
@property (strong,nonatomic) NSString * autorenew;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) NSString * reverseadjustment;
@property (strong,nonatomic) NSString * instructorfullname;
@property (strong,nonatomic) NSString * subjectfullname;
@property (strong,nonatomic) NSString * validity;
@property (strong,nonatomic) NSString * makeup_quota;
@property (strong,nonatomic) NSString * makeup_quota_used;
@property (strong,nonatomic) NSMutableArray * paymentrecords;
@property (strong,nonatomic) NSMutableArray * promotiondiscountrecords;
@property (strong,nonatomic) NSMutableArray * classrecords;
@property (strong,nonatomic) NSString * sinstructor;
@property (strong,nonatomic) NSString *transferredfromenrollmentkey;
@property (strong,nonatomic) NSString *enrollmentmode;
@property (strong,nonatomic) NSString *standardnoofclassormonth;
@property (strong,nonatomic) NSMutableArray * couponrecords;
@property (strong,nonatomic) NSString *invoicenumber;
@property (strong,nonatomic) NSString *invoiceprefix;
@property (nonatomic) BOOL locked;
@property (strong,nonatomic) NSString *billdate;
@property (strong,nonatomic) NSString *resumeclassdate;
@property (strong,nonatomic) NSString *outstandingmakeupclasses;

#pragma mark -
#pragma mark Class Methods

-(id)initEnrollmentWithstudentkey:(NSString *)cstudentkey andenrollmentkey:(NSString *)cenrollmentkey andenrollmentdate:(NSString *)cenrollmentdate andschedulekey:(NSString *)cschedulekey andsubject: (NSString *)csubject andlevelmain:(NSString *)clevelmain andlevelctm:(NSString *)clevelctm andgrade:(NSString *)cgrade andstartdate:(NSString *)cstartdate andnoofclass:(NSString *)cnoofclass andenddate:(NSString *)cenddate andclassday:(NSString *)cclassday andclasstime: (NSString *)cclasstime andinstructor:(NSString *)cinstructor andenrollmentfee:(NSString *)cenrollmentfee andtuitionfee:(NSString *)ctuitionfee andoneoffdiscount:(NSString *)coneoffdiscount andrecursivediscount: (NSString *)crecursivediscount andoneoffpercentagediscount:(NSString *)coneoffpercentagediscount andlatefee:(NSString *)clatefee andtotalfee:(NSString *)ctotalfee andpaid:(NSString *)cpaid anddropclassstatus:(NSString *)cdropclassstatus anddropclassdate:(NSString *)cdropclassdate andremarks:(NSString *)cremarks anddraft:(NSString *)cdraft andinvoiceremarks:(NSString *)cinvoiceremarks andclassroom:(NSString *)cclassroom andautorenew:(NSString *)cautorenew andstatus:(NSString *)cstatus andreverseadjustment:(NSString *)creverseadjustment instructorfullname:(NSString *)cinstructorfullname subjectfullname:(NSString *)csubjectfullname validity:(NSString *)cvalidity makeup_quota:(NSString *)cmakeup_quota makeup_quota_used:(NSString *)cmakeup_quota_used paymentrecords:(NSMutableArray *)cpaymentrecords promotiondiscountrecords:(NSMutableArray *)cpromotiondiscountrecords classrecords:(NSMutableArray *)cclassrecords sinstructor:(NSString *)csinstructor transferredfromenrollmentkey:(NSString *)ctransferredfromenrollmentkey enrollmentmode:(NSString *)cenrollmentmode standardnoofclassormonth:(NSString *)cstandardnoofclassormonth couponrecords:(NSMutableArray *)ccouponrecords invoicenumber:(NSString *)cinvoicenumber invoiceprefix:(NSString *)cinvoiceprefix locked:(BOOL)clocked billdate:(NSString *)cbilldate resumeclassdate:(NSString *)cresumeclassdate outstandingmakeupclasses:(NSString *)coutstandingmakeupclasses;


@end


@interface RenewalRecord : NSObject{

    NSString *studentkey;
    NSString *enrollmentkey;
    NSString *studentfullname;
    NSString *subject;
    NSString *classday;
    NSString *classtime;
    NSString *levelmain;
    NSString *levelctm;
    NSString *remainingclass;
    NSString *remainingclassTBDmakeup;
    NSString *lastdate;
    NSString *renewalstartdate;
    NSString *schedulekey;
    NSString *remainingclassTBDclass;
    NSString *autorenew;
    NSString *coursetype;

}


@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * enrollmentkey;
@property (strong,nonatomic) NSString * studentfullname;

@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * classday;
@property (strong,nonatomic) NSString * classtime;

@property (strong,nonatomic) NSString * levelmain;
@property (strong,nonatomic) NSString * levelctm;
@property (strong,nonatomic) NSString * remainingclass;
@property (strong,nonatomic) NSString * remainingclassTBDmakeup;
@property (strong,nonatomic) NSString * lastdate;
@property (strong,nonatomic) NSString * renewalstartdate;
@property (strong,nonatomic) NSString * parentcontact;
@property (strong,nonatomic) NSString * schedulekey;
@property (strong,nonatomic) NSString * remainingclassTBDclass;
@property (strong,nonatomic) NSString * autorenew;
@property (strong,nonatomic) NSString * coursetype;

-(id)initRenewalRecordWithstudentkey: (NSString *)cstudentkey andenrollmentkey: (NSString *)cenrollmentkey andstudentfullname: (NSString *)cstudentfullname andclassday:(NSString *)cclassday andsubject: (NSString *)csubject andclasstime:(NSString *)cclasstime andlevelmain: (NSString *)clevelmain andlevelctm:(NSString *)clevelctm andremainingclass:(NSString *)cremainingclass andremainingclassTBDmakeup:(NSString *)cremainingclassTBDmakeup andlastdate:(NSString *)clastdate andrenewalstartdate:(NSString *)crenewalstartdate andschedulekey:(NSString *)cschedulekey andremainingclassTBDclass:(NSString *)cremainingclassTBDclass andautorenew:(NSString *)cautorenew coursetype:(NSString *)ccoursetype;


@end

@interface OutstandingPaymentRecord : NSObject{
    
    NSString *enrollmentkey;
    NSString *studentkey;
    NSString *studentfullname;
    NSString *enrollmentdate;
    NSString *subject;
    NSString *classday;
    NSString *classtime;
    NSString *startdate;
    NSString *enddate;
    NSString *noofclass;
    NSString *totalfee;
    NSString *paid;
    NSString *outstanding;
    NSString *parentcontact;
    NSString *gender;
    NSString *image;
    NSString *studentid;
    NSString *subjectfullname;
    NSString *lastpaymentkey;
}

@property (strong,nonatomic) NSString * type;
@property (strong,nonatomic) NSString * enrollmentkey;
@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * studentfullname;
@property (strong,nonatomic) NSString * enrollmentdate;
@property (strong,nonatomic) NSString * subject;

@property (strong,nonatomic) NSString * classday;
@property (strong,nonatomic) NSString * classtime;
@property (strong,nonatomic) NSString * startdate;

@property (strong,nonatomic) NSString * enddate;
@property (strong,nonatomic) NSString * noofclass;
@property (strong,nonatomic) NSString * totalfee;
@property (strong,nonatomic) NSString * paid;
@property (strong,nonatomic) NSString * outstanding;
@property (strong,nonatomic) NSString * parentcontact;
@property (strong,nonatomic) NSString * gender;
@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString * studentid;
@property (strong,nonatomic) NSString * subjectfullname;
@property (strong,nonatomic) NSString * lastpaymentkey;




-(id)initOutstandingPaymentRecordWithStudentkey: (NSString *)cstudentkey andenrollmentkey: (NSString *)cenrollmentkey andstudentfullname: (NSString *)cstudentfullname andenrollmentdate:(NSString *)cenrollmentdate andsubject: (NSString *)csubject andclassday:(NSString *)cclassday andclasstime:(NSString *)cclasstime andstartdate: (NSString *)cstartdate andenddate:(NSString *)cenddate andnoofclass:(NSString *)cnoofclass andtotalfee:(NSString *)ctotalfee andpaid:(NSString *)cpaid andoutstanding:(NSString *)coutstanding andparentcontact:(NSString *)cparentcontact andgender:(NSString *)cgender andimage:(NSString *)cimage andstudentid:(NSString *)cstudentid andsubjectfullname:(NSString *)csubjectfullname lastpaymentkey:(NSString *)clastpaymentkey;



@end

@interface OutstandingSalesPaymentRecord : NSObject{
    
    NSString *saleskey;
    NSString *studentkey;
    NSString *orderdate;
    NSString *studentfullname;
    NSString *product;
    NSString *quantity;
    NSString *totalfee;
    NSString *paid;
    NSString *outstanding;
    NSString *parentcontact;
    NSString *gender;
    NSString *image;
    NSString *studentid;
    NSString *productfullname;
    NSString *lastpaymentkey;
    
}

@property (strong,nonatomic) NSString * saleskey;
@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * orderdate;
@property (strong,nonatomic) NSString * studentfullname;
@property (strong,nonatomic) NSString * product;
@property (strong,nonatomic) NSString * quantity;
@property (strong,nonatomic) NSString * totalfee;
@property (strong,nonatomic) NSString * paid;
@property (strong,nonatomic) NSString * outstanding;
@property (strong,nonatomic) NSString * parentcontact;
@property (strong,nonatomic) NSString * gender;
@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString * studentid;
@property (strong,nonatomic) NSString * productfullname;
@property (strong,nonatomic) NSString * lastpaymentkey;

-(id)initOutstandingSalesPaymentRecordWithSaleskey:(NSString *)csaleskey studentkey:(NSString *)cstudentkey orderdate:(NSString *)corderdate studentfullname:(NSString *)cstudentfullname product:(NSString *)cproduct quantity:(NSString *)cquantity totalfee:(NSString *)ctotalfee paid:(NSString *)cpaid outstanding:(NSString *)coutstanding parentcontact:(NSString *)cparentcontact andgender:(NSString *)cgender andimage:(NSString *)cimage andstudentid:(NSString *)cstudentid andproductfullname:(NSString *)cproductfullname lastpaymentkey:(NSString *)clastpaymentkey;



@end

@interface OutstandingBankinRecord : NSObject{
    
    NSString *bankindatetime;
    NSString *newpaymentreceivedcash;
    NSString *newpaymentreceivedcheque;
    NSString *bankinamountcash;
    NSString *bankinamountcheque;
    NSString *outstandingbankincash;
    NSString *outstandingbankincheque;
    NSString *bankinperson;
    NSString *remarks;

    
}


@property (strong,nonatomic) NSString * bankindatetime;
@property (strong,nonatomic) NSString * newpaymentreceivedcash;
@property (strong,nonatomic) NSString * newpaymentreceivedcheque;
@property (strong,nonatomic) NSString * bankinamountcash;
@property (strong,nonatomic) NSString * bankinamountcheque;
@property (strong,nonatomic) NSString * outstandingbankincash;
@property (strong,nonatomic) NSString * outstandingbankincheque;
@property (strong,nonatomic) NSString * bankinperson;
@property (strong,nonatomic) NSString * remarks;


-(id)initOutstandingBankinRecordWithbankindatetime:(NSString *)cbankindatetime newpaymentreceivedcash:(NSString *)cnewpaymentreceivedcash newpaymentreceivedcheque:(NSString *)cnewpaymentreceivedcheque bankinamountcash:(NSString *)cbankinamountcash bankinamountcheque:(NSString *)cbankinamountcheque outstandingbankincash:(NSString *)coutstandingbankincash outstandingbankincheque:(NSString *)coutstandingbankincheque bankinperson:(NSString *)cbankinperson remarks:(NSString *)cremarks;

@end

@interface ClassTimeTableRecord : NSObject
{
    NSString *startdate;
    NSString *classday;
    NSString *classtime;
    NSString *subject;
    NSString *instructor;
    NSString *classroom;
    NSMutableArray *studentarray;
    
}

@property (strong,nonatomic) NSString * startdate;
@property (strong,nonatomic) NSString * classday;
@property (strong,nonatomic) NSString * classtime;
@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * instructor;
@property (strong,nonatomic) NSString * classroom;
@property (strong,nonatomic) NSMutableArray * studentarray;


#pragma mark -
#pragma mark Class Methods

-(id)initClassTimeTableRecordWithstartdate:(NSString *)cstartdate classday:(NSString *)cclassday classtime:(NSString *)cclasstime subject:(NSString *)csubject instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom studentarray:(NSMutableArray *)cstudentarray;


@end

@interface ClassTimeTableRecord2 : NSObject
{
    NSString *startdate;
    NSString *classday;
    NSString *classtime;
    NSString *subject;
    NSString *instructor;
    NSString *classroom;
    NSString *studentkey;
    NSString *firstname;
    NSString *lastname;
    NSString *instructorfullname;
    NSString *subjectfullname;
    
    
}

@property (strong,nonatomic) NSString * startdate;
@property (strong,nonatomic) NSString * classday;
@property (strong,nonatomic) NSString * classtime;
@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * instructor;
@property (strong,nonatomic) NSString * classroom;
@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * firstname;
@property (strong,nonatomic) NSString * lastname;
@property (strong,nonatomic) NSString * instructorfullname;
@property (strong,nonatomic) NSString * subjectfullname;



#pragma mark -
#pragma mark Class Methods

-(id)initClassTimeTableRecordWithstartdate:(NSString *)cstartdate classday:(NSString *)cclassday classtime:(NSString *)cclasstime subject:(NSString *)csubject instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom studentkey:(NSString *)cstudentkey firstname:(NSString *)cfirstname lastname:(NSString *)clastname instructorfullname:(NSString *)cinstructorfullname subjectfullname:(NSString *)csubjectfullname;


@end


@interface ClassTimeTableRecord3 : NSObject
{
    
    int position;
    NSString *classday;
    NSString *classtime;
    NSString *subject;
    NSString *instructor;
    NSString *sinstructor;
    NSString *classroom;
    int classduration;
    NSMutableArray *studentarray;
    NSString *instructorfullname;
    NSString *subjectfullname;
    NSMutableArray *timevaluearray;
    NSString *subjecttype;
    NSString *schedulekey;
}

@property (nonatomic) int position;
@property (nonatomic) int classduration;
@property (strong,nonatomic) NSString * classday;
@property (strong,nonatomic) NSString * classtime;
@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * instructor;
@property (strong,nonatomic) NSString * sinstructor;
@property (strong,nonatomic) NSString * classroom;
@property (strong,nonatomic) NSMutableArray * studentarray;
@property (strong,nonatomic) NSString * instructorfullname;
@property (strong,nonatomic) NSString * subjectfullname;
@property (strong,nonatomic) NSMutableArray *timevaluearray;
@property (strong,nonatomic) NSString * subjecttype;
@property (strong,nonatomic) NSString *schedulekey;

#pragma mark -
#pragma mark Class Methods

-(id)initClassTimeTableRecord3Withclassday:(NSString *)cclassday classtime:(NSString *)cclasstime subject:(NSString *)csubject instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom classduration:(int)cclassduration studentarray:(NSMutableArray *)cstudentarray position:(int)cposition instructorfullname:(NSString *)cinstructorfullname subjectfullname:(NSString *)csubjectfullname timevaluearray:(NSMutableArray *)ctimevaluearray subjecttype:(NSString *)csubjecttype sinstructor:(NSString *)csinstructor schedulekey:(NSString *)cschedulekey;


@end


@interface ClassTimeTableSubRecord : NSObject
{
    
    NSString *classtype;
    NSString *type;
    NSString *typekey;
    NSString *attendance;
    NSString *levelmain;
    NSString *displayname;
    NSString *classkey;
    NSString *subject;
    NSString *outstanding;
    NSString *lesson;
    
}

@property (strong,nonatomic) NSString * classtype;
@property (strong,nonatomic) NSString * type;
@property (strong,nonatomic) NSString * typekey;
@property (strong,nonatomic) NSString * attendance;
@property (strong,nonatomic) NSString * levelmain;
@property (strong,nonatomic) NSString * displayname;
@property (strong,nonatomic) NSString * classkey;
@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * outstanding;
@property (strong,nonatomic) NSString * lesson;


#pragma mark -
#pragma mark Class Methods

-(id)initClassTimeTableSubRecordWithclasstype:(NSString *)cclasstype type:(NSString *)ctype typekey:(NSString *)ctypekey attendance:(NSString *)cattendance levelmain:(NSString *)clevelmain displayname:(NSString *)cdisplayname classkey:(NSString *)cclasskey subject:(NSString *)csubject outstanding:(NSString *)coutstanding lesson:(NSString *)clesson;

@end

@interface ClassScheduleRecord : NSObject{
    
    NSString *studentkey;
    NSString *enrollmentkey;
    NSString *classkey;
    NSString *dtkey;
    NSString *classtype;
    
    NSString *firstname;
    NSString *lastname;
    NSString *othername;
    NSString *gender;
    NSString *parentcontact;
    NSString *image;
    
    NSString *subject;
    NSString *levelmain;
    NSString *levelctm;
    NSString *startdate;
    NSString *classday;
    NSString *classtime;
    NSString *instructor;
    NSString *classroom;
    NSString *makeupdate;
    NSString *makeuptime;
    NSString *remarks;
    NSString *allclassremarks;
    NSString *makeupinstructor;
    NSString *makeupclassroom;
    NSString *absentmakeupreason;
    NSString *firstclass;
    NSString *nextclassalldaytime;
    NSString *lastscheduledclassalldaytime;
    NSString *remainingclassscheduled;
    NSString *remainingclassTBDclass;
    NSString *remainingclassTBDmakeup;
    NSString *remainingclassscheduledall;
    NSString *outstandingpayment;
    NSString *classduration;
    NSString *type;
    NSString *instructorfullname;
    NSString *autorenew;
    NSString *schedulekey;
    NSString *outstandingextendtime;
    NSString *extendedminute;
    NSString *status;
    NSString *extensiontime;
    NSString *subjectfullname;
    NSString *studentid;
    NSString *parentnote;
    NSString *studentdisplayname;
    int assessmentformcount;
    NSString * leavenaturelistkey;
    BOOL makeupquotaavailable;
    NSString *realclassroom;
    NSString *realclasstime;
    NSString *lesson;
    NSString *sinstructor;
    NSString *makeupsinstructor;
    NSString *sinstructorfullname;
    BOOL locked;
    BOOL enrollmentpaid;
}

@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * enrollmentkey;
@property (strong,nonatomic) NSString * classkey;
@property (strong,nonatomic) NSString * dtkey;
@property (strong,nonatomic) NSString * classtype;

@property (strong,nonatomic) NSString *firstname;
@property (strong,nonatomic) NSString *lastname;
@property (strong,nonatomic) NSString *othername;
@property (strong,nonatomic) NSString *gender;
@property (strong,nonatomic) NSString *parentcontact;
@property (strong,nonatomic) NSString *image;

@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * levelmain;
@property (strong,nonatomic) NSString * levelctm;
@property (strong,nonatomic) NSString * startdate;
@property (strong,nonatomic) NSString * classday;
@property (strong,nonatomic) NSString * classtime;
@property (strong,nonatomic) NSString * instructor;
@property (strong,nonatomic) NSString * classroom;
//@property (strong,nonatomic) NSString * absent;
//@property (strong,nonatomic) NSString * makeup;
@property (strong,nonatomic) NSString * attendance;
@property (strong,nonatomic) NSString * makeupattendance;
@property (strong,nonatomic) NSString * makeupdate;
@property (strong,nonatomic) NSString * makeuptime;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * allclassremarks;
@property (strong,nonatomic) NSString * makeupinstructor;
@property (strong,nonatomic) NSString * makeupclassroom;
@property (strong,nonatomic) NSString * absentmakeupreason;
@property (strong,nonatomic) NSString * firstclass;
@property (strong,nonatomic) NSString * nextclassalldaytime;
@property (strong,nonatomic) NSString * lastscheduledclassalldaytime;
@property (strong,nonatomic) NSString * remainingclassscheduled;
@property (strong,nonatomic) NSString * remainingclassTBDclass;
@property (strong,nonatomic) NSString * remainingclassTBDmakeup;
@property (strong,nonatomic) NSString * remainingclassscheduledall;
@property (strong,nonatomic) NSString * outstandingpayment;
@property (strong,nonatomic) NSString * classduration;
@property (strong,nonatomic) NSString * type;
@property (strong,nonatomic) NSString *instructorfullname;
@property (strong,nonatomic) NSString *autorenew;
@property (strong,nonatomic) NSString *schedulekey;
@property (strong,nonatomic) NSString *outstandingextendtime;
@property (strong,nonatomic) NSString *extendedminute;
@property (strong,nonatomic) NSString *status;
@property (strong,nonatomic) NSString *extensiontime;
@property (strong,nonatomic) NSString *subjectfullname;
@property (strong,nonatomic) NSString *studentid;
@property (strong,nonatomic) NSString *parentnote;
@property (strong,nonatomic) NSString *studentdisplayname;
@property (nonatomic) int assessmentformcount;
@property (strong,nonatomic) NSString * leavenaturelistkey;
@property (nonatomic) BOOL makeupquotaavailable;
@property (strong,nonatomic) NSString *realclassroom;
@property (strong,nonatomic) NSString *realclasstime;
@property (strong,nonatomic) NSString *lesson;
@property (strong,nonatomic) NSString * sinstructor;
@property (strong,nonatomic) NSString * makeupsinstructor;
@property (strong,nonatomic) NSString *sinstructorfullname;
@property (nonatomic) BOOL locked;
@property (nonatomic) BOOL enrollmentpaid;
#pragma mark -
#pragma mark Class Methods

-(id)initClassScheduleRecordWithstudentkey:(NSString *)cstudentkey andenrollmentkey:(NSString *)cenrollmentkey andclasskey:(NSString *)cclasskey anddtkey:(NSString *)cdtkey andclasstype:(NSString *)cclasstype andfirstname:(NSString *)cfirstname andlastname:(NSString *)clastname andothername:(NSString *)cothername andgender:(NSString *)cgender andparentcontact:(NSString *)cparentcontact andimage:(NSString *)cimage andsubject:(NSString *)csubject andlevelmain:(NSString *)clevelmain andlevelctm:(NSString *)clevelctm andstartdate:(NSString *)cstartdate andclassday:(NSString *)cclassday andclasstime:(NSString *)cclasstime andinstructor:(NSString *)cinstructor andclassroom:(NSString *)cclassroom andattendance:(NSString *)cattendance andmakeupattendance:(NSString *)cmakeupattendance andmakeupdate:(NSString *)cmakeupdate andmakeuptime:(NSString *)cmakeuptime andremarks: (NSString *)cremarks andallclassremarks:(NSString *)callclassremarks andmakeupinstructor:(NSString *)cmakeupinstructor andmakeupclassroom:(NSString *)cmakeupclassroom andabsentmakeupreason:(NSString *)cabsentmakeupreason andfirstclass:(NSString *)cfirstclass andnextclassalldaytime:(NSString *)cnextclassalldaytime andlastscheduledclassalldaytime:(NSString *)clastscheduledclassalldaytime andremainingclassscheduled:(NSString *)cremainingclassscheduled andremainingclassTBDclass:(NSString *)cremainingclassTBDclass andremainingclassTBDmakeup:(NSString *)cremainingclassTBDmakeup andremainingclassscheduledall:(NSString *)cremainingclassscheduledall andoutstandingpayment:(NSString *)coutstandingpayment andclassduration:(NSString *)cclassduration type:(NSString *)ctype instructorfullname:(NSString *)cinstructorfullname autorenew:(NSString *)cautorenew schedulekey:(NSString *)cschedulekey outstandingextendtime:(NSString *)coutstandingextendtime extendedminute:(NSString *)cextendedminute status:(NSString *)cstatus extensiontime:(NSString *)cextensiontime subjectfullname:(NSString *)csubjectfullname studentid:(NSString *)cstudentid parentnote:(NSString *)cparentnote studentdisplayname:(NSString *)cstudentdisplayname assessmentformcount:(int)cassessmentformcount leavenaturelistkey:(NSString *)cleavenaturelistkey makeupquotaavailable:(BOOL)cmakeupquotaavailable realclassroom:(NSString *)crealclassroom realclasstime:(NSString *)crealclasstime lesson:(NSString *)clesson sinstructor:(NSString *)csinstructor makeupsinstructor:(NSString *)cmakeupsinstructor sinstructorfullname:(NSString *)csinstructorfullname locked:(BOOL)clocked enrollmentpaid:(BOOL)cenrollmentpaid;
@end

@interface DTRecord : NSObject{

    NSString *DTkey;
    NSString *DTstatus;
    NSString *preferredlanguage;
    
    NSString *DTdate;
    NSString *DTtime;
    
    NSString *subject;
    NSString *levelmain;
    NSString *levelctm;
    NSString *classduration;

    NSString *instructor;
    NSString *remarks;
    NSString *classtype;
    NSString *classroom;
    NSString *attendance;
    NSString *instructorfullname;
    NSString *subjectfullname;
    BOOL locked;
}

@property (strong,nonatomic) NSString *DTkey;
@property (strong,nonatomic) NSString *DTstatus;

@property (strong,nonatomic) NSString * DTdate;
@property (strong,nonatomic) NSString * DTtime;

@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * levelmain;
@property (strong,nonatomic) NSString * levelctm;
@property (strong,nonatomic) NSString * classduration;


@property (strong,nonatomic) NSString * instructor;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * classtype;
@property (strong,nonatomic) NSString * classroom;
@property (strong,nonatomic) NSString * attendance;
@property (strong,nonatomic) NSString * instructorfullname;
@property (strong,nonatomic) NSString * subjectfullname;
@property (nonatomic) BOOL locked;

#pragma mark -
#pragma mark Class Methods

-(id)initDTRecordWithDTkey:(NSString *)cdtkey DTStatus: (NSString *)cdtstatus andDTdate:(NSString *)cdtdate andDTtime:(NSString *)cdttime andsubject: (NSString *)csubject andlevelmain: (NSString *)clevelmain andlevelctm: (NSString *)clevelctm andclassduration: (NSString *)cclassduration andinstructor: (NSString *)cinstructor andremarks: (NSString *)cremarks andclasstype:(NSString *)cclasstype andclassroom:(NSString *)cclassroom andattendance:(NSString *)cattendance andinstructorfullname:(NSString *)cinstructorfullname andsubjectfullname:(NSString *)csubjectfullname andlocked:(BOOL)clocked;

@end

@interface AssessmentTrialRecord : NSObject{
    
    NSString *DTkey;
    NSString *type;
    NSString *leadkey;
    NSString *studentkey;
    NSString *firstname;
    NSString *lastname;
    NSString *othername;
    NSString *grade;
    NSString *gender;
    NSString *dateofbirth;
    NSString *age;
    NSString *school;
    NSString *parentname;
    NSString *parentcontact;
    NSString *parentemail;
    NSString *parentaddress;
    NSString *preferredlanguage;
    NSString *profileremarks;
    NSString *image;
    NSString *classtype;
    NSString *DTstatus;
    NSString *DTdate;
    NSString *DTtime;
    NSString *classduration;
    NSString *subject;
    NSString *levelmain;
    NSString *levelctm;
    NSString *instructor;
    NSString *remarks;
    NSString *media;
    NSString *source;
    NSString *classroom;
    NSString *attendance;
    NSString *studentfullname;
    NSString *instructorfullname;
    NSString *subjectfullname;
    NSString *iso_code;
    BOOL locked;
}

@property (strong,nonatomic) NSString *DTkey;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *leadkey;
@property (strong,nonatomic) NSString *studentkey;
@property (strong,nonatomic) NSString *firstname;
@property (strong,nonatomic) NSString *lastname;
@property (strong,nonatomic) NSString *othername;
@property (strong,nonatomic) NSString *grade;
@property (strong,nonatomic) NSString *gender;
@property (strong,nonatomic) NSString *dateofbirth;
@property (strong,nonatomic) NSString *age;
@property (strong,nonatomic) NSString *school;
@property (strong,nonatomic) NSString *parentname;
@property (strong,nonatomic) NSString *parentcontact;
@property (strong,nonatomic) NSString *parentemail;
@property (strong,nonatomic) NSString *parentaddress;
@property (strong,nonatomic) NSString *preferredlanguage;
@property (strong,nonatomic) NSString *profileremarks;
@property (strong,nonatomic) NSString *image;
@property (strong,nonatomic) NSString *classtype;
@property (strong,nonatomic) NSString *DTstatus;
@property (strong,nonatomic) NSString *DTdate;
@property (strong,nonatomic) NSString *DTtime;
@property (strong,nonatomic) NSString *classduration;
@property (strong,nonatomic) NSString *subject;
@property (strong,nonatomic) NSString *levelmain;
@property (strong,nonatomic) NSString *levelctm;
@property (strong,nonatomic) NSString *instructor;
@property (strong,nonatomic) NSString *remarks;
@property (strong,nonatomic) NSString *media;
@property (strong,nonatomic) NSString *source;
@property (strong,nonatomic) NSString *classroom;
@property (strong,nonatomic) NSString *attendance;
@property (strong,nonatomic) NSString *studentfullname;
@property (strong,nonatomic) NSString *instructorfullname;
@property (strong,nonatomic) NSString *subjectfullname;
@property (strong,nonatomic) NSString *iso_code;
@property (nonatomic) BOOL locked;

#pragma mark -
#pragma mark Class Methods

-(id)initAssessmentTrialRecordWithDTkey:(NSString *)cdtkey type:(NSString *)ctype leadkey:(NSString *)cleadkey studentkey:(NSString *)cstudentkey firstname:(NSString *)cfirstname lastname:(NSString *)clastname othername:(NSString *)cothername grade:(NSString *)cgrade gender:(NSString *)cgender dateofbirth:(NSString *)cdateofbirth age:(NSString *)cage school:(NSString *)cschool parentname:(NSString *)cparentname parentcontact:(NSString *)cparentcontact parentemail:(NSString *)cparentemail parentaddress:(NSString *)cparentaddress preferredlanguage:(NSString *)cpreferredlanguage profileremarks:(NSString *)cprofileremarks image:(NSString *)cimage classtype:(NSString *)cclasstype dtstatus:(NSString *)cdtstatus dtdate:(NSString *)cdtdate dttime:(NSString *)cdttime classduration:(NSString *)cclassduration subject:(NSString *)csubject levelmain:(NSString *)clevelmain levelctm:(NSString *)clevelctm instructor:(NSString *)cinstructor remarks:(NSString *)cremarks media:(NSString *)cmedia source:(NSString *)csource classroom:(NSString *)cclassroom attendance:(NSString *)cattendance studentfullname:(NSString *)cstudentfullname instructorfullname:(NSString *)cinstructorfullname subjectfullname:(NSString *)csubjectfullname iso_code:(NSString *)ciso_code locked:(BOOL)clocked;

@end



@interface ClassfeeRecord : NSObject{
    
    NSString *classfeekey;
    NSString *subject;
    NSString *fee;
    
}

@property (strong,nonatomic) NSString *classfeekey;
@property (strong,nonatomic) NSString *subject;
@property (strong,nonatomic) NSString *fee;



//#pragma mark -
//#pragma mark Class Methods

-(id)initClassfeeRecordwithClassfeeKey:(NSString *)cclassfeekey subject: (NSString *)csubject fee: (NSString *)cfee;



@end

@interface PaymentRecord : NSObject{
    
    NSString *paymentkey;
    NSString *paymenttype;
    NSString *paymenttypekey;
    NSString *paiddate;
    NSString *paidmethod;
    NSString *paidamount;
    NSString *action;
    NSString *paymentremarks;
    NSString *receiptremarks;
    NSString *staffname;
    NSString *receiptnumber;
    NSString *receiptprefix;
    
}

@property (strong,nonatomic) NSString *paymentkey;
@property (strong,nonatomic) NSString *paymenttype;
@property (strong,nonatomic) NSString *paymenttypekey;
@property (strong,nonatomic) NSString *paiddate;
@property (strong,nonatomic) NSString *paidmethod;
@property (strong,nonatomic) NSString *paidamount;
@property (strong,nonatomic) NSString *action;
@property (strong,nonatomic) NSString *paymentremarks;
@property (strong,nonatomic) NSString *receiptremarks;
@property (strong,nonatomic) NSString *staffname;
@property (strong,nonatomic) NSString *receiptnumber;
@property (strong,nonatomic) NSString *receiptprefix;

//#pragma mark -
//#pragma mark Class Methods

-(id)initPaymentRecordwithPaymentkey:(NSString *)cpaymentkey paymenttype:(NSString *)cpaymenttype paymenttypekey:(NSString *)cpaymenttypekey paiddate:(NSString *)cpaiddate paidmethod:(NSString *)cpaidmethod paidamount:(NSString *)cpaidamount action:(NSString *)caction paymentremarks:(NSString *)cpaymentremarks receiptremarks:(NSString *)creceiptremarks staffname:(NSString *)cstaffname receiptnumber:(NSString *)creceiptnumber receiptprefix:(NSString *)creceiptprefix;



@end

@interface TimeTableDetails : NSObject{
    
    NSString *timetablekey;
    NSString *type;
    NSString *classdate;
    NSString *classday;
    NSString *classtime;
    NSString *subtypevalue;
    NSString *block;
    NSString *caption;
    NSString *remarks;
    
}

@property (strong,nonatomic) NSString *timetablekey;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *classdate;
@property (strong,nonatomic) NSString *classday;
@property (strong,nonatomic) NSString *classtime;
@property (strong,nonatomic) NSString *subtypevalue;
@property (strong,nonatomic) NSString *classroom;
@property (strong,nonatomic) NSString *block;
@property (strong,nonatomic) NSString *caption;
@property (strong,nonatomic) NSString *remarks;

//#pragma mark -
//#pragma mark Class Methods

-(id)initTimeTableDetailsWithtimetablekey:(NSString *)ctimetablekey type: (NSString *)ctype classdate: (NSString *)cclassdate classday:(NSString *)cclassday classtime:(NSString *)cclasstime subtypevalue:(NSString *)csubtypevalue block:(NSString *)cblock caption:(NSString *)ccaption remarks:(NSString *)cremarks ;



@end

@interface FreeScheduleClass : NSObject{
    
    NSString *classkey;
    NSString *subject;
    NSString *classdate;
    NSString *classtime;
    NSString *instructor;
    NSString *classroom;
    NSString *attendance;
    NSString *makeupdate;
    NSString *makeuptime;
    NSString *makeupinstructor;
    NSString *makeupclassroom;
    NSString *makeupattendance;
    NSString *classremarks;
    NSString *allclassremarks;
    NSString *action;
    NSString *classtype;
    NSString *leavenaturelistkey;
    NSString *lesson;
    NSString *sinstructor;
    NSString *makeupsinstructor;
    BOOL locked;
}

@property (strong,nonatomic) NSString *classkey;
@property (strong,nonatomic) NSString *subject;
@property (strong,nonatomic) NSString *classdate;
@property (strong,nonatomic) NSString *classtime;
@property (strong,nonatomic) NSString *instructor;
@property (strong,nonatomic) NSString *classroom;
@property (strong,nonatomic) NSString *attendance;
@property (strong,nonatomic) NSString *makeupdate;
@property (strong,nonatomic) NSString *makeuptime;
@property (strong,nonatomic) NSString *makeupinstructor;
@property (strong,nonatomic) NSString *makeupclassroom;
@property (strong,nonatomic) NSString *makeupattendance;
@property (strong,nonatomic) NSString *classremarks;
@property (strong,nonatomic) NSString *allclassremarks;
@property (strong,nonatomic) NSString *action;
@property (strong,nonatomic) NSString *classtype;
@property (strong,nonatomic) NSString *leavenaturelistkey;
@property (strong,nonatomic) NSString *lesson;
@property (strong,nonatomic) NSString *sinstructor;
@property (strong,nonatomic) NSString *makeupsinstructor;
@property (nonatomic) BOOL locked;

//#pragma mark -
//#pragma mark Class Methods

-(id)initFreeScheduleClassWithclasskey:(NSString *)cclasskey subject:(NSString *)csubject classdate:(NSString *)cclassdate classtime: (NSString *)cclasstime instructor: (NSString *)cinstructor classroom:(NSString *)cclassroom attendance:(NSString *)cattendance makeupdate:(NSString *)cmakeupdate makeuptime: (NSString *)cmakeuptime makeupinstructor: (NSString *)cmakeupinstructor makeupclassroom:(NSString *)cmakeupclassroom makeupattendance:(NSString *)cmakeupattendance classremarks:(NSString *)cclassremarks allclassremarks:(NSString *)callclassremarks action:(NSString *)caction classtype:(NSString *)cclasstype leavenaturelistkey:(NSString *)cleavenaturelistkey lesson:(NSString *)clesson sinstructor:(NSString *)csinstructor makeupsinstructor:(NSString *)cmakeupsinstructor locked:(BOOL)clocked;



@end






@interface NotificationRecord : NSObject{
    NSString *recordtype;
    NSString *type;
    NSString *category;
    NSString *enrollmentkey;
    NSString *saleskey;
    NSString *classkey;
    NSString *studentkey;
    NSString *studentname;
    NSString *subjectcode;
    NSString *productcode;
    NSString *subjectname;
    NSString *productname;
    NSString *classdatetime;
    NSString *value;
    NSString *schedulekey;
    NSString *image;
    NSString *gender;

    
}

@property (strong,nonatomic) NSString * recordtype;
@property (strong,nonatomic) NSString * type;
@property (strong,nonatomic) NSString * category;
@property (strong,nonatomic) NSString * enrollmentkey;
@property (strong,nonatomic) NSString * saleskey;
@property (strong,nonatomic) NSString * classkey;
@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * studentname;
@property (strong,nonatomic) NSString * subjectcode;
@property (strong,nonatomic) NSString * productcode;
@property (strong,nonatomic) NSString * subjectname;
@property (strong,nonatomic) NSString * productname;
@property (strong,nonatomic) NSString * classdatetime;
@property (strong,nonatomic) NSString * value;
@property (strong,nonatomic) NSString * schedulekey;
@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString * gender;

-(id)initNotificationRecordwithRecordtype:(NSString *)srecordtype Type:(NSString *)stype Category:(NSString *)scategory Enrollmentkey:(NSString *)senrollmentkey Saleskey:(NSString *)ssaleskey Classkey:(NSString *)sclasskey Studentkey:(NSString *)sstudentkey Studentname:(NSString *)sstudentname Subjectcode:(NSString *)ssubjectcode Productcode:(NSString *)sproductcode Subjectname:(NSString *)ssubjectname Productname:(NSString *)sproductname Classdatetime:(NSString *)sclassdatetime Value:(NSString *)svalue ScheduleKey:(NSString *)sschedulekey Image:(NSString *)simage Gender:(NSString *)sgender;


@end

@interface TaskRecord : NSObject{
    NSString *taskkey;
    NSString *createdatetime;
    NSString *assignedby;
    NSString *assignedto;
    NSString *assignedbyusername;
    NSString *assignedtousername;
    NSString *followupdatetime;
    NSString *taskname;
    NSString *remarks;
    NSString *status;
    NSString *action;
    
}

@property (strong,nonatomic) NSString * taskkey;
@property (strong,nonatomic) NSString * createdatetime;
@property (strong,nonatomic) NSString * assignedby;
@property (strong,nonatomic) NSString * assignedto;
@property (strong,nonatomic) NSString * assignedbyusername;
@property (strong,nonatomic) NSString * assignedtousername;
@property (strong,nonatomic) NSString * followupdatetime;
@property (strong,nonatomic) NSString * taskname;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) NSString * action;

-(id)initTaskRecordwithTaskkey:(NSString *)staskkey Createdatetime:(NSString *)screatedatetime Assignedby:(NSString *)sassignedby Assignedto:(NSString *)sassignedto AssignedbyUsername:(NSString *)sassignedbyusername AssignedtoUsername:(NSString *)sassignedtousername Followupdatetime:(NSString *)sfollowupdatetime Taskname:(NSString *)staskname Remarks:(NSString *)sremarks Status:(NSString *)sstatus Action:(NSString *)saction;

@end

@interface UserRecord : NSObject{
    NSString *userkey;
    NSString *firstname;
    NSString *lastname;
    NSString *username;
    
}

@property (strong,nonatomic) NSString * userkey;
@property (strong,nonatomic) NSString * firstname;
@property (strong,nonatomic) NSString * lastname;
@property (strong,nonatomic) NSString * username;


-(id)initUserRecordwithUserkey:(NSString *)suserkey Firstname:(NSString *)sfirstname Lastname:(NSString *)slastname Username:(NSString *)susername;


@end

@interface ClassSummaryRecord : NSObject{
    
    NSString *subject;
    NSString *nextclass;
    NSString *lastscheduledclass;
    NSString *remainingclassscheduled;
    NSString *remainingclassTBDclass;
    NSString *remainingclassTBDmakeup;
    NSString *outstandingpayment;
    NSString *schedulekey;
    NSString *autorenew;
    NSString *outstandingextendtime;
}

@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * nextclass;
@property (strong,nonatomic) NSString * lastscheduledclass;
@property (strong,nonatomic) NSString * remainingclassscheduled;
@property (strong,nonatomic) NSString * remainingclassTBDclass;
@property (strong,nonatomic) NSString * remainingclassTBDmakeup;
@property (strong,nonatomic) NSString * outstandingpayment;
@property (strong,nonatomic) NSString * schedulekey;
@property (strong,nonatomic) NSString * autorenew;
@property (strong,nonatomic) NSString * outstandingextendtime;

#pragma mark -
#pragma mark Class Methods

-(id)initClassSummaryRecordWithSubject:(NSString *)csubject NextClass:(NSString *)cnextclass lastscheduledclass:(NSString *)clastscheduledclass remainingclassscheduled:(NSString *)cremainingclassscheduled remainingclassTBDclass:(NSString *)cremainingclassTBDclass remainingclassTBDmakeup:(NSString *)cremainingclassTBDmakeup outstandingpayment:(NSString *)coutstandingpayment schedulekey:(NSString *)cschedulekey autorenew:(NSString *)cautorenew outstandingextendtime:(NSString *)coutstandingextendtime;
                                                                                  
@end

@interface MessageRecord : NSObject{
    NSString *messagereceipient;
    NSString *messagekey;
    NSString *messagetype;
    NSString *messagechinese;
    NSString *messageenglish;
    NSString *messagecreatetime;
    NSString *messagestarttime;
    NSString *messageendtime;
    NSString *messageexcludelist;
    NSString *automessageflag;
    NSString *studentkey;
    NSString *type;
    NSString *messagechannel;
    NSString *receipienttype;
    NSString *notificationqueuedflag;
}

@property (strong,nonatomic) NSString * messagereceipient;
@property (strong,nonatomic) NSString * messagekey;
@property (strong,nonatomic) NSString * messagetype;
@property (strong,nonatomic) NSString * messageenglish;
@property (strong,nonatomic) NSString * messagechinese;
@property (strong,nonatomic) NSString * messagecreatetime;
@property (strong,nonatomic) NSString * messagestarttime;
@property (strong,nonatomic) NSString * messageendtime;
@property (strong,nonatomic) NSString * messageexcludelist;
@property (strong,nonatomic) NSString * automessageflag;
@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * type;
@property (strong,nonatomic) NSString * messagechannel;
@property (strong,nonatomic) NSString * receiptienttype;
@property (strong,nonatomic) NSString * notificationqueuedflag;

-(id)initMessageRecordwithMessageReceipient:(NSString *)smessagereceipient Messagekey:(NSString *)smessagekey Messagetype:(NSString *)smessagetype MessageEnglish:(NSString *)smessageenglish MessageChinese:(NSString *)smessagechinese MessageCreateTime:(NSString *)smessagecreatetime MessageStartTime:(NSString *)smessagestarttime MessageEndTime:(NSString *)smessageendtime MessageExcludeList:(NSString *)smessageexcludelist AutoMessageFlag:(NSString *)sautomessageflag Studentkey:(NSString *)sstudentkey Type:(NSString *)stype MessageChannel:(NSString *)smessagechannel ReceiptientType:(NSString *)sreceipienttype Notificationqueuedflag:(NSString *)cnotificationqueuedflag;


@end






@interface MessagePhotoRecord : NSObject{
    NSString *messagephotokey;
    NSString *messagephotourl;
    UIImageView *imageview;
    CGFloat width;
    CGFloat height;
    NSURL *internalurl;
    NSString *filetype;
    NSString *filename;
    NSString *thumbnailurl;
    
    
}

@property (strong,nonatomic) NSString * messagephotokey;
@property (strong,nonatomic) NSString * messagephotourl;
@property (strong,nonatomic) UIImageView * imageview;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (strong,nonatomic) NSString * filetype;
@property (strong,nonatomic) NSURL *internalurl;
@property (strong,nonatomic) NSString *filename;
@property (strong,nonatomic) NSString *thumbnailurl;

-(id)initMessagePhotoRecordwithMessagePhotoKey:(NSString *)smessagephotokey MessagePhotoURL:(NSString *)smessagephotourl ImageView:(UIImageView *)simageview Width:(CGFloat)swidth Height:(CGFloat)sheight FileType:(NSString *)sfiletype InternalURL:(NSURL *)sinternalurl FileName:(NSString *)sfilename ThumbnailURL:(NSString *)sthumbnailurl;


@end



@interface InboxMessageRecord : NSObject{
    NSString *inboxmessagekey;
    NSString *outboxmessagekey;
    NSString *messagetype;
    NSString *messagechinese;
    NSString *messageenglish;
    NSString *messagecreatetime;
    NSString *messagestarttime;
    NSString *automessageflag;
    NSString *recipienttype;
    NSString *channel;
    NSString *status;
    NSString *sender;
    NSString *associateid;
    NSString *readtime;
    NSString *recipient;
    //RecipientGroupRecord *recipientgroup;
    NSMutableArray *photoarray;
    NSString * type;
    NSString * readstatus;
    NSMutableArray * readstatusdetailsarray;
    NSString *replytomessagekey;
}

@property (strong,nonatomic) NSString * inboxmessagekey;
@property (strong,nonatomic) NSString * outboxmessagekey;
@property (strong,nonatomic) NSString * messagetype;
@property (strong,nonatomic) NSString * messageenglish;
@property (strong,nonatomic) NSString * messagechinese;
@property (strong,nonatomic) NSString * messagecreatetime;
@property (strong,nonatomic) NSString * messagestarttime;
@property (strong,nonatomic) NSString * automessageflag;
@property (strong,nonatomic) NSString * channel;
@property (strong,nonatomic) NSString * recipienttype;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) NSString * sender;
@property (strong,nonatomic) NSString * associateid;
@property (strong,nonatomic) NSString * readtime;
@property (strong,nonatomic) NSMutableArray *photoarray;
@property (strong,nonatomic) NSString * recipient;
@property (strong,nonatomic) NSString * type;
@property (strong,nonatomic) NSString * readstatus;
@property (strong,nonatomic) NSMutableArray * readstatusdetailsarray;
@property (strong,nonatomic) NSString *replytomessagekey;

-(id)initInboxMessageRecordwithInboxMessagekey:(NSString *)sinboxmessagekey Messagetype:(NSString *)smessagetype MessageEnglish:(NSString *)smessageenglish MessageChinese:(NSString *)smessagechinese MessageCreateTime:(NSString *)smessagecreatetime MessageStartTime:(NSString *)smessagestarttime AutoMessageFlag:(NSString *)sautomessageflag Channel:(NSString *)schannel ReciptientType:(NSString *)srecipienttype Status:(NSString *)sstatus Sender:(NSString *)ssender AssociateID:(NSString *)sassociateid Readtime:(NSString *)sreadtime photoarray:(NSMutableArray *)sphotoarray recipient:(NSString *)srecipient outboxmessagekey:(NSString *)soutboxmessagekey type:(NSString *)stype readstatus:(NSString *)sreadstatus readstatusdetailsarray:(NSMutableArray *)sreadstatusdetailsarray replytomessagekey:(NSString *)sreplytomessagekey;


@end

@interface MessageContactRecord : NSObject{
    
    NSString *centerkey;
    NSString *messagecontact;
    NSString *messagetype;
//    NSString *message;
    NSString *messagestarttime;
    NSString *unreadcount;
    NSString *messagecontactdisplayname;
    NSString *readstatus;
    NSString *type;
    NSString *messagecontacttype;
    NSString *sender;
    NSString *recipient;
    NSString *channel;
    NSArray *attachmenttypes;
    NSString *unreadcountsort;
//    NSString *messagecontactid;
    NSString *messageenglish;
    NSString *messagechinese;
    NSString *outboxmessagekey;
    
}
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * messagecontact;
@property (strong,nonatomic) NSString * messagetype;
@property (strong,nonatomic) NSString * messagestarttime;
@property (strong,nonatomic) NSString * unreadcount;
@property (strong,nonatomic) NSArray * attachmenttypes;
@property (strong,nonatomic) NSString * readstatus;
@property (strong,nonatomic) NSString * type;
@property (strong,nonatomic) NSString * messagecontacttype;
@property (strong,nonatomic) NSString * sender;
@property (strong,nonatomic) NSString * recipient;
@property (strong,nonatomic) NSString * channel;
@property (strong,nonatomic) NSString * unreadcountsort;
@property (strong,nonatomic) NSString * messageenglish;
@property (strong,nonatomic) NSString * messagechinese;
@property (strong,nonatomic) NSString *outboxmessagekey;
@property (strong,nonatomic) NSString *messagecontactdisplayname;

#pragma mark -
#pragma mark Class Methods

-(id)initMessageContactRecordwithcenterkey:(NSString *)ccenterkey messagecontact:(NSString *)cmessagecontact messagetype:(NSString *)cmessagetype messagestarttime:(NSString *)cmessagestarttime unreadcount:(NSString *)cunreadcount attachmenttypes:(NSArray *)cattachmenttypes readstatus:(NSString *)creadstatus type:(NSString *)ctype messagecontacttype:(NSString *)cmessagecontacttype sender:(NSString *)csender recipient:(NSString *)crecipient channel:(NSString *)cchannel unreadcountsort:(NSString *)cunreadcountsort messageenglish:(NSString *)cmessageenglish messagechinese:(NSString *)cmessagechinese outboxmessagekey:(NSString *)coutboxmessagekey messagecontactdisplayname:(NSString *)cmessagecontactdisplayname;

@end


@interface ReadStatusRecord : NSObject{
    NSString *recipientname;
    NSString *recipientid;
    NSString *channel;
    NSString *readtime;
    NSString *image;
    NSString *gender;
    NSString *centerkey;
    NSString *recipientkey;
    NSMutableArray *contactgroup;
    NSString *relationship;
    NSString *iso_code;
    
}

@property (strong,nonatomic) NSString * recipientname;
@property (strong,nonatomic) NSString * recipientid;
@property (strong,nonatomic) NSString * channel;
@property (strong,nonatomic) NSString * readtime;
@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString * gender;
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * recipientkey;
@property (strong,nonatomic) NSMutableArray * contactgroup;
@property (strong,nonatomic) NSString * relationship;
@property (strong,nonatomic) NSString * iso_code;



-(id)initReadStatusRecordwithRecipientName:(NSString *)srecipientname RecipientID:(NSString *)srecipientid Channel:(NSString *)schannel ReadTime:(NSString *)sreadtime Image:(NSString *)simage Gender:(NSString *)sgender Centerkey:(NSString *)scenterkey Recipientkey:(NSString *)srecipientkey Contactgroup:(NSMutableArray *)scontactgroup Relationship:(NSString *)srelationship iso_code:(NSString *)siso_code;


@end


@interface PolicyRecord : NSObject{
    
    NSString *headingenglish;
    NSString *headingchinese;
    NSString *contentenglish;
    NSString *contentchinese;
    
}

@property (strong,nonatomic) NSString * headingenglish;
@property (strong,nonatomic) NSString * headingchinese;
@property (strong,nonatomic) NSString * contentenglish;
@property (strong,nonatomic) NSString * contentchinese;

#pragma mark -
#pragma mark Class Methods

-(id)initPolicyRecordwithHeadingEnglish:(NSString *)cheadingenglish HeadingChinese:(NSString *)cheadingchinese ContentEnglish:(NSString *)ccontentenglish ContentChinese:(NSString *)ccontentchinese;

@end

@interface CenterRecord : NSObject{
    
    NSString *centerkey;
    NSString *entitykey;
    NSString *centername;
    NSString *centershortname_english;
    NSString *centershortname_chinese;
    NSString *classstarttime;
    NSString *classendtime;
    NSString *classtimeinterval;
    NSString *centeraddress;
    NSString *centeraddress_chinese;
    NSString *centercontact;
    NSString *centerfax;
    NSString *centerwhatsapp;
    NSString *centeremail;
    NSString *centerwebsite;
    NSString *centerothers;
    NSString *centerdb;
    NSString *centerhour_line1left;
    NSString *centerhour_line1right;
    NSString *centerhour_line2left;
    NSString *centerhour_line2right;
    NSString *centerhour_line3left;
    NSString *centerhour_line3right;
    NSString *centerhour_line4left;
    NSString *centerhour_line4right;
    NSString *centerhour_line5left;
    NSString *centerhour_line5right;
    NSString *centerhour_line1left_chinese;
    NSString *centerhour_line1right_chinese;
    NSString *centerhour_line2left_chinese;
    NSString *centerhour_line2right_chinese;
    NSString *centerhour_line3left_chinese;
    NSString *centerhour_line3right_chinese;
    NSString *centerhour_line4left_chinese;
    NSString *centerhour_line4right_chinese;
    NSString *centerhour_line5left_chinese;
    NSString *centerhour_line5right_chinese;
    NSString *mapimage;
    NSString *shopfrontimage;
    NSString *launchimage_landscape;
    NSString *launchimage_portrait;
    NSString *printlogoimage;
    NSString *chequepayable;
    NSString *enrollmentfee;
    NSString *latefee_enable;
    NSString *receipttnc;
    NSString *invoicetnc;
    NSString *defaulteditablepaymentamount;
    NSString *defaultattendancestatus;
    NSString *launchmessagemode;
    BOOL enableattendanceextend;
    BOOL renewmonthlyroundup;
    BOOL enableautobatchrenew;
    NSString *autobatchrenewdaystoinclude;
    int monthlymodeweeklyscheduletuitiondenominator;
    NSString *defaultstudentgrade;
    int noofroundoffdigit;
    BOOL enablestaffsalaryrate;
    BOOL enablescantotakeattendance;
    int scantotakeattendancebeforethreshold;
    int scantotakeattendanceafterthreshold;
    NSString *scantype;
    BOOL autofillstudentid;
    BOOL enableistafftakingattendance;
    NSString *latefee;
    NSString *latefeegraceperiod;
    BOOL iparentusercanupdatepersonalinformation;
    BOOL reservedcalendardate;
    BOOL autofillleadid;
    BOOL parentappdefault;
    BOOL studentpromotiondefault;
    BOOL leadpromotiondefault;
    BOOL studentassessmentform;
    BOOL enrollmentvalidity;
    BOOL enrollmultiplesubjectsatsametimeslot;
    BOOL enablemakeup;
    NSString *autorenewal_date_for_monthlycourse;
    BOOL editmonthlycourseclassdate;
    BOOL iparentclassalert;
    BOOL enablemakeupquota;
    NSInteger mindaytoapplyleave;
    NSInteger maxdayformakeup;
    NSString *noofdayafteroriginalclassformakeup;
    NSInteger noofpastdayincludediniparentclassschedule;
    BOOL smsdefault;
    BOOL iparentshowclassroom;
    NSString *standaloneparentappid;
    NSString *standalonestaffappid;
    BOOL autosendereceipt;
    BOOL autosendeinvoice;
    BOOL enableaccountreceivablecodes;
    BOOL iparentshowclassschedule;
    BOOL iparentshowmessages;
    BOOL iparentshowphotocorner;
    BOOL iparentshowenrollmentrecords;
    BOOL iparentshowsalesrecords;
    NSString *duepayment;
    BOOL showdiscountdetailsinreceipt;
    BOOL showdiscountdetailsininvoice;
    NSString *leaveapprovalmode;
    BOOL enableparentsendmessage;
    NSInteger firstreminderbeforeexpiry;
    BOOL expiringclassreminder;
    NSInteger expiringclassreminderrecursiveday;
    
    NSMutableArray *studentnamedisplayorder;
    BOOL showcontactindailyscheduleprintout;
    BOOL showduepaymentindailyscheduleprintout;
    NSString *defaultstudentmessagechannel;
    NSString *defaultleadmessagechannel;
    NSMutableArray *leadnamedisplayorder;
    NSString *scannerpoweroffcode;
    BOOL defaultreceiptremarksasinvoiceremarksforcourseenrollment;
    BOOL defaultreceiptremarksasinvoiceremarksforproductsales;
    NSInteger invoicefontsize;
    NSInteger tncfontsize_invoice;
    BOOL showlevelininvoice;
    NSInteger receiptfontsize;
    NSInteger tncfontsize_receipt;
    BOOL showlevelinreceipt;
    BOOL showstaffnameinreceipt;
    BOOL showvalidityininvoicereceipt;
    BOOL enablevideomessage;
    BOOL enableparentsendvideomessage;
    BOOL enablevoicemessage;
    BOOL enableparentsendvoicemessage;
    BOOL sendparentappinvitesms;
    BOOL ddaenabled;
    BOOL studentsendmessagedefault;
    NSString * printclassdatemode;
    BOOL enablelessonnumber;
    NSString *schoolregnumber;
    NSInteger showclassdatesinreceipt;
    NSInteger showclassdatesininvoice;
    BOOL showlastpaymentonlyinreceipt;
    BOOL secondaryinstructor;
    BOOL iparentshowonlynondroppedenrollment;
    BOOL studentextrafield1;
    BOOL fullday;
    NSInteger lessonnumbermode;
    BOOL markexpiredclassabsent;
    NSArray *paymentmethods;
    BOOL updateclassafterschedulechange;
    BOOL renewevenifthereistbdclass;
    BOOL ecoupon;
    BOOL consolidatestockcountformultipleaccountcodes;
    BOOL enablechatbot;
    BOOL enablemembershippoint;
    BOOL addpointwithactiveparentapp;
    NSString *spendingtopointratio;
    NSString *spendingtopointratio_sales;
    NSString *defaultpointexpirydays;
    NSInteger maxdayrangefortrialclass;
    BOOL autoenrollmentfeeforfirstenrollment;
    NSInteger couponexpiryfirstreminder;
    NSInteger couponexpiryrecursivereminder;
    NSInteger pointexpiryfirstreminder;
    NSInteger pointexpiryrecursivereminder;
    BOOL addpointforonlinepaymentonly;
    BOOL addpointforontimepaymentonly;
    NSMutableArray *timetablefielddisplayorder;
    BOOL printclassdateendtime;
    BOOL skipmakeupforrenewal_prepare;
    BOOL transferpointforinternaltransferpayment;
    BOOL cloneenrollmentcopydiscountdefault;
    NSString *invoiceprefix;
    NSString *receiptprefix;
    BOOL iparentshowuserdefinedschedulename;
    NSString *pointearn_qrcodecheckin;
    NSString *pointearn_selfmakeup;
    BOOL icenterversioncheck;
    BOOL jumptonextlevelduringrenewal;
    BOOL iparentreturnrenewalremindernotifications;
    NSInteger makeupdelayhour;
    NSInteger trialdelayhour;
    NSInteger parentappcolorschemekey;
    BOOL iparentshowclassendtime;
    BOOL showcenteraveragescore;
    NSString *sidprefix;
    NSString *staffcompetencyvalues;
    BOOL enablestaffcompetency;
    NSInteger waiveenrollmentfeeminmonth;
    BOOL defaultcsshowintimetableifnoenrollment;
    BOOL defaultcsmakeupschedule;
    NSString *lockclassperiod;
    BOOL usereserveddayduringrenewal;
    BOOL usereserveddayduringenrollment;
    NSString *maplat;
    NSString *maplong;
    NSInteger minstudentcontact;
    BOOL removecouponifnotpaidbeforeexpiry;
    BOOL markrenewalreserveddaytomakeup;
    BOOL markenrollmentreserveddaytomakeup;
    BOOL removeunpaidandexpiredpromotion;
    NSString *fcgroup;
    BOOL enablemembershiptier;
    NSInteger tierspendinginterval;
    NSInteger maxuploadfilesize;
    NSString *studentextrafield2;
    NSInteger timetabletbdinstructorcolorcode;
    NSInteger timetabletbdclassroomcolorcode;
    NSInteger noofpastdayincludedinistaffmystudentclass;
    NSString *staffpasswordexpirationday;
    BOOL caneditmonthlycoursestartdate;
    NSString *attendance_qrcode_refresh_minute;
    NSString *center_qrcode_refresh_minute;
    NSString *autodropenrollmentday;
    NSString *licensetype;
    NSString *mark_noattendancetaking_to;
    NSString *eenrollmentformdest;
}

@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * entitykey;
@property (strong,nonatomic) NSString * centername;
@property (strong,nonatomic) NSString * centershortname_english;
@property (strong,nonatomic) NSString * centershortname_chinese;
@property (strong,nonatomic) NSString * classstarttime;
@property (strong,nonatomic) NSString * classendtime;
@property (strong,nonatomic) NSString * classtimeinterval;
@property (strong,nonatomic) NSString * centeraddress;
@property (strong,nonatomic) NSString * centeraddress_chinese;
@property (strong,nonatomic) NSString * centercontact;
@property (strong,nonatomic) NSString * centerfax;
@property (strong,nonatomic) NSString * centerwhatsapp;
@property (strong,nonatomic) NSString * centeremail;
@property (strong,nonatomic) NSString * centerwebsite;
@property (strong,nonatomic) NSString * centerothers;
@property (strong,nonatomic) NSString * centerdb;
@property (strong,nonatomic) NSString *centerhour_line1left;
@property (strong,nonatomic) NSString *centerhour_line1right;
@property (strong,nonatomic) NSString *centerhour_line2left;
@property (strong,nonatomic) NSString *centerhour_line2right;
@property (strong,nonatomic) NSString *centerhour_line3left;
@property (strong,nonatomic) NSString *centerhour_line3right;
@property (strong,nonatomic) NSString *centerhour_line4left;
@property (strong,nonatomic) NSString *centerhour_line4right;
@property (strong,nonatomic) NSString *centerhour_line5left;
@property (strong,nonatomic) NSString *centerhour_line5right;
@property (strong,nonatomic) NSString *centerhour_line1left_chinese;
@property (strong,nonatomic) NSString *centerhour_line1right_chinese;
@property (strong,nonatomic) NSString *centerhour_line2left_chinese;
@property (strong,nonatomic) NSString *centerhour_line2right_chinese;
@property (strong,nonatomic) NSString *centerhour_line3left_chinese;
@property (strong,nonatomic) NSString *centerhour_line3right_chinese;
@property (strong,nonatomic) NSString *centerhour_line4left_chinese;
@property (strong,nonatomic) NSString *centerhour_line4right_chinese;
@property (strong,nonatomic) NSString *centerhour_line5left_chinese;
@property (strong,nonatomic) NSString *centerhour_line5right_chinese;
@property (strong,nonatomic) NSString *mapimage;
@property (strong,nonatomic) NSString *shopfrontimage;
@property (strong,nonatomic) NSString *launchimage_landscape;
@property (strong,nonatomic) NSString *launchimage_portrait;
@property (strong,nonatomic) NSString *printlogoimage;
@property (strong,nonatomic) NSString *chequepayable;
@property (strong,nonatomic) NSString *enrollmentfee;
@property (strong,nonatomic) NSString *latefee_enable;
@property (strong,nonatomic) NSString *receipttnc;
@property (strong,nonatomic) NSString *invoicetnc;
@property (strong,nonatomic) NSString *defaulteditablepaymentamount;
@property (strong,nonatomic) NSString *defaultattendancestatus;
@property (strong,nonatomic) NSString *launchmessagemode;
@property (nonatomic) BOOL enableattendanceextend;
@property (nonatomic) BOOL renewmonthlyroundup;
@property (nonatomic) BOOL enableautobatchrenew;
@property (nonatomic,strong) NSString *autobatchrenewdaystoinclude;
@property (nonatomic) int monthlymodeweeklyscheduletuitiondenominator;
@property (nonatomic,strong) NSString *defaultstudentgrade;
@property (nonatomic) int noofroundoffdigit;
@property (nonatomic) BOOL enablestaffsalaryrate;
@property (nonatomic) BOOL enablescantotakeattendance;
@property (nonatomic) int scantotakeattendancebeforethreshold;
@property (nonatomic) int scantotakeattendanceafterthreshold;
@property (nonatomic,strong) NSString *scantype;
@property (nonatomic) BOOL autofillstudentid;
@property (nonatomic) BOOL enableistafftakingattendance;
@property (nonatomic,strong) NSString *latefee;
@property (nonatomic,strong) NSString *latefeegraceperiod;
@property (nonatomic) BOOL iparentusercanupdatepersonalinformation;
@property (nonatomic) BOOL reservedcalendardate;
@property (nonatomic) BOOL autofillleadid;
@property (nonatomic) BOOL parentappdefault;
@property (nonatomic) BOOL studentpromotiondefault;
@property (nonatomic) BOOL leadpromotiondefault;
@property (nonatomic) BOOL studentassessmentform;
@property (nonatomic) BOOL enrollmentvalidity;
@property (nonatomic) BOOL iparentshowenrollmenttuitionfee;
@property (nonatomic) BOOL enrollmultiplesubjectsatsametimeslot;
@property (nonatomic) BOOL enablemakeup;
@property (nonatomic,strong) NSString *autorenewal_date_for_monthlycourse;
@property (nonatomic) BOOL editmonthlycourseclassdate;
@property (nonatomic) BOOL iparentclassalert;
@property (nonatomic,strong) NSString *iparentleavemode;
@property (nonatomic) BOOL enablemakeupquota;
@property (nonatomic) NSInteger mindaytoapplyleave;
@property (nonatomic) NSInteger maxdayformakeup;
@property (nonatomic,strong) NSString *noofdayafteroriginalclassformakeup;
@property (nonatomic) NSInteger noofpastdayincludediniparentclassschedule;
@property (nonatomic) BOOL smsdefault;
@property (nonatomic) BOOL iparentshowclassroom;
@property (strong,nonatomic) NSString *standaloneparentappid;
@property (strong,nonatomic) NSString *standalonestaffappid;
@property (nonatomic) BOOL autosendereceipt;
@property (nonatomic) BOOL autosendeinvoice;
@property (nonatomic) BOOL enableaccountreceivablecodes;
@property (nonatomic) BOOL iparentshowclassschedule;
@property (nonatomic) BOOL iparentshowmessages;
@property (nonatomic) BOOL iparentshowphotocorner;
@property (nonatomic) BOOL iparentshowenrollmentrecords;
@property (nonatomic) BOOL iparentshowsalesrecords;
@property (nonatomic,strong) NSString *duepayment;
@property (nonatomic) BOOL showdiscountdetailsinreceipt;
@property (nonatomic) BOOL showdiscountdetailsininvoice;
@property (nonatomic,strong) NSString *leaveapprovalmode;
@property (nonatomic) BOOL enableparentsendmessage;
@property (nonatomic) NSInteger firstreminderbeforeexpiry;
@property (nonatomic) BOOL expiringclassreminder;
@property (nonatomic) NSInteger expiringclassreminderrecursiveday;
@property (nonatomic,strong) NSMutableArray *studentnamedisplayorder;
@property (nonatomic) BOOL showcontactindailyscheduleprintout;
@property (nonatomic) BOOL showduepaymentindailyscheduleprintout;
@property (nonatomic,strong) NSString *defaultstudentmessagechannel;
@property (nonatomic,strong) NSString *defaultleadmessagechannel;
@property (nonatomic,strong) NSMutableArray *leadnamedisplayorder;
@property (nonatomic,strong) NSString *scannerpoweroffcode;
@property (nonatomic) BOOL defaultreceiptremarksasinvoiceremarksforcourseenrollment;
@property (nonatomic) BOOL defaultreceiptremarksasinvoiceremarksforproductsales;
@property (nonatomic) NSInteger invoicefontsize;
@property (nonatomic) NSInteger tncfontsize_invoice;
@property (nonatomic) BOOL showlevelininvoice;
@property (nonatomic) NSInteger receiptfontsize;
@property (nonatomic) NSInteger tncfontsize_receipt;
@property (nonatomic) BOOL showlevelinreceipt;
@property (nonatomic) BOOL showstaffnameinreceipt;
@property (nonatomic) BOOL showvalidityininvoicereceipt;
@property (nonatomic) BOOL enablevideomessage;
@property (nonatomic) BOOL enableparentsendvideomessage;
@property (nonatomic) BOOL enablevoicemessage;
@property (nonatomic) BOOL enableparentsendvoicemessage;
@property (nonatomic) BOOL sendparentappinvitesms;
@property (nonatomic) BOOL ddaenabled;
@property (nonatomic) BOOL studentsendmessagedefault;
@property (nonatomic) NSString * printclassdatemode;
@property (nonatomic) BOOL enablelessonnumber;
@property (nonatomic,strong) NSString *schoolregnumber;
@property (nonatomic) NSInteger showclassdatesinreceipt;
@property (nonatomic) NSInteger showclassdatesininvoice;
@property (nonatomic) BOOL showlastpaymentonlyinreceipt;
@property (nonatomic) BOOL secondaryinstructor;
@property (nonatomic) BOOL iparentshowonlynondroppedenrollment;
@property (nonatomic) BOOL studentextrafield1;
@property (nonatomic) BOOL fullday;
@property (nonatomic) NSInteger lessonnumbermode;
@property (nonatomic) BOOL markexpiredclassabsent;
@property (nonatomic,strong) NSArray *paymentmethods;
@property (nonatomic) BOOL updateclassafterschedulechange;
@property (nonatomic) BOOL renewevenifthereistbdclass;
@property (nonatomic) BOOL ecoupon;
@property (nonatomic) BOOL consolidatestockcountformultipleaccountcodes;
@property (nonatomic) BOOL enablechatbot;
@property (nonatomic) BOOL enablemembershippoint;
@property (nonatomic) BOOL addpointwithactiveparentapp;
@property (nonatomic,strong) NSString *spendingtopointratio;
@property (nonatomic,strong) NSString *spendingtopointratio_sales;
@property (nonatomic,strong) NSString *defaultpointexpirydays;
@property (nonatomic) NSInteger maxdayrangefortrialclass;
@property (nonatomic) BOOL autoenrollmentfeeforfirstenrollment;
@property (nonatomic) NSInteger couponexpiryfirstreminder;
@property (nonatomic) NSInteger couponexpiryrecursivereminder;
@property (nonatomic) NSInteger pointexpiryfirstreminder;
@property (nonatomic) NSInteger pointexpiryrecursivereminder;
@property (nonatomic) BOOL addpointforonlinepaymentonly;
@property (nonatomic) BOOL addpointforontimepaymentonly;
@property (nonatomic,strong) NSMutableArray *timetablefielddisplayorder;
@property (nonatomic) BOOL printclassdateendtime;
@property (nonatomic) BOOL skipmakeupforrenewal_prepare;
@property (nonatomic) BOOL transferpointforinternaltransferpayment;
@property (nonatomic) BOOL cloneenrollmentcopydiscountdefault;
@property (nonatomic,strong) NSString *invoiceprefix;
@property (nonatomic,strong) NSString *receiptprefix;
@property (nonatomic) BOOL iparentshowuserdefinedschedulename;
@property (nonatomic,strong) NSString *pointearn_qrcodecheckin;
@property (nonatomic,strong) NSString *pointearn_selfmakeup;
@property (nonatomic) BOOL icenterversioncheck;
@property (nonatomic) BOOL jumptonextlevelduringrenewal;
@property (nonatomic) BOOL iparentreturnrenewalremindernotifications;
@property (nonatomic) NSInteger makeupdelayhour;
@property (nonatomic) NSInteger trialdelayhour;
@property (nonatomic) NSInteger parentappcolorschemekey;
@property (nonatomic) BOOL iparentshowclassendtime;
@property (nonatomic) BOOL showcenteraveragescore;
@property (nonatomic,strong) NSString *sidprefix;
@property (nonatomic,strong) NSString *staffcompetencyvalues;
@property (nonatomic) BOOL enablestaffcompetency;
@property (nonatomic) NSInteger waiveenrollmentfeeminmonth;
@property (nonatomic) BOOL defaultcsshowintimetableifnoenrollment;
@property (nonatomic) BOOL defaultcsmakeupschedule;
@property (nonatomic,strong) NSString *lockclassperiod;
@property (nonatomic) BOOL usereserveddayduringrenewal;
@property (nonatomic) BOOL usereserveddayduringenrollment;
@property (nonatomic,strong) NSString *maplat;
@property (nonatomic,strong) NSString *maplong;
@property (nonatomic) NSInteger minstudentcontact;
@property (nonatomic) BOOL removecouponifnotpaidbeforeexpiry;
@property (nonatomic) BOOL markrenewalreserveddaytomakeup;
@property (nonatomic) BOOL markenrollmentreserveddaytomakeup;
@property (nonatomic) BOOL removeunpaidandexpiredpromotion;
@property (nonatomic,strong) NSString *fcgroup;
@property (nonatomic) BOOL enablemembershiptier;
@property (nonatomic) NSInteger tierspendinginterval;
@property (nonatomic) NSInteger maxuploadfilesize;
@property (nonatomic,strong) NSString *studentextrafield2;
@property (nonatomic) NSInteger timetabletbdinstructorcolorcode;
@property (nonatomic) NSInteger timetabletbdclassroomcolorcode;
@property (nonatomic) NSInteger noofpastdayincludedinistaffmystudentclass;
@property (nonatomic) NSString *staffpasswordexpirationday;
@property (nonatomic) BOOL caneditmonthlycoursestartdate;
@property (nonatomic,strong) NSString *attendance_qrcode_refresh_minute;
@property (nonatomic,strong) NSString *center_qrcode_refresh_minute;
@property (nonatomic,strong) NSString *autodropenrollmentday;
@property (nonatomic,strong) NSString *licensetype;
@property (nonatomic,strong) NSString *mark_noattendancetaking_to;
@property (nonatomic,strong) NSString *eenrollmentformdest;

#pragma mark -
#pragma mark Class Methods

-(id)initCenterRecordwithCenterKey:(NSString *)ccenterkey EntityKey:(NSString *)centitykey CenterName:(NSString *)ccentername CenterShortNameEnglish:(NSString *)ccentershortname_english CenterShortNameChinese:(NSString *)ccentershortname_chinese ClassStartTime:(NSString *)cclassstarttime ClassEndTime:(NSString *)cclassendtime ClassTimeInterval:(NSString *)cclasstimeinterval CenterAddress:(NSString *)ccenteraddress CenterAddress_chinese:(NSString *)ccenteraddress_chinese CenterContact:(NSString *)ccentercontact CenterFax:(NSString *)ccenterfax CenterWhatsapp:(NSString *)ccenterwhatsapp CenterEmail:(NSString *)ccenteremail CenterWebsite:(NSString *)ccenterwebsite CenterOthers:(NSString *)ccenterothers CenterDB:(NSString *)ccenterdb Centerhour_line1left:(NSString *)ccenterhour_line1left Centerhour_line1right:(NSString *)ccenterhour_line1right Centerhour_line2left:(NSString *)ccenterhour_line2left Centerhour_line2right:(NSString *)ccenterhour_line2right Centerhour_line3left:(NSString *)ccenterhour_line3left Centerhour_line3right:(NSString *)ccenterhour_line3right Centerhour_line1left_chinese:(NSString *)ccenterhour_line1left_chinese Centerhour_line1right_chinese:(NSString *)ccenterhour_line1right_chinese Centerhour_line2left_chinese:(NSString *)ccenterhour_line2left_chinese Centerhour_line2right_chinese:(NSString *)ccenterhour_line2right_chinese Centerhour_line3left_chinese:(NSString *)ccenterhour_line3left_chinese Centerhour_line3right_chinese:(NSString *)ccenterhour_line3right_chinese launchimage_landscape:(NSString *)claunchimage_landscape launchimage_portrait:(NSString *)claunchimage_portrait shopfrontimage:(NSString *)cshopfrontimage mapimage:(NSString *)cmapimage printlogoimage:(NSString *)cprintlogoimage chequepayable:(NSString *)cchequepayable Enrollmentfee:(NSString *)cenrollmentfee LateFee_Enable:(NSString *)clatefee_enable receipttnc:(NSString *)creceipttnc invoicetnc:(NSString *)cinvoicetnc defaulteditablepaymentamount:(NSString *)cdefaulteditablepaymentamount defaultattendancestatus:(NSString *)cdefaultattendancestatus launchmessagemode:(NSString *)claunchmessagemode enableattendanceextend:(BOOL)cenableattendanceextend renewmonthlyroundup:(BOOL)crenewmonthlyroundup enableautobatchrenew:(BOOL)cenableautobatchrenew autobatchrenewdaystoinclude:(NSString *)cautobatchrenewdaystoinclude monthlymodeweeklyscheduletuitiondenominator:(int)cmonthlymodeweeklyscheduletuitiondenominator defaultstudentgrade:(NSString *)cdefaultstudentgrade noofroundoffdigit:(int)cnoofroundoffdigit enablestaffsalaryrate:(BOOL)cenablestaffsalaryrate enablescantotakeattendance:(BOOL)cenablescantotakeattendance scantottakeattendancebeforethreshold:(int)cscantottakeattendancebeforethreshold scantottakeattendanceafterthreshold:(int)cscantottakeattendanceafterthreshold scantype:(NSString *)cscantype autofillstudentid:(BOOL)cautofillstudentid enableistafftakingattendance:(BOOL)cenableistafftakingattendance latefee:(NSString *)clatefee latefeegraceperiod:(NSString *)clatefeegraceperiod iparentusercanupdatepersonalinformation:(BOOL)ciparentusercanupdatepersonalinformation reservedcalendardate:(BOOL)creservedcalendardate autofillleadid:(BOOL)cautofillleadid parentappdefault:(BOOL)cparentappdefault studentpromotiondefault:(BOOL)cstudentpromotiondefault leadpromotiondefault:(BOOL)cleadpromotiondefault studentassessmentform:(BOOL)cstudentassessmentform enrollmentvalidity:(BOOL)cenrollmentvalidity iparentshowenrollmenttuitionfee:(BOOL)ciparentshowenrollmenttuitionfee enrollmultiplesubjectsatsametimeslot:(BOOL)cenrollmultiplesubjectsatsametimeslot enablemakeup:(BOOL)cenablemakeup autorenewal_date_for_monthlycourse:(NSString *)cautorenewal_date_for_monthlycourse editmonthlycourseclassdate:(BOOL)ceditmonthlycourseclassdate iparentclassalert:(BOOL)ciparentclassalert iparentleavemode:(NSString *)ciparentleavemode enablemakeupquota:(BOOL)cenablemakeupquota mindaytoapplyleave:(NSInteger)cmindaytoapplyleave maxdayformakeup:(NSInteger)cmaxdayformakeup noofdayafteroriginalclassformakeup:(NSString *)cnoofdayafteroriginalclassformakeup noofpastdayincludediniparentclassschedule:(NSInteger)cnoofpastdayincludediniparentclassschedule smsdefault:(BOOL)csmsdefault iparentshowclassroom:(BOOL)ciparentshowclassroom standaloneparentappid:(NSString *)cstandaloneparentappid autosendereceipt:(BOOL)cautosendereceipt enableaccountreceivablecodes:(BOOL)cenableaccountreceivablecodes iparentshowclassschedule:(BOOL)ciparentshowclassschedule iparentshowmessages:(BOOL)ciparentshowmessages iparentshowphotocorner:(BOOL)ciparentshowphotocorner iparentshowenrollmentrecords:(BOOL)ciparentshowenrollmentrecords iparentshowsalesrecords:(BOOL)ciparentshowsalesrecords duepayment:(NSString *)cduepayment showdiscountdetailsinreceipt:(BOOL)cshowdiscountdetailsinreceipt showdiscountdetailsininvoice:(BOOL)cshowdiscountdetailsininvoice leaveapprovalmode:(NSString *)cleaveapprovalmode enableparentsendmessage:(BOOL)cenableparentsendmessage expiringclassreminder:(BOOL)cexpiringclassreminder firstreminderbeforeexpiry:(NSInteger)cfirstreminderbeforeexpiry expiringclassreminderrecursiveday:(NSInteger)cexpiringclassreminderrecursiveday studentnamedisplayorder:(NSMutableArray *)cstudentnamedisplayorder showcontactindailyscheduleprintout:(BOOL)cshowcontactindailyscheduleprintout showduepaymentindailyscheduleprintout:(BOOL)cshowduepaymentindailyscheduleprintout defaultstudentmessagechannel:(NSString *)cdefaultstudentmessagechannel defaultleadmessagechannel:(NSString *)cdefaultleadmessagechannel leadnamedisplayorder:(NSMutableArray *)cleadnamedisplayorder scannerpoweroffcode:(NSString *)cscannerpoweroffcode defaultreceiptremarksasinvoiceremarksforcourseenrollment:(BOOL)cdefaultreceiptremarksasinvoiceremarksforcourseenrollment defaultreceiptremarksasinvoiceremarksforproductsales:(BOOL)cdefaultreceiptremarksasinvoiceremarksforproductsales invoicefontsize:(NSInteger)cinvoicefontsize tncfontsize_invoice:(NSInteger)ctncfontsize_invoice showlevelininvoice:(BOOL)cshowlevelininvoice receiptfontsize:(NSInteger)creceiptfontsize tncfontsize_receipt:(NSInteger)ctncfontsize_receipt showlevelinreceipt:(BOOL)cshowlevelinreceipt showstaffnameinreceipt:(BOOL)cshowstaffnameinreceipt showvalidityininvoicereceipt:(BOOL)cshowvalidityininvoicereceipt enablevideomessage:(BOOL)cenablevideomessage enableparentsendvideomessage:(BOOL)cenableparentsendvideomessage enablevoicemessage:(BOOL)cenablevoicemessage enableparentsendvoicemessage:(BOOL)cenableparentsendvoicemessage sendparentappinvitesms:(BOOL)csendparentappinvitesms ddaenabled:(BOOL)cddaenabled studentsendmessagedefault:(BOOL)cstudentsendmessagedefault printclassdatemode:(NSString *)cprintclassdatemode enablelessonnumber:(BOOL)cenablelessonnumber schoolregnumber:(NSString *)cschoolregnumber autosendeinvoice:(BOOL)cautosendeinvoice showclassdatesinreceipt:(NSInteger)cshowclassdatesinreceipt showclassdatesininvoice:(NSInteger)cshowclassdatesininvoice showlastpaymentonlyinreceipt:(BOOL)cshowlastpaymentonlyinreceipt secondaryinstructor:(BOOL)csecondaryinstructor iparentshowonlynondroppedenrollment:(BOOL)ciparentshowonlynondroppedenrollment studentextrafield1:(BOOL)cstudentextrafield1 fullday:(BOOL)cfullday lessonnumbermode:(NSInteger)clessonnumbermode markexpiredclassabsent:(BOOL)cmarkexpiredclassabsent paymentmethods:(NSArray *)cpaymentmethods updateclassafterschedulechange:(BOOL)cupdateclassafterschedulechange standalonestaffappid:(NSString *)cstandalonestaffappid renewevenifthereistbdclass:(BOOL)crenewevenifthereistbdclass ecoupon:(BOOL)cecoupon consolidatestockcountformultipleaccountcodes:(BOOL)cconsolidatestockcountformultipleaccountcodes enablechatbot:(BOOL)cenablechatbot enablemembershippoint:(BOOL)cenablemembershippoint addpointwithactiveparentapp:(BOOL)caddpointwithactiveparentapp spendingtopointratio:(NSString *)cspendingtopointratio spendingtopointratio_sales:(NSString *)cspendingtopointratio_sales defaultpointexpirydays:(NSString *)cdefaultpointexpirydays maxdayrangefortrialclass:(NSInteger)cmaxdayrangefortrialclass autoenrollmentfeeforfirstenrollment:(BOOL)cautoenrollmentfeeforfirstenrollment couponexpiryfirstreminder:(NSInteger)ccouponexpiryfirstreminder couponexpiryrecursivereminder:(NSInteger)ccouponexpiryrecursivereminder pointexpiryfirstreminder:(NSInteger)cpointexpiryfirstreminder pointexpiryrecursivereminder:(NSInteger)cpointexpiryrecursivereminder addpointforonlinepaymentonly:(BOOL)caddpointforonlinepaymentonly addpointforontimepaymentonly:(BOOL)caddpointforontimepaymentonly timetablefielddisplayorder:(NSMutableArray *)ctimetablefielddisplayorder printclassdateendtime:(BOOL)cprintclassdateendtime skipmakeupforrenewal_prepare:(BOOL)cskipmakeupforrenewal_prepare transferpointforinternaltransferpayment:(BOOL)ctransferpointforinternaltransferpayment cloneenrollmentcopydiscountdefault:(BOOL)ccloneenrollmentcopydiscountdefault invoiceprefix:(NSString *)cinvoiceprefix receiptprefix:(NSString *)creceiptprefix iparentshowuserdefinedschedulename:(BOOL)ciparentshowuserdefinedschedulename pointearn_qrcodecheckin:(NSString *)cpointearn_qrcodecheckin icenterversioncheck:(BOOL)cicenterversioncheck jumptonextlevelduringrenewal:(BOOL)cjumptonextlevelduringrenewal iparentreturnrenewalremindernotifications:(BOOL)ciparentreturnrenewalremindernotifications makeupdelayhour:(NSInteger)cmakeupdelayhour parentappcolorschemekey:(NSInteger)cparentappcolorschemekey iparentshowclassendtime:(BOOL)ciparentshowclassendtime showcenteraveragescore:(BOOL)cshowcenteraveragescore sidprefix:(NSString *)csidprefix staffcompetencyvalues:(NSString *)cstaffcompetencyvalues enablestaffcompetency:(BOOL)cenablestaffcompetency waiveenrollmentfeeminmonth:(NSInteger)cwaiveenrollmentfeeminmonth defaultcsshowintimetableifnoenrollment:(BOOL)cdefaultcsshowintimetableifnoenrollment defaultcsmakeupschedule:(BOOL)cdefaultcsmakeupschedule lockclassperiod:(NSString *)clockclassperiod usereserveddayduringrenewal:(BOOL)cusereserveddayduringrenewal usereserveddayduringenrollment:(BOOL)cusereserveddayduringenrollment maplat:(NSString *)cmaplat maplong:(NSString *)cmaplong minstudentcontact:(NSInteger)cminstudentcontact removecouponifnotpaidbeforeexpiry:(BOOL)cremovecouponifnotpaidbeforeexpiry markrenewalreserveddaytomakeup:(BOOL)cmarkrenewalreserveddaytomakeup Centerhour_line4left:(NSString *)ccenterhour_line4left Centerhour_line4right:(NSString *)ccenterhour_line4right Centerhour_line5left:(NSString *)ccenterhour_line5left Centerhour_line5right:(NSString *)ccenterhour_line5right Centerhour_line4left_chinese:(NSString *)ccenterhour_line4left_chinese Centerhour_line4right_chinese:(NSString *)ccenterhour_line4right_chinese Centerhour_line5left_chinese:(NSString *)ccenterhour_line5left_chinese Centerhour_line5right_chinese:(NSString *)ccenterhour_line5right_chinese markenrollmentreserveddaytomakeup:(BOOL)cmarkenrollmentreserveddaytomakeup fcgroup:(NSString *)cfcgroup removeunpaidandexpiredpromotion:(BOOL)cremoveunpaidandexpiredpromotion enablemembershiptier:(BOOL)cenablemembershiptier tierspendinginterval:(NSInteger)ctierspendinginterval maxuploadfilesize:(NSInteger)cmaxuploadfilesize studentextrafield2:(NSString *)cstudentextrafield2 trialdelayhour:(NSInteger)ctrialdelayhour timetabletbdinstructorcolorcode:(NSInteger)ctimetabletbdinstructorcolorcode timetabletbdclassroomcolorcode:(NSInteger)ctimetabletbdclassroomcolorcode noofpastdayincludedinistaffmystudentclass:(NSInteger)cnoofpastdayincludedinistaffmystudentclass staffpasswordexpirationday:(NSString *)cstaffpasswordexpirationday caneditmonthlycoursestartdate:(BOOL)ccaneditmonthlycoursestartdate attendance_qrcode_refresh_minute:(NSString *)cattendance_qrcode_refresh_minute center_qrcode_refresh_minute:(NSString *)ccenter_qrcode_refresh_minute autodropenrollmentday:(NSString *)cautodropenrollmentday licensetype:(NSString *)clicensetype pointearn_selfmakeup:(NSString *)cpointearn_selfmakeup mark_noattendancetaking_to:(NSString *)cmark_noattendancetaking_to eenrollmentformdest:(NSString *)ceenrollmentformdest;

@end

@interface CenterSettings : NSObject{
    
    NSString *centerkey;
    NSString *fcbrand;
    NSString *grade;
    BOOL skipmakeupforrenewal;
    BOOL presentalert;
    BOOL absentalert;
    BOOL makeupalert;
    BOOL photoalert;
    
}

@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * fcbrand;
@property (strong,nonatomic) NSString * grade;
@property (nonatomic) BOOL skipmakeupforrenewal;
@property (nonatomic) BOOL presentalert;
@property (nonatomic) BOOL absentalert;
@property (nonatomic) BOOL makeupalert;
@property (nonatomic) BOOL photoalert;

#pragma mark -
#pragma mark Class Methods

-(id)initCenterSettingswithCenterkey:(NSString *)ccenterkey FCBrand:(NSString *)cfcbrand Grade:(NSString *)cgrade skipmakeupforrenewal:(BOOL)cskipmakeupforrenewal presentalert:(BOOL)cpresentalert absentalert:(BOOL)cabsentalert makeupalert:(BOOL)cmakeupalert photoalert:(BOOL)cphotoalert;

@end

@interface DiscountRecord : NSObject{
    
    NSString *discount;
    NSString *description;
    NSString *description_chinese;
}

@property (strong,nonatomic) NSString *discount;
@property (strong,nonatomic) NSString *description;
@property (strong,nonatomic) NSString *description_chinese;

#pragma mark -
#pragma mark Class Methods

-(id)initDiscountRecordRecordWithDiscount:(NSString *)cdiscount Description:(NSString *)cdescription Description_Chinese:(NSString *)cdescription_chinese;

@end

@interface GlobalSettings : NSObject{
    
    NSString *startupserver;
    NSString *latestappversion;
    NSString *latestappurl;
    NSString *broadcastmessagemode;
    NSString *broadcastmessageenglish;
    NSString *broadcastmessagechinese;
}


@property (strong,nonatomic) NSString * startupserver;
@property (strong,nonatomic) NSString * latestappversion;
@property (strong,nonatomic) NSString * latestappurl;
@property (strong,nonatomic) NSString * broadcastmessagemode;
@property (strong,nonatomic) NSString * broadcastmessageenglish;
@property (strong,nonatomic) NSString * broadcastmessagechinese;

#pragma mark -
#pragma mark Class Methods

-(id)initGlobalSettingswithStartupServer:(NSString *)cstartupserver LatestAppVersion:(NSString *)clatestappversion LatestAppUrl:(NSString *)clatestappurl BroadcastMessageMode:(NSString *)cbroadcastmessagemode BroadcastMessageEnglish:(NSString *)cbroadcastmessageenglish BroadcastMessageChinese:(NSString *)cbroadcastmessagechinese;

@end




@interface TuitionRecord : NSObject{
    
    NSString *subject_shortname;
    NSString *method;
    NSString *scale;
    NSString *tuitionfee;
    NSString *newtuitionfee;
    NSString *effectivedate;

    
}

@property (strong,nonatomic) NSString * subject_shortname;
@property (strong,nonatomic) NSString * method;
@property (strong,nonatomic) NSString * scale;
@property (strong,nonatomic) NSString * tuitionfee;
@property (strong,nonatomic) NSString * newtuitionfee;
@property (strong,nonatomic) NSString * effectivedate;


#pragma mark -
#pragma mark Class Methods

-(id)initTuitionRecordwithSubject_Shortname:(NSString *)csubject_shortname Method:(NSString *)cmethod Scale:(NSString *)cscale TuitionFee:(NSString *)ctuitionfee newtuitionfee:(NSString *)cnewtuitionfee effectivedate:(NSString *)ceffectivedate;

@end

@interface LevelRecord : NSObject{
    
    NSString *level;
    NSString *earlieststartdate;
}
@property (strong,nonatomic) NSString * level;
@property (strong,nonatomic) NSString * earlieststartdate;


#pragma mark -
#pragma mark Class Methods

-(id)initLevelRecordwithLevel:(NSString *)clevel earlieststartdate:(NSString *)cearlieststartdate;

@end

@interface MaxLevelRecord : NSObject{
    
    NSString *subject;
    NSString *levelmain;
    NSString *levelctm;
    
}

@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * levelmain;
@property (strong,nonatomic) NSString * levelctm;


#pragma mark -
#pragma mark Class Methods

-(id)initMaxLevelRecordwithSubject:(NSString *)csubject LevelMain:(NSString *)clevelmain LevelCTM:(NSString *)clevelctm;

@end

@interface LastLevelRecord : NSObject{
    
    NSDate *date;
    NSString *levelmain;
    NSString *levelctm;
    
}

@property (strong,nonatomic) NSDate *date;
@property (strong,nonatomic) NSString * levelmain;
@property (strong,nonatomic) NSString * levelctm;


#pragma mark -
#pragma mark Class Methods

-(id)initLastLevelRecordwithDate:(NSDate *)cdate LevelMain:(NSString *)clevelmain LevelCTM:(NSString *)clevelctm;

@end


@interface AllClassRemarksRecord : NSObject{
    
    NSString *subject;
    NSString *allclassremarks;
    
}

@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * allclassremarks;


#pragma mark -
#pragma mark Class Methods

-(id)initMaxLevelRecordwithSubject:(NSString *)csubject AllClassRemarks:(NSString *)callclassremarks;

@end

@interface CategoryCountRecord : NSObject{
    
    NSString *type;
    NSString *count;
    
}

@property (strong,nonatomic) NSString * type;
@property (strong,nonatomic) NSString * count;


#pragma mark -
#pragma mark Class Methods

-(id)initCategoryCountRecordwithType:(NSString *)ctype Count:(NSString *)ccount;

@end

@interface SubjectRecord : NSObject{
    
    NSString *centerkey;
    NSString *subjectkey;
    NSString *subject_englishname;
    NSString *subject_chinesename;
    NSString *subject_shortname;
    NSString *enrollmentmode;
    NSString *tuition_method;
    NSString *tuition_mode;
    NSString *studentcapacity;
    NSString *standardnoofclassormonth;
    NSString *classduration;
    NSString *classduration_assessment;
    NSString *classduration_trial;
    NSString *status;
    NSMutableArray *levelArray;
    NSMutableArray *tuitionArray;
    NSString *remarks;
    NSMutableArray *scheduleArray;
    NSString *subject_category;
    BOOL weeklyautorenewdefault;
    NSString *validity;
    NSString * makeup_quota_value;
    NSString *makeup_quota_unit;
    BOOL leaveday_by_makeupschedule;
    BOOL leaveday_by_classdate;
    BOOL leaveday_follow_teacher;
    BOOL leaveday_by_enrolledschedule;
    BOOL leaveday_by_staffschedule;
    BOOL leaveday_follow_level;
    BOOL leaveday_follow_lesson;
    NSInteger colorcode;
    NSString * fcsubject;
    NSMutableDictionary *lessonnumberDict;
    BOOL leaveday_follow_category;
    BOOL allowsameschedule;
    NSString *subject_fulldescription;
    NSString *subject_image;
    BOOL publishinchatbot;
    NSString *chatbot_category;
    NSString *chatbot_tag1;
    BOOL trial_by_existinglesson;
    BOOL trial_by_definedschedule;
    NSString *trialcapacity;
    BOOL chatbot_enabletrial;
    BOOL showmakeupbuttonifnotimeslot;
    NSString *btspromotioncode831;
    NSString *btspromotioncode1031;
    BOOL showabsentbuttononarrangeleave;
    NSInteger pregenperiodcount;
    NSString *autolevelupgrade;
}
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * subjectkey;
@property (strong,nonatomic) NSString * subject_englishname;
@property (strong,nonatomic) NSString * subject_chinesename;
@property (strong,nonatomic) NSString * subject_shortname;
@property (strong,nonatomic) NSString * enrollmentmode;
@property (strong,nonatomic) NSString * tuition_method;
@property (strong,nonatomic) NSString * tuition_mode;
@property (strong,nonatomic) NSString * studentcapacity;
@property (strong,nonatomic) NSString * standardnoofclassormonth;
@property (strong,nonatomic) NSString * classduration;
@property (strong,nonatomic) NSString * classduration_assessment;
@property (strong,nonatomic) NSString * classduration_trial;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) NSMutableArray * levelArray;
@property (strong,nonatomic) NSMutableArray * tuitionArray;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSMutableArray * scheduleArray;
@property (strong,nonatomic) NSString * subject_category;
@property (nonatomic) BOOL weeklyautorenewdefault;
@property (strong,nonatomic) NSString * validity;
@property (nonatomic) NSString * makeup_quota_value;
@property (strong,nonatomic) NSString * makeup_quota_unit;
@property (nonatomic) BOOL leaveday_by_makeupschedule;
@property (nonatomic) BOOL leaveday_by_classdate;
@property (nonatomic) BOOL leaveday_follow_teacher;
@property (nonatomic) BOOL leaveday_by_enrolledschedule;
@property (nonatomic) BOOL leaveday_by_staffschedule;
@property (nonatomic) BOOL leaveday_follow_level;
@property (nonatomic) BOOL leaveday_follow_lesson;
@property (nonatomic) NSInteger colorcode;
@property (strong,nonatomic) NSString *fcsubject;
@property (strong,nonatomic) NSMutableDictionary *lessonnumberDict;
@property (nonatomic) BOOL leaveday_follow_category;
@property (nonatomic) BOOL allowsameschedule;
@property (strong,nonatomic) NSString *subject_fulldescription;
@property (strong,nonatomic) NSString *subject_image;
@property (nonatomic) BOOL publishinchatbot;
@property (strong,nonatomic) NSString *chatbot_category;
@property (strong,nonatomic) NSString *chatbot_tag1;
@property (nonatomic) BOOL trial_by_existinglesson;
@property (nonatomic) BOOL trial_by_definedschedule;
@property (strong,nonatomic) NSString *trialcapacity;
@property (nonatomic) BOOL chatbot_enabletrial;
@property (nonatomic) BOOL showmakeupbuttonifnotimeslot;
@property (strong,nonatomic) NSString *btspromotioncode831;
@property (strong,nonatomic) NSString *btspromotioncode1031;
@property (nonatomic) BOOL showabsentbuttononarrangeleave;
@property (nonatomic) NSInteger pregenperiodcount;
@property (strong,nonatomic) NSString *autolevelupgrade;

#pragma mark -
#pragma mark Class Methods

-(id)initSubjectRecordwithCenterkey:(NSString *)ccenterkey Subjectkey:(NSString *)csubjectkey Subject_Englishname:(NSString *)csubject_englishname Subject_Chinesename:(NSString *)csubject_chinesename Subject_shortname:(NSString *)csubject_shortname Enrollmentmode:(NSString *)cenrollmentmode Tuition_method:(NSString *)ctuition_method Tuition_mode:(NSString *)ctuition_mode Studentcapacity:(NSString *)cstudentcapacity StandardNoOfClassOrMonth:(NSString *)cstandardnoofclassormonth ClassDuration:(NSString *)cclassduration ClassDurationAssessment:(NSString *)cclassdurationassessment ClassDurationTrial:(NSString *)cclassdurationtrial Status:(NSString *)cstatus LevelArray:(NSMutableArray *)clevelArray TuitionArray:(NSMutableArray *)ctuitionArray Remarks:(NSString *)cremarks ScheduleArray:(NSMutableArray *)cschedulearray Subject_Category:(NSString *)csubject_category WeeklyAutoRenewDefault:(BOOL)cweeklyautorenewdefault validity:(NSString *)cvalidity makeup_quota_unit:(NSString *)cmakeup_quota_unit makeup_quota_value:(NSString *)cmakeup_quota_value leaveday_by_makeupschedule:(BOOL)cleaveday_by_makeupschedule leaveday_by_classdate:(BOOL)cleaveday_by_classdate leaveday_follow_teacher:(BOOL)cleaveday_follow_teacher leaveday_by_enrolledschedule:(BOOL)cleaveday_by_enrolledschedule leaveday_by_staffschedule:(BOOL)cleaveday_by_staffschedule leaveday_follow_level:(BOOL)cleaveday_follow_level leaveday_follow_lesson:(BOOL)cleaveday_follow_lesson colorcode:(NSInteger)scolorcode fcsubject:(NSString *)cfcsubject lessonnumberDict:(NSMutableDictionary *)clessonnumberDict leaveday_follow_category:(BOOL)cleaveday_follow_category allowsameschedule:(BOOL)callowsameschedule subject_fulldescription:(NSString *)csubject_fulldescription subject_image:(NSString *)csubject_image publishinchatbot:(BOOL)cpublishinchatbot chatbot_category:(NSString *)cchatbot_category chatbot_tag1:(NSString *)cchatbot_tag1 trial_by_existinglesson:(BOOL)ctrial_by_existinglesson trial_by_definedschedule:(BOOL)ctrial_by_definedschedule trialcapacity:(NSString *)ctrialcapacity chatbot_enabletrial:(BOOL)cchatbot_enabletrial showmakeupbuttonifnotimeslot:(BOOL)cshowmakeupbuttonifnotimeslot btspromotioncode831:(NSString *)cbtspromotioncode831 btspromotioncode1031:(NSString *)cbtspromotioncode1031 showabsentbuttononarrangeleave:(BOOL)cshowabsentbuttononarrangeleave pregenperiodcount:(NSInteger)cpregenperiodcount autolevelupgrade:(NSString *)cautolevelupgrade;
@end


@interface ProductRecord : NSObject{
    
    NSString *centerkey;
    NSString *productkey;
    NSString *category;
    NSString *englishname;
    NSString *chinesename;
    NSString *code;
    NSString *price;
    NSString *status;
    NSString *remarks;
    NSString *autorenew;
    NSString *avatar;
    NSString *stockcount;
    NSString *allstockcounts;
    NSString *alertthreshold;
}
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * productkey;
@property (strong,nonatomic) NSString * category;
@property (strong,nonatomic) NSString * englishname;
@property (strong,nonatomic) NSString * chinesename;
@property (strong,nonatomic) NSString * code;
@property (strong,nonatomic) NSString * price;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * autorenew;
@property (strong,nonatomic) NSString * avatar;
@property (strong,nonatomic) NSString * stockcount;
@property (strong,nonatomic) NSString * allstockcounts;
@property (strong,nonatomic) NSString * alertthreshold;


#pragma mark -
#pragma mark Class Methods

-(id)initProductRecordwithCenterkey:(NSString *)ccenterkey Productkey:(NSString *)cproductkey Category:(NSString *)ccategory Englishname:(NSString *)cenglishname Chinesename:(NSString *)cchinesename Code:(NSString *)ccode Price:(NSString *)cprice Status:(NSString *)cstatus Remarks:(NSString *)cremarks Autorenew:(NSString *)cautorenew avatar:(NSString *)cavatar stockCount:(NSString *)cstockcount alertThreshold:(NSString *)calertthreshold allstockcounts:(NSString *)callstockcounts;

@end

@interface SalesRecord : NSObject{
    NSString *studentkey;
    NSString *saleskey;
    NSString *orderdate;
    NSString *productfullname;
    NSString *productcode;
    NSString *productcategory;
    NSString *price;
    NSString *quantity;
    NSString *oneoffdiscount;
    NSString *oneoffpercentagediscount;
    NSString *paid;
    NSString *total;
    NSString *remarks;
    NSString *invoiceremarks;
    NSString *status;
    NSString *reverseadjustment;
    NSString *autorenew;
    NSMutableArray *paymentrecords;
    NSMutableArray *promotiondiscountrecords;
    NSString * givenout;
    NSMutableArray *couponrecords;
    NSString *invoicenumber;
    NSString *invoiceprefix;
}

@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * saleskey;
@property (strong,nonatomic) NSString * orderdate;
@property (strong,nonatomic) NSString * productfullname;
@property (strong,nonatomic) NSString * productcode;
@property (strong,nonatomic) NSString * productcategory;
@property (strong,nonatomic) NSString * price;
@property (strong,nonatomic) NSString * quantity;
@property (strong,nonatomic) NSString * oneoffdiscount;
@property (strong,nonatomic) NSString * oneoffpercentagediscount;
@property (strong,nonatomic) NSString * paid;
@property (strong,nonatomic) NSString * total;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * invoiceremarks;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) NSString * reverseadjustment;
@property (strong,nonatomic) NSString * autorenew;
@property (strong,nonatomic) NSMutableArray *paymentrecords;
@property (strong,nonatomic) NSMutableArray *promotiondiscountrecords;
@property (strong,nonatomic) NSString * givenout;
@property (strong,nonatomic) NSMutableArray * couponrecords;
@property (strong,nonatomic) NSString * invoicenumber;
@property (strong,nonatomic) NSString * invoiceprefix;

#pragma mark -
#pragma mark Class Methods

-(id)initSalesRecordWithstudentkey: (NSString *)cstudentkey saleskey: (NSString *)csaleskey orderdate:(NSString *)corderdate productfullname:(NSString *)cproductfullname productcode:(NSString *)cproductcode productcategory:(NSString *)cproductcategory price:(NSString *)cprice quantity:(NSString *)cquantity oneoffdiscount:(NSString *)coneoffdiscount oneoffpercentagediscount:(NSString *)coneoffpercentagediscount paid:(NSString *)cpaid total:(NSString *)ctotal remarks:(NSString *)cremarks invoiceremarks:(NSString *)cinvoiceremarks status:(NSString *)cstatus reverseadjustment:(NSString *)creverseadjustment autorenew:(NSString *)cautorenew paymentrecords:(NSMutableArray *)cpaymentrecords promotiondiscountrecords:(NSMutableArray *)cpromotiondiscountrecords givenout:(NSString *)cgivenout couponrecords:(NSMutableArray *)ccouponrecords invoicenumber:(NSString *)cinvoicenumber invoiceprefix:(NSString *)cinvoiceprefix;


@end

@interface LicenseRecord : NSObject{
    NSString *appname;
    NSString *licensedcount;
    NSString *usedcount;
    NSString *remainingcount;
}

@property (strong,nonatomic) NSString * appname;
@property (strong,nonatomic) NSString * licensedcount;
@property (strong,nonatomic) NSString * usedcount;
@property (strong,nonatomic) NSString * remainingcount;

#pragma mark -
#pragma mark Class Methods

-(id)initLicenseRecordWithappname: (NSString *)cappname licensecount: (NSString *)clicensecount usedcount:(NSString *)cusedcount remainingcont:(NSString *)cremainingcount;

@end

@interface DeviceRecord : NSObject{
    NSString *userdevicekey;
    NSString *stafforstudentname;
    NSString *deviceidentifier;
    NSString *devicename;
    NSString *deviceos;
    NSString *deviceversion;
    NSString *appname;
    NSString *lastlogin;
    NSString *stafforstudentkey;
    NSString *usertokenkey;
    NSString *contact;
    NSString *relationship;
}

@property (strong,nonatomic) NSString * userdevicekey;
@property (strong,nonatomic) NSString * stafforstudentname;
@property (strong,nonatomic) NSString * deviceidentifier;
@property (strong,nonatomic) NSString * devicename;
@property (strong,nonatomic) NSString * deviceos;
@property (strong,nonatomic) NSString * deviceversion;
@property (strong,nonatomic) NSString * appname;
@property (strong,nonatomic) NSString * lastlogin;
@property (strong,nonatomic) NSString * stafforstudentkey;
@property (strong,nonatomic) NSString * usertokenkey;
@property (strong,nonatomic) NSString * contact;
@property (strong,nonatomic) NSString * relationship;

#pragma mark -
#pragma mark Class Methods

-(id)initDeviceRecordWithuserdevicekey:(NSString *)cuserdevicekey stafforstudentname:(NSString *)cstafforstudentname deviceidentifier:(NSString *)cdeviceidentifier devicename:(NSString *)cdevicename deviceos:(NSString *)cdeviceos deviceversion:(NSString *)cdeviceversion lastlogin:(NSString *)clastlogin stafforstudentkey:(NSString *)cstafforstudentkey appname:(NSString *)cappname usertokenkey:(NSString *)cusertokenkey contact:(NSString *)ccontact relationship:(NSString *)crelationship;

@end

@interface TabRecord : NSObject{
    NSString *tabid;
    NSMutableArray *headerlistarray;
    NSString *mode;
    NSString *selecteddate;
}

@property (strong,nonatomic) NSString * tabid;
@property (strong,nonatomic) NSMutableArray * headerlistarray;
@property (strong,nonatomic) NSString * mode;
@property (strong,nonatomic) NSString * selecteddate;

#pragma mark -
#pragma mark Class Methods

-(id)initTabRecordWithtabid:(NSString *)ctabid headerlistarray:(NSMutableArray *)cheaderlistarray mode:(NSString *)cmode selecteddate:(NSString *)cselecteddate;

@end


@interface ClassReceiptRecord : NSObject{
    NSString *studentkey;
    NSString *studentname;
//    NSString *gender;
    NSString *studentid;
    NSString *parentemail;
    NSString *preferredlanguage;
    
    NSString *enrollmentkey;
    NSString *enrollmentdate;
    NSString *tuitionfee;
    NSString *enrollmentfee;
    NSString *latefee;
    NSString *discount;
    NSString *totalfee;
    
    NSString *subject_shortname;
    NSString *startdate;
    NSString *noofclass;
    NSString *enddate;
    NSString *classtime;
    NSString *classday;
    NSString *levelmain;
    
    NSString *paymentkey;
    NSString *paiddate;
    NSString *paid;
    NSString *paidmethod;
    NSString *totalpaid;
    NSString *staffname;
    NSString *receiptremarks;
    NSString *image;
    NSString *checkstatus;
    NSString *validity;
    EnrollmentRecord *enrollmentrecord;
    NSString *paymentremarks;
    NSString *subjectname;
}

@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * studentname;
//@property (strong,nonatomic) NSString * gender;
@property (strong,nonatomic) NSString * studentid;
@property (strong,nonatomic) NSString * parentemail;
@property (strong,nonatomic) NSString * preferredlanguage;

@property (strong,nonatomic) NSString * enrollmentkey;
@property (strong,nonatomic) NSString * enrollmentdate;
@property (strong,nonatomic) NSString * tuitionfee;
@property (strong,nonatomic) NSString * enrollmentfee;
@property (strong,nonatomic) NSString * latefee;
@property (strong,nonatomic) NSString * discount;
@property (strong,nonatomic) NSString * totalfee;

@property (strong,nonatomic) NSString * subject_shortname;
@property (strong,nonatomic) NSString * startdate;
@property (strong,nonatomic) NSString * noofclass;
@property (strong,nonatomic) NSString * enddate;
@property (strong,nonatomic) NSString * classtime;
@property (strong,nonatomic) NSString * classday;
@property (strong,nonatomic) NSString * levelmain;

@property (strong,nonatomic) NSString * paymentkey;
@property (strong,nonatomic) NSString * paiddate;
@property (strong,nonatomic) NSString * paid;
@property (strong,nonatomic) NSString * paidmethod;
@property (strong,nonatomic) NSString * totalpaid;
@property (strong,nonatomic) NSString * staffname;
@property (strong,nonatomic) NSString * receiptremarks;
@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString * checkstatus;
@property (strong,nonatomic) NSString * validity;
@property (strong,nonatomic) EnrollmentRecord * enrollmentrecord;
@property (strong,nonatomic) NSString * paymentremarks;
@property (strong,nonatomic) NSString * subjectname;

#pragma mark -
#pragma mark Class Methods

-(id)initClassReceiptRecordWithstudentkey:(NSString *)cstudentkey studentname:(NSString *)cstudentname studentid:(NSString *)cstudentid parentemail:(NSString *)cparentemail preferredlanguage:(NSString *)cpreferredlanguage enrollmentkey:(NSString *)cenrollmentkey enrollmentdate:(NSString *)cenrollmentdate tuitionfee:(NSString *)ctuitionfee enrollmentfee:(NSString *)cenrollmentfee latefee:(NSString *)clatefee discount:(NSString *)cdiscount totalfee:(NSString *)ctotalfee subject_shortname:(NSString *)csubject_shortname startdate:(NSString *)cstartdate noofclass:(NSString *)cnoofclass enddate:(NSString *)cenddate classtime:(NSString *)cclasstime classday:(NSString *)cclassday levelmain:(NSString *)clevelmain paymentkey:(NSString *)cpaymentkey paiddate:(NSString *)cpaiddate paid:(NSString *)cpaid paidmethod:(NSString *)cpaidmethod totalpaid:(NSString *)ctotalpaid staffname:(NSString *)cstaffname receiptremarks:(NSString *)creceiptremarks image:(NSString *)cimage checkstatus:(NSString *)ccheckstatus validity:(NSString *)cvalidity enrollmentrecord:(EnrollmentRecord *)cenrollmentrecord paymentremarks:(NSString *)cpaymentremarks subjectname:(NSString *)csubjectname;

@end

@interface SalesReceiptRecord : NSObject{
    NSString *studentkey;
    NSString *studentname;
    NSString *studentid;
    NSString *parentemail;
    NSString *preferredlanguage;
    
    NSString *saleskey;
    NSString *orderdate;
    NSString *price;
    NSString *discount;
    NSString *totalfee;
    
    NSString *productcode;
    NSString *quantity;
    
    NSString *paymentkey;
    NSString *paiddate;
    NSString *paid;
    NSString *paidmethod;
    NSString *totalpaid;
    NSString *staffname;
    NSString *receiptremarks;
    NSString *image;
    NSString *checkstatus;
    SalesRecord *salesrecord;
    NSString *paymentremarks;
    NSString *productname;
}

@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * studentname;
@property (strong,nonatomic) NSString * studentid;
@property (strong,nonatomic) NSString * parentemail;
@property (strong,nonatomic) NSString * preferredlanguage;

@property (strong,nonatomic) NSString * saleskey;
@property (strong,nonatomic) NSString * orderdate;
@property (strong,nonatomic) NSString * price;
@property (strong,nonatomic) NSString * discount;
@property (strong,nonatomic) NSString * totalfee;

@property (strong,nonatomic) NSString * productcode;
@property (strong,nonatomic) NSString * quantity;

@property (strong,nonatomic) NSString * paymentkey;
@property (strong,nonatomic) NSString * paiddate;
@property (strong,nonatomic) NSString * paid;
@property (strong,nonatomic) NSString * paidmethod;
@property (strong,nonatomic) NSString * totalpaid;
@property (strong,nonatomic) NSString * staffname;
@property (strong,nonatomic) NSString * receiptremarks;
@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString * checkstatus;
@property (strong,nonatomic) SalesRecord * salesrecord;
@property (strong,nonatomic) NSString * paymentremarks;
@property (strong,nonatomic) NSString * productname;

#pragma mark -
#pragma mark Class Methods

-(id)initSalesReceiptRecordWithstudentkey:(NSString *)cstudentkey studentname:(NSString *)cstudentname studentid:(NSString *)cstudentid parentemail:(NSString *)cparentemail preferredlanguage:(NSString *)cpreferredlanguage saleskey:(NSString *)csaleskey orderdate:(NSString *)corderdate price:(NSString *)cprice discount:(NSString *)cdiscount totalfee:(NSString *)ctotalfee productcode:(NSString *)cproductcode quantity:(NSString *)cquantity paymentkey:(NSString *)cpaymentkey paiddate:(NSString *)cpaiddate paid:(NSString *)cpaid paidmethod:(NSString *)cpaidmethod totalpaid:(NSString *)ctotalpaid staffname:(NSString *)cstaffname receiptremarks:(NSString *)creceiptremarkscreceiptremarks image:(NSString *)cimage checkstatus:(NSString *)ccheckstatus salesrecord:(SalesRecord *)csalesrecord paymentremarks:(NSString *)cpaymentremarks productname:(NSString *)cproductname;

@end



@interface ClassInvoiceRecord : NSObject{
    NSString *studentkey;
    NSString *studentname;
    NSString *studentid;
    NSString *parentemail;
    NSString *preferredlanguage;
    
    
    NSString *enrollmentkey;
    NSString *enrollmentdate;
    NSString *tuitionfee;
    NSString *enrollmentfee;
    NSString *latefee;
    NSString *discount;
    NSString *totalfee;
    
    NSString *subject_shortname;
    NSString *startdate;
    NSString *noofclass;
    NSString *enddate;
    NSString *classtime;
    NSString *classday;
    NSString *levelmain;
    

    NSString *outstandingamount;
    NSString *invoiceremarks;
    NSString *image;
    NSString *checkstatus;
    NSString *validity;
    EnrollmentRecord *enrollmentrecord;
    NSString *subjectname;
}

@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * studentname;
@property (strong,nonatomic) NSString * studentid;
@property (strong,nonatomic) NSString * parentemail;
@property (strong,nonatomic) NSString * preferredlanguage;

@property (strong,nonatomic) NSString * enrollmentkey;
@property (strong,nonatomic) NSString * enrollmentdate;
@property (strong,nonatomic) NSString * tuitionfee;
@property (strong,nonatomic) NSString * enrollmentfee;
@property (strong,nonatomic) NSString * latefee;
@property (strong,nonatomic) NSString * discount;
@property (strong,nonatomic) NSString * totalfee;


@property (strong,nonatomic) NSString * subject_shortname;
@property (strong,nonatomic) NSString * startdate;
@property (strong,nonatomic) NSString * noofclass;
@property (strong,nonatomic) NSString * enddate;
@property (strong,nonatomic) NSString * classtime;
@property (strong,nonatomic) NSString * classday;
@property (strong,nonatomic) NSString * levelmain;

@property (strong,nonatomic) NSString * outstandingamount;
@property (strong,nonatomic) NSString * invoiceremarks;
@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString * checkstatus;
@property (strong,nonatomic) NSString * validity;
@property (strong,nonatomic) EnrollmentRecord * enrollmentrecord;
@property (strong,nonatomic) NSString * subjectname;

#pragma mark -
#pragma mark Class Methods

-(id)initClassInvoiceRecordWithstudentkey:(NSString *)cstudentkey studentname:(NSString *)cstudentname studentid:(NSString *)cstudentid parentemail:(NSString *)cparentemail preferredlanguage:(NSString *)cpreferredlanguage enrollmentkey:(NSString *)cenrollmentkey enrollmentdate:(NSString *)cenrollmentdate tuitionfee:(NSString *)ctuitionfee enrollmentfee:(NSString *)cenrollmentfee latefee:(NSString *)clatefee discount:(NSString *)cdiscount totalfee:(NSString *)ctotalfee subject_shortname:(NSString *)csubject_shortname startdate:(NSString *)cstartdate noofclass:(NSString *)cnoofclass enddate:(NSString *)cenddate classtime:(NSString *)cclasstime classday:(NSString *)cclassday levelmain:(NSString *)clevelmain outstandingamount:(NSString *)coutstandingamount invoiceremarks:(NSString *)cinvoiceremarks image:(NSString *)cimage checkstatus:(NSString *)ccheckstatus validity:(NSString *)cvalidity enrollmentrecord:(EnrollmentRecord *)cenrollmentrecord subjectname:(NSString *)csubjectname;


@end

@interface SalesInvoiceRecord : NSObject{
    NSString *studentkey;
    NSString *studentname;
    NSString *studentid;
    NSString *parentemail;
    NSString *preferredlanguage;
    
    NSString *saleskey;
    NSString *orderdate;
    NSString *price;
    NSString *discount;
    NSString *totalfee;
    
    NSString *productcode;
    NSString *quantity;
    
    NSString *outstandingamount;
    NSString *invoiceremarks;
    NSString *image;
    NSString *checkstatus;
    SalesRecord *salesrecord;
    NSString *productname;
}

@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * studentname;
@property (strong,nonatomic) NSString * studentid;
@property (strong,nonatomic) NSString * parentemail;

@property (strong,nonatomic) NSString * saleskey;
@property (strong,nonatomic) NSString * orderdate;
@property (strong,nonatomic) NSString * price;
@property (strong,nonatomic) NSString * discount;
@property (strong,nonatomic) NSString * totalfee;

@property (strong,nonatomic) NSString * productcode;
@property (strong,nonatomic) NSString * quantity;

@property (strong,nonatomic) NSString * outstandingamount;
@property (strong,nonatomic) NSString * invoiceremarks;
@property (strong,nonatomic) NSString * preferredlanguage;
@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString * checkstatus;
@property (strong,nonatomic) SalesRecord * salesrecord;
@property (strong,nonatomic) NSString * productname;

#pragma mark -
#pragma mark Class Methods

-(id)initSalesInvoiceRecordWithstudentkey:(NSString *)cstudentkey studentname:(NSString *)cstudentname studentid:(NSString *)cstudentid parentemail:(NSString *)cparentemail preferredlanguage:(NSString *)cpreferredlanguage saleskey:(NSString *)csaleskey orderdate:(NSString *)corderdate price:(NSString *)cprice discount:(NSString *)cdiscount totalfee:(NSString *)ctotalfee productcode:(NSString *)cproductcode quantity:(NSString *)cquantity outstandingamount:(NSString *)coutstandingamount invoiceremarks:(NSString *)cinvoiceremarks image:(NSString *)cimage checkstatus:(NSString *)ccheckstatus salesrecord:(SalesRecord *)csalesrecord productname:(NSString *)cproductname;

@end

@interface ClassPaymentRecord : NSObject{
    NSString *studentkey;
    NSString *studentname;
    NSString *studentid;
    NSString *parentemail;
    NSString *preferredlanguage;
    
    
    NSString *enrollmentkey;
    NSString *enrollmentdate;
    NSString *totalfee;
    
    NSString *subject_shortname;
    NSString *startdate;
    NSString *noofclass;
    NSString *enddate;
    NSString *classtime;
    NSString *classday;
    NSString *levelmain;
    
    
    NSString *outstandingamount;
    NSString *image;
    NSString *paidamount;
    NSString *paidmethod;
    NSString *paymentremarks;
    NSString *receiptremarks;
    NSString *paiddate;
    NSString *checkstatus;
    EnrollmentRecord *enrollmentrecord;
    
}

@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * studentname;
@property (strong,nonatomic) NSString * studentid;
@property (strong,nonatomic) NSString * parentemail;
@property (strong,nonatomic) NSString * preferredlanguage;

@property (strong,nonatomic) NSString * enrollmentkey;
@property (strong,nonatomic) NSString * enrollmentdate;
@property (strong,nonatomic) NSString * tuitionfee;

@property (strong,nonatomic) NSString * totalfee;


@property (strong,nonatomic) NSString * subject_shortname;
@property (strong,nonatomic) NSString * startdate;
@property (strong,nonatomic) NSString * noofclass;
@property (strong,nonatomic) NSString * enddate;
@property (strong,nonatomic) NSString * classtime;
@property (strong,nonatomic) NSString * classday;
@property (strong,nonatomic) NSString * levelmain;

@property (strong,nonatomic) NSString * outstandingamount;
@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString *paidamount;
@property (strong,nonatomic) NSString *paidmethod;
@property (strong,nonatomic) NSString *paymentremarks;
@property (strong,nonatomic) NSString *receiptremarks;
@property (strong,nonatomic) NSString *paiddate;
@property (strong,nonatomic) NSString *checkstatus;
@property (strong,nonatomic) EnrollmentRecord *enrollmentrecord;


#pragma mark -
#pragma mark Class Methods

-(id)initClassPaymentRecordWithstudentkey:(NSString *)cstudentkey studentname:(NSString *)cstudentname studentid:(NSString *)cstudentid parentemail:(NSString *)cparentemail preferredlanguage:(NSString *)cpreferredlanguage enrollmentkey:(NSString *)cenrollmentkey enrollmentdate:(NSString *)cenrollmentdate tuitionfee:(NSString *)ctuitionfee totalfee:(NSString *)ctotalfee subject_shortname:(NSString *)csubject_shortname startdate:(NSString *)cstartdate noofclass:(NSString *)cnoofclass enddate:(NSString *)cenddate classtime:(NSString *)cclasstime classday:(NSString *)cclassday levelmain:(NSString *)clevelmain outstandingamount:(NSString *)coutstandingamount image:(NSString *)cimage paidamount:(NSString *)cpaidamount paidmethod:(NSString *)cpaidmethod paymentremarks:(NSString *)cpaymentremarks receiptremarks:(NSString *)creceiptremarks paiddate:(NSString *)cpaiddate checkstatus:(NSString *)ccheckstatus enrollmentrecord:(EnrollmentRecord *)cenrollmentrecord;


@end

@interface SalesPaymentRecord : NSObject{
    NSString *studentkey;
    NSString *studentname;
    NSString *studentid;
    NSString *parentemail;
    NSString *preferredlanguage;
    
    NSString *saleskey;
    NSString *orderdate;
    NSString *price;
    NSString *totalfee;
    
    NSString *productcode;
    NSString *quantity;
    
    NSString *outstandingamount;
    NSString *image;
    NSString *paidamount;
    NSString *paidmethod;
    NSString *paymentremarks;
    NSString *receiptremarks;
    NSString *paiddate;
    NSString *checkstatus;
    SalesRecord *salesrecord;
}

@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * studentname;
@property (strong,nonatomic) NSString * studentid;
@property (strong,nonatomic) NSString * parentemail;

@property (strong,nonatomic) NSString * saleskey;
@property (strong,nonatomic) NSString * orderdate;
@property (strong,nonatomic) NSString * price;
@property (strong,nonatomic) NSString * totalfee;

@property (strong,nonatomic) NSString * productcode;
@property (strong,nonatomic) NSString * quantity;

@property (strong,nonatomic) NSString * outstandingamount;
@property (strong,nonatomic) NSString * preferredlanguage;
@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString *paidamount;
@property (strong,nonatomic) NSString *paidmethod;
@property (strong,nonatomic) NSString *paymentremarks;
@property (strong,nonatomic) NSString *receiptremarks;
@property (strong,nonatomic) NSString *paiddate;
@property (strong,nonatomic) NSString *checkstatus;
@property (strong,nonatomic) SalesRecord *salesrecord;


#pragma mark -
#pragma mark Class Methods

-(id)initSalesPaymentRecordWithstudentkey:(NSString *)cstudentkey studentname:(NSString *)cstudentname studentid:(NSString *)cstudentid parentemail:(NSString *)cparentemail preferredlanguage:(NSString *)cpreferredlanguage saleskey:(NSString *)csaleskey orderdate:(NSString *)corderdate price:(NSString *)cprice totalfee:(NSString *)ctotalfee productcode:(NSString *)cproductcode quantity:(NSString *)cquantity outstandingamount:(NSString *)coutstandingamount image:(NSString *)cimage paidamount:(NSString *)cpaidamount paidmethod:(NSString *)cpaidmethod paymentremarks:(NSString *)cpaymentremarks receiptremarks:(NSString *)creceiptremarks paiddate:(NSString *)cpaiddate checkstatus:(NSString *)ccheckstatus salesrecord:(SalesRecord *)csalesrecord;

@end



@interface DocumentFolder : NSObject{
    NSMutableArray *classinvoicearray;
    NSMutableArray *classreceiptarray;
    NSMutableArray *salesinvoicearray;
    NSMutableArray *salesreceiptarray;
    NSMutableArray *classpaymentarray;
    NSMutableArray *salespaymentarray;
    
    NSMutableArray *defaultcheckedclassinvoiceenrollmentkeys;
    NSMutableArray *defaultcheckedclasspaymentenrollmentkeys;
    NSMutableArray *defaultcheckedsalesinvoicesaleskeys;
    NSMutableArray *defaultcheckedsalespaymentsaleskeys;
    NSMutableArray *defaultcheckedclassreceiptenrollmentkeys;
    NSMutableArray *defaultcheckedsalesreceiptsaleskeys;
    
}

@property (strong,nonatomic) NSMutableArray * classinvoicearray;
@property (strong,nonatomic) NSMutableArray * classreceiptarray;
@property (strong,nonatomic) NSMutableArray * salesinvoicearray;
@property (strong,nonatomic) NSMutableArray * salesreceiptarray;
@property (strong,nonatomic) NSMutableArray * classpaymentarray;
@property (strong,nonatomic) NSMutableArray * salespaymentarray;
@property (strong,nonatomic) NSMutableArray * defaultcheckedclassinvoiceenrollmentkeys;
@property (strong,nonatomic) NSMutableArray * defaultcheckedclasspaymentenrollmentkeys;
@property (strong,nonatomic) NSMutableArray * defaultcheckedsalesinvoicesaleskeys;
@property (strong,nonatomic) NSMutableArray * defaultcheckedsalespaymentsaleskeys;
@property (strong,nonatomic) NSMutableArray * defaultcheckedclassreceiptenrollmentkeys;
@property (strong,nonatomic) NSMutableArray * defaultcheckedsalesreceiptsaleskeys;

#pragma mark -
#pragma mark Class Methods

-(id)initDocumentFolderWithClassInvoiceArray:(NSMutableArray *)cclassinvoicearray ClassReceiptArray:(NSMutableArray *)cclassreceiptarray SalesInvoiceArray:(NSMutableArray *)csalesinvoicearray SalesReceiptArray:(NSMutableArray *)csalesreceiptarray ClassPaymentArray:(NSMutableArray *)cclasspaymentarray SalesPaymentArray:(NSMutableArray *)csalespaymentarray defaultcheckedclassinvoiceenrollmentkeys:(NSMutableArray *)cdefaultcheckedclassinvoiceenrollmentkeys defaultcheckedclasspaymentenrollmentkeys:(NSMutableArray *)cdefaultcheckedclasspaymentenrollmentkeys defaultcheckedsalesinvoicesaleskeys:(NSMutableArray *)cdefaultcheckedsalesinvoicesaleskeys defaultcheckedsalespaymentsaleskeys:(NSMutableArray *)cdefaultcheckedsalespaymentsaleskeys defaultcheckedclassreceiptenrollmentkeys:(NSMutableArray *)cdefaultcheckedclassreceiptenrollmentkeys defaultcheckedsalesreceiptsaleskeys:(NSMutableArray *)cdefaultcheckedsalesreceiptsaleskeys;


@end

@interface CallLogRecord : NSObject{
    NSString *calllogkey;
    NSString *calledon;
    NSString *calledby;
    NSString *details;
    NSString *calledbyfullname;
}

@property (strong,nonatomic) NSString * calllogkey;
@property (strong,nonatomic) NSString * calledon;
@property (strong,nonatomic) NSString * calledby;
@property (strong,nonatomic) NSString * details;
@property (strong,nonatomic) NSString * calledbyfullname;


#pragma mark -
#pragma mark Class Methods

-(id)initCallLogRecordWithcalllogkey:(NSString *)ccalllogkey calledon:(NSString *)ccalledon calledby:(NSString *)ccalledby details:(NSString *)cdetails calledbyfullname:(NSString *)ccalledbyfullname;

@end

@interface Lead : NSObject{
    NSString *leadkey;
    NSString *firstname;
    NSString *lastname;
    NSString *othername;
    NSString *gender;
    NSString *dateofbirth;
    NSString *age;
    NSString *grade;
    NSString *preferredlanguage;
    NSString *school;
    
    NSString *parentname;
    NSString *parentcontact;
    NSString *parentemail;
    NSString *parentaddress;
    
    NSString *remarks;
    NSString *status;
    NSString *flag;
    NSString *promtion;
    NSString *image;
    NSString *leadid;
    NSString *leadmedia;
    NSString *leadsource;
    NSString *studentkey;
    ClassValidateRecord *photoalbumrecord;
    NSString *centerkey;
    NSString *iso_code;
    NSString *avatar;
    
}

@property (strong,nonatomic) NSString * leadkey;
@property (strong,nonatomic) NSString * firstname;
@property (strong,nonatomic) NSString * lastname;
@property (strong,nonatomic) NSString * othername;
@property (strong,nonatomic) NSString * gender;
@property (strong,nonatomic) NSString * dateofbirth;
@property (strong,nonatomic) NSString * age;
@property (strong,nonatomic) NSString * grade;
@property (strong,nonatomic) NSString * preferredlanguage;
@property (strong,nonatomic) NSString * school;

@property (strong,nonatomic) NSString * parentname;
@property (strong,nonatomic) NSString * parentcontact;
@property (strong,nonatomic) NSString * parentemail;
@property (strong,nonatomic) NSString * parentaddress;

@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * flag;
@property (strong,nonatomic) NSString * promotion;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString * leadid;
@property (strong,nonatomic) NSString * leadmedia;
@property (strong,nonatomic) NSString * leadsource;
@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) ClassValidateRecord *photoalbumrecord;
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * iso_code;
@property (strong,nonatomic) NSString * avatar;

#pragma mark -
#pragma mark Class Methods

-(id)initLeadWithleadkey:(NSString *)sleadkey firstname:(NSString *)sfirstname lastname:(NSString *)slastname othername:(NSString *)sothername gender:(NSString *)sgender dateofbirth:(NSString *)sdateofbirth age:(NSString *)sage grade:(NSString *)sgrade preferredlanguage: (NSString *)spreferredlanguage school:(NSString *)sschool parentname:(NSString *)sparentname parentcontact:(NSString *)sparentcontact parentemail:(NSString *)sparentemail parentaddress:(NSString *)sparentaddress remarks:(NSString *)sremarks flag:(NSString *)sflag promotion:(NSString *)spromotion status:(NSString *)sstatus image:(NSString *)simage leadid:(NSString *)sleadid leadmedia:(NSString *)sleadmedia leadsource:(NSString *)sleadsource studentkey:(NSString *)sstudentkey photoalbumrecord:(ClassValidateRecord *)sphotoalbumrecord centerkey:(NSString *)scenterkey iso_code:(NSString *)siso_code avatar:(NSString *)savatar;


@end


@interface MarketingRecord : NSObject{
    NSString *centerkey;
    NSString *marketingkey;
    NSString *category;
    NSString *description;
    NSString *description_chinese;
    NSString *startdate;
    NSString *enddate;
    NSString *remarks;
    NSString *promotionfixeddiscount;
    NSString *promotionpercentagediscount;
    NSString *usedcount;
    NSString *promotionquota;
    NSString *code;
    NSString *recursive;
    NSString *effectivefrom;
    NSString *effectiveto;
    NSString *subcategory;
    BOOL redeemable;
    NSString *redeempoint;
    NSString *perstudentquota;
    BOOL cannotuseconjunctionwithothercoupons;
    NSMutableArray *subjectarray;
    NSMutableArray *productarray;
    NSString *couponallowcredit;
    BOOL perclassorquantity;
    NSString *earlybirdlastdate;
    BOOL buymorepayless;
    NSString *estartdate;
    NSString *eenddate;
    BOOL enablebuymorepayless;
    NSInteger minnoofclass;
    BOOL bmsmacrossothersubjects;
    NSInteger bmsmminsubjectno;
    NSInteger bmsmminnoofclasspersubject;
    BOOL bmsmsamebillmonth;
    BOOL manualapply;
}

@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * marketingkey;
@property (strong,nonatomic) NSString * category;
@property (strong,nonatomic) NSString * description;
@property (strong,nonatomic) NSString * description_chinese;
@property (strong,nonatomic) NSString * startdate;
@property (strong,nonatomic) NSString * enddate;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * promotionfixeddiscount;
@property (strong,nonatomic) NSString * promotionpercentagediscount;
@property (strong,nonatomic) NSString * usedcount;
@property (strong,nonatomic) NSString * promotionquota;
@property (strong,nonatomic) NSString * code;
@property (strong,nonatomic) NSString * recursive;
@property (strong,nonatomic) NSString * effectivefrom;
@property (strong,nonatomic) NSString * effectiveto;
@property (strong,nonatomic) NSString * subcategory;
@property (nonatomic) BOOL redeemable;
@property (strong,nonatomic) NSString * redeempoint;
@property (strong,nonatomic) NSString * perstudentquota;
@property (nonatomic) BOOL cannotuseconjunctionwithothercoupons;
@property (strong,nonatomic) NSMutableArray *subjectarray;
@property (strong,nonatomic) NSMutableArray *productarray;
@property (strong,nonatomic) NSString * couponallowcredit;
@property (nonatomic) BOOL perclassorquantity;
@property (strong,nonatomic) NSString *earlybirdlastdate;
@property (nonatomic) BOOL buymorepayless;
@property (strong,nonatomic) NSString *estartdate;
@property (strong,nonatomic) NSString *eenddate;
@property (nonatomic) BOOL enablebuymorepayless;
@property (nonatomic) NSInteger minnoofclass;
@property (nonatomic) BOOL bmsmacrossothersubjects;
@property (nonatomic) NSInteger bmsmminsubjectno;
@property (nonatomic) NSInteger bmsmminnoofclasspersubject;
@property (nonatomic) BOOL bmsmsamebillmonth;
@property (nonatomic) BOOL manualapply;

#pragma mark -
#pragma mark Class Methods

-(id)initMarketingRecordWithcenterkey:(NSString *)ccenterkey marketingkey:(NSString *)cmarketingkey category:(NSString *)ccategory description:(NSString *)cdescription description_chinese:(NSString *)cdescription_chinese startdate:(NSString *)cstartdate enddate:(NSString *)cenddate remarks:(NSString *)cremarks promotionfixeddiscount:(NSString *)cpromotionfixeddiscount promotionpercentagediscount:(NSString *)cpromotionpercentagediscount usedcount:(NSString *)cusedcount promotionquota:(NSString *)cpromotionquota code:(NSString *)ccode recursive:(NSString *)crecursive effectivefrom:(NSString *)ceffectivefrom effectiveto:(NSString *)ceffectiveto subcategory:(NSString *)csubcategory redeemable:(BOOL)credeemable redeempoint:(NSString *)credeempoint perstudentquota:(NSString *)cperstudentquota cannotuseconjunctionwithothercoupons:(BOOL)ccannotuseconjunctionwithothercoupons subjectarray:(NSMutableArray *)csubjectarray productarray:(NSMutableArray *)cproductarray couponallowcredit:(NSString *)ccouponallowcredit perclassorquantity:(BOOL)cperclassorquantity earlybirdlastdate:(NSString *)cearlybirdlastdate buymorepayless:(BOOL)cbuymorepayless estartdate:(NSString *)cestartdate eenddate:(NSString *)ceenddate enablebuymorepayless:(BOOL)cenablebuymorepayless minnoofclass:(NSInteger)cminnoofclass bmsmacrossothersubjects:(BOOL)cbmsmacrossothersubjects bmsmminsubjectno:(NSInteger)cbmsmminsubjectno bmsmminnoofclasspersubject:(NSInteger)cbmsmminnoofclasspersubject bmsmsamebillmonth:(BOOL)cbmsmsamebillmonth manualapply:(BOOL)cmanualapply;

@end

@interface CouponRecord : NSObject{
    NSString *centerkey;
    NSString *couponkey;
    NSString *marketingkey;
    NSString *effectiveto;
    NSString *issuedate;
    NSString *dateused;
    NSString *effectivefrom;
    NSString *remarks;
    MarketingRecord *marketing;
    NSString *usedsequence;
    NSString *studentkey;
    BOOL cannotuseconjunctionwithothercoupons;
    BOOL creditable;
}

@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * marketingkey;
@property (strong,nonatomic) NSString * couponkey;
@property (strong,nonatomic) NSString * issuedate;
@property (strong,nonatomic) NSString * effectiveto;
@property (strong,nonatomic) NSString * dateused;
@property (strong,nonatomic) NSString * effectivefrom;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) MarketingRecord * marketing;
@property (strong,nonatomic) NSString * usedsequence;
@property (strong,nonatomic) NSString * studentkey;
@property (nonatomic) BOOL cannotuseconjunctionwithothercoupons;
@property (nonatomic) BOOL creditable;

#pragma mark -
#pragma mark Class Methods

-(id)initCouponRecordWithcenterkey:(NSString *)ccenterkey marketingkey:(NSString *)cmarketingkey couponkey:(NSString *)ccouponkey issuedate:(NSString *)cissuedate effectiveto:(NSString *)ceffectiveto dateused:(NSString *)cdateused effectivefrom:(NSString *)ceffectivefrom remarks:(NSString *)cremarks marketing:(MarketingRecord *)cmarketing usedsequence:(NSString *)cusedsequence studentkey:(NSString *)cstudentkey cannotuseconjunctionwithothercoupons:(BOOL)ccannotuseconjunctionwithothercoupons creditable:(BOOL)ccredeemed;

@end

@interface ClassroomRecord : NSObject{
    NSString *centerkey;
    NSString *classroomkey;
    NSString *classroom;
    NSString *status;
    NSString *remarks;
    NSString *capacity;
    NSInteger colorcode;
}

@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * classroomkey;
@property (strong,nonatomic) NSString * classroom;
@property (strong,nonatomic) NSString * status;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * capacity;
@property (nonatomic) NSInteger colorcode;

#pragma mark -
#pragma mark Class Methods

-(id)initClassroomRecordWithcenterkey:(NSString *)ccenterkey classroomkey:(NSString *)cclassroomkey classroom:(NSString *)cclassroom status:(NSString *)cstatus remarks:(NSString *)cremarks capacity:(NSString *)ccapacity colorcode:(NSInteger)scolorcode;

@end

@interface LanguageTitleRecord : NSObject{
    
    NSString *centerkey;
    NSString *title;
    NSString *chinese;
    NSString *english;
    NSString *schinese;
}
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * chinese;
@property (strong,nonatomic) NSString * english;
@property (strong,nonatomic) NSString * schinese;

#pragma mark -
#pragma mark Class Methods

-(id)initLanguageTitleRecordwithCenterkey:(NSString *)ccenterkey Title:(NSString *)ctitle Chinese:(NSString *)cchinese English:(NSString *)cenglish SChinese:(NSString *)cschinese;

@end

@interface LessonRecord : NSObject{
    
    NSString *lessonkey;
    NSString *classdate;
    NSString *classtime;
    NSString *subject;
    NSString *instructor;
    NSString *classroom;
    NSString *classcount;
    NSString *subjecttype;
    NSString *checkouttime;
    NSString *remarks;
    NSString *classduration;
    NSString *sinstructor;
}
@property (strong,nonatomic) NSString * lessonkey;
@property (strong,nonatomic) NSString * classdate;
@property (strong,nonatomic) NSString * classtime;
@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * instructor;
@property (strong,nonatomic) NSString * classroom;
@property (strong,nonatomic) NSString * classcount;
@property (strong,nonatomic) NSString * subjecttype;
@property (strong,nonatomic) NSString * checkouttime;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * classduration;
@property (strong,nonatomic) NSString * sinstructor;
#pragma mark -
#pragma mark Class Methods

-(id)initLessonRecordwithlessonkey:(NSString *)clessonkey classdate:(NSString *)cclassdate classtime:(NSString *)cclasstime subject:(NSString *)csubject instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom classcount:(NSString *)cclasscount subjecttype:(NSString *)csubjecttype checkouttime:(NSString *)ccheckouttime remarks:(NSString *)cremarks classduration:(NSString *)cclassduration sinstructor:(NSString *)csinstructor;

@end

@interface LessonAndClassRecord : NSObject{
    
    LessonRecord *lesson;
    NSMutableArray *classScheduleRecordArray;
    
}
@property (strong,nonatomic) LessonRecord * lesson;
@property (strong,nonatomic) NSMutableArray *classScheduleRecordArray;

#pragma mark -
#pragma mark Class Methods

-(id)initLessonAndClassRecordwithLesson:(LessonRecord *)clesson ClassScheduleRecordArray:(NSMutableArray *)cclassschedulerecordarray;

@end




@interface AttendanceButtonObject : NSObject{
    
    NSString *buttonname;
    UIColor *sectorcolor;
    NSString *imagename;
}
@property (strong,nonatomic) NSString *buttonname;
@property (strong,nonatomic) UIColor *sectorcolor;
@property (strong,nonatomic) NSString *imagename;

#pragma mark -
#pragma mark Class Methods

-(id)initAttendanceButtonObjectwithbuttonname:(NSString *)cbuttonname sectorcolor:(UIColor *)csectorcolor imagename:(NSString *)cimagename;
@end

@interface ContactRecord : NSObject{
    
    NSString *type;
    NSString *relationship;
    NSString *contact;
    BOOL enableparentapp;
    BOOL primarycontact;
    NSString *parentapplastlogin;
    BOOL enablesms;
    BOOL enablewechat;
    NSString *iso_code;
}

@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *relationship;
@property (strong,nonatomic) NSString *contact;
@property (nonatomic) BOOL enableparentapp;
@property (nonatomic) BOOL primarycontact;
@property (strong,nonatomic) NSString *parentapplastlogin;
@property (nonatomic) BOOL enablesms;
@property (strong,nonatomic) NSString *iso_code;
@property (nonatomic) BOOL enablewechat;

#pragma mark -
#pragma mark Class Methods

-(id)initContactRecordwithtype:(NSString *)ctype relationship:(NSString *)crelationship contact:(NSString *)ccontact enableparentapp:(BOOL)cenableparentapp primarycontact:(BOOL)cprimarycontact parentapplastlogin:(NSString *)cparentapplastlogin enablesms:(BOOL)cenablesms iso_code:(NSString *)ciso_code enablewechat:(BOOL)cenablewechat;

@end


/*
@interface ScheduleDayRecord : NSObject{
    
    NSString *mon;
    NSString *tue;
    NSString *wed;
    NSString *thu;
    NSString *fri;
    NSString *sat;
    NSString *sun;
}

@property (strong,nonatomic) NSString *mon;
@property (strong,nonatomic) NSString *tue;
@property (strong,nonatomic) NSString *wed;
@property (strong,nonatomic) NSString *thu;
@property (strong,nonatomic) NSString *fri;
@property (strong,nonatomic) NSString *sat;
@property (strong,nonatomic) NSString *sun;

#pragma mark -
#pragma mark Class Methods

-(id)initScheduleDayRecordwithmon:(NSString *)cmon tue:(NSString *)ctue wed:(NSString *)cwed thu:(NSString *)cthu fri:(NSString *)cfri sat:(NSString *)csat sun:(NSString *)csun;

@end*/

@interface ScheduleDetailsRecord : NSObject{
    
    NSString *dayofweek;
    NSString *classtime;
    NSString *instructor;
    NSString *classroom;
    NSString *sinstructor;
}

@property (strong,nonatomic) NSString *dayofweek;
@property (strong,nonatomic) NSString *classtime;
@property (strong,nonatomic) NSString *instructor;
@property (strong,nonatomic) NSString *sinstructor;
@property (strong,nonatomic) NSString *classroom;

#pragma mark -
#pragma mark Class Methods

-(id)initScheduleDetailsRecordwithdayofweek:(NSString *)cdayofweek classtime:(NSString *)cclasstime instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom sinstructor:(NSString *)csinstructor;

@end





/*
@interface ScheduleLessonRecord : NSObject{
    
    NSString *date;
    NSString *time;
}

@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSString *time;

#pragma mark -
#pragma mark Class Methods

-(id)initScheduleLessonRecordwithDate:(NSString *)cdate Time:(NSString *)ctime;

@end*/


@interface ScheduleRecord : NSObject{
    
    NSString *schedulekey;
    NSString *name;
    NSString *autorenew;
    NSMutableArray *daytimearray;
    NSString *action;
    NSString *startdate;
    NSString *enddate;
    BOOL makeupschedule;
    BOOL active;
    NSString *type;
    BOOL showintimetableifnoenrollment;
    BOOL onlinetrialschedule;
    NSMutableArray *levelarray;
}

@property (strong,nonatomic) NSString *schedulekey;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *autorenew;
@property (strong,nonatomic) NSMutableArray *daytimearray;
@property (strong,nonatomic) NSString *action;
@property (strong,nonatomic) NSString *startdate;
@property (strong,nonatomic) NSString *enddate;
@property (nonatomic) BOOL makeupschedule;
@property (nonatomic) BOOL active;
@property (strong,nonatomic) NSString *type;
@property (nonatomic) BOOL showintimetableifnoenrollment;
@property (nonatomic) BOOL onlinetrialschedule;
@property (strong,nonatomic) NSMutableArray *levelarray;

#pragma mark -
#pragma mark Class Methods

-(id)initScheduleRecordwithScheduleKey:(NSString *)cschedulekey Name:(NSString *)cname AutoRenew:(NSString *)cautorenew DayTimeArray:(NSMutableArray *)cdaytimearray Action:(NSString *)caction StartDate:(NSString *)cstartdate EndDate:(NSString *)cenddate makeupschedule:(BOOL)cmakeupschedule active:(BOOL)cactive type:(NSString *)ctype showintimetableifnoenrollment:(BOOL)cshowintimetableifnoenrollment onlinetrialschedule:(BOOL)conlinetrialschedule levelarray:(NSMutableArray *)clevelarray;

@end

@interface RenewalLog : NSObject{
    
    NSString *timeconnectionid;
    NSString *subject;
    NSString *studentkey;
    NSString *firstname;
    NSString *lastname;
    NSString *lastclass;
    NSString *renewalresultenglish;
    NSString *renewalresultchinese;
    NSString *newenrollmentkey;
    NSString *oldenrollmentkey;
    NSString *standardnoofclassormonth;
    NSString *enrollmentmode;
    NSString *schedulekey;
    NSString *username;
    NSString *firstclass;
    NSString *levelmain;
    NSString *image;
    NSString *batchcutoffdate;
    NSString *status;
    NSString *lateststartdate;
}

@property (strong,nonatomic) NSString *timeconnectionid;
@property (strong,nonatomic) NSString *subject;
@property (strong,nonatomic) NSString *studentkey;
@property (strong,nonatomic) NSString *firstname;
@property (strong,nonatomic) NSString *lastname;
@property (strong,nonatomic) NSString *lastclass;
@property (strong,nonatomic) NSString *renewalresultenglish;
@property (strong,nonatomic) NSString *renewalresultchinese;
@property (strong,nonatomic) NSString *newenrollmentkey;
@property (strong,nonatomic) NSString *oldenrollmentkey;
@property (strong,nonatomic) NSString *standardnoofclassormonth;
@property (strong,nonatomic) NSString *enrollmentmode;
@property (strong,nonatomic) NSString *schedulekey;
@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) NSString *firstclass;
@property (strong,nonatomic) NSString *levelmain;
@property (strong,nonatomic) NSString *image;
@property (strong,nonatomic) NSString *batchcutoffdate;
@property (strong,nonatomic) NSString *status;
@property (strong,nonatomic) NSString *lateststartdate;

#pragma mark -
#pragma mark Class Methods

-(id)initRenewalLogwithtimeconnectionid:(NSString *)ctimeconnectionid subject:(NSString *)csubject studentkey:(NSString *)cstudentkey firstname:(NSString *)cfirstname lastname:(NSString *)clastname lastclass:(NSString *)clastclass renewalresultenglish:(NSString *)crenewalresultenglish renewalresultchinese:(NSString *)crenewalresultchinese newenrollmentkey:(NSString *)cnewenrollmentkey oldenrollmentkey:(NSString *)coldenrollmentkey standardnoofclassormonth:(NSString *)cstandardnoofclassormonth enrollmentmode:(NSString *)cenrollmentmode schedulekey:(NSString *)cschedulekey username:(NSString *)cusername firstclass:(NSString *)cfirstclass image:(NSString *)cimage levelmain:(NSString *)clevelmain batchcutoffdate:(NSString *)cbatchcutoffdate status:(NSString *)cstatus lateststartdate:(NSString *)clateststartdate;

@end

@interface RenewalGroupLog : NSObject{
    
    NSString *timeconnectionid;
    NSString *username;
    NSString *successfulcount;
    NSString *failcount;
    NSMutableArray *renewallogarray;
    NSString *batchcutoffdate;
    NSString *filtervalue;
}

@property (strong,nonatomic) NSString *timeconnectionid;
@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) NSString *successfulcount;
@property (strong,nonatomic) NSString *failcount;
@property (strong,nonatomic) NSMutableArray *renewallogarray;
@property (strong,nonatomic) NSString *batchcutoffdate;
@property (strong,nonatomic) NSString *filtervalue;

#pragma mark -
#pragma mark Class Methods

-(id)initRenewalGroupLogwithtimeconnectionid:(NSString *)ctimeconnectionid username:(NSString *)cusername successfulcount:(NSString *)csuccesfulcount failcount:(NSString *)cfailcount renewallogarray:(NSMutableArray *)crenewallogarray batchcutoffdate:(NSString *)cbatchcutoffdate filtervalue:(NSString *)cfiltervalue;

@end

@interface ClassPhotoRecord : NSObject{
    
    NSString *centerkey;
    NSString *classphotokey;
    NSString *takenby;
    NSDate *createdatetime;
    NSString *title;
    NSString *tag;
    NSString *favourite;
    NSString *like;
    BOOL hotnews;
    NSString *hn_expiry_date;
    NSMutableArray *filearray;
}
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * classphotokey;
@property (strong,nonatomic) NSString * takenby;
@property (strong,nonatomic) NSDate * createdatetime;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * tag;
@property (strong,nonatomic) NSString * favourite;
@property (strong,nonatomic) NSString * like;
@property (nonatomic) BOOL hotnews;
@property (strong,nonatomic) NSString * hn_expiry_date;
@property (strong,nonatomic) NSMutableArray *filearray;

#pragma mark -
#pragma mark Class Methods

-(id)initClassPhotoRecordwithcenterkey:(NSString *)ccenterkey classphotokey:(NSString *)cclassphotokey takenby:(NSString *)ctakenby createdatetime:(NSDate *)ccreatedatetime title:(NSString *)ctitle tag:(NSString *)ctag favourite:(NSString *)cfavourite like:(NSString *)clike hotnews:(BOOL)chotnews hn_expiry_date:(NSString *)chn_expiry_date filearray:(NSMutableArray *)cfilearray;

@end


@interface LastUpdateRecord : NSObject{
    
    NSString *centerkey;
    NSString *calendar;
    NSString *staff;
    NSString *classroom;
    NSString *languagetitle;
    NSString *subject;
    NSString *product;
    NSString *marketing;
    NSString *centerimage;
    NSString *studentimage;
    NSString *leadimage;
    NSString *classimage;
    NSString *centerrecord;
    NSString *centersettings;
    NSString *userroleandprivilege;
    NSString *student;
    NSString *lead;
    NSString *leavenature;
    NSString *arcode;
    NSString *messagecontact;
    
}
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * calendar;
@property (strong,nonatomic) NSString * staff;
@property (strong,nonatomic) NSString * classroom;
@property (strong,nonatomic) NSString * languagetitle;
@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * product;
@property (strong,nonatomic) NSString * marketing;
@property (strong,nonatomic) NSString * centerimage;
@property (strong,nonatomic) NSString * studentimage;
@property (strong,nonatomic) NSString * leadimage;
@property (strong,nonatomic) NSString * classimage;
@property (strong,nonatomic) NSString * centerrecord;
@property (strong,nonatomic) NSString * centersettings;
@property (strong,nonatomic) NSString * userroleandprivilege;
@property (strong,nonatomic) NSString * student;
@property (strong,nonatomic) NSString * lead;
@property (strong,nonatomic) NSString * leavenature;
@property (strong,nonatomic) NSString * arcode;
@property (strong,nonatomic) NSString * messagecontact;


#pragma mark -
#pragma mark Class Methods

-(id)initLastUpdateRecordwithCenterkey:(NSString *)ccenterkey Calendar:(NSString *)ccalendar Staff:(NSString *)cstaff Classroom:(NSString *)cclassroom LanguageTitle:(NSString *)clanguagetitle Subject:(NSString *)csubject Product:(NSString *)cproduct Marketing:(NSString *)cmarketing Centerimage:(NSString *)ccenterimage StudentImage:(NSString *)cstudentimage LeadImage:(NSString *)cleadimage ClassImage:(NSString *)cclassimage Centerrecord:(NSString *)ccenterrecord Centersettings:(NSString *)ccentersettings Userroleandprivilege:(NSString *)cuserroleandprivilege Student:(NSString *)cstudent Lead:(NSString *)clead LeaveNature:(NSString *)cleavenature ARCode:(NSString *)carcode MessageContact:(NSString *)cmessagecontact;

@end

@interface UserPrivilege : NSObject{
    
    NSString *centerkey;
    NSString *privilegekey;
    NSString *role;
}
@property (strong,nonatomic) NSString *centerkey;
@property (strong,nonatomic) NSString *privilegekey;
@property (strong,nonatomic) NSString *role;

//#pragma mark -
//#pragma mark Class Methods

-(id)initPrivilegewithCenterkey:(NSString *)ccenterkey Privilegekey:(NSString *)cprivilegekey Role:(NSString *)crole;



@end

@interface PrivilegeRecord : NSObject{
    
    NSString *centerkey;
    NSString *usertype;
    NSString *privilegekey;
    BOOL showallothertaskinnotificationview;
    BOOL showallothertaskintaskassignmentview;
    BOOL addsubject;
    BOOL editsubject;
    BOOL addstaff;
    BOOL editstaff;
    BOOL addproduct;
    BOOL editproduct;
    BOOL viewstudentprofile;
    BOOL viewdailyclassschedule;
    BOOL viewclasstimetable;
    BOOL viewclassrenewal;
    BOOL viewpaymentinformation;
    BOOL viewmessagecenter;
    BOOL viewtaskassignment;
    BOOL viewleadprofile;
    BOOL viewassessment;
    BOOL viewcenterinformation;
    BOOL viewsettings;
    BOOL viewchangelog;
    BOOL viewallinstructorclass;
    BOOL viewclassphoto;
    BOOL viewcontactindailyschedule;
    BOOL voidenrollment;
    BOOL voidsales;
    BOOL changesalesproduct;
    BOOL deleteenrollment;
    BOOL deletesales;
    BOOL vieweditsalaryrate;
    BOOL editstudentsubjectlevel;
    BOOL istafftakingattendance;
    BOOL sendmessage;
    BOOL editcenterinformation;
    BOOL editcenterpolicy;
    BOOL biviewmanagerfolder;
    BOOL bistandarddreports;
    BOOL bistandardireports;
    BOOL bistandardsreports;
    BOOL bistandardereports;
    BOOL bistandardlreports;
    BOOL bistandardqreports;
    BOOL showstudentcategorycount;
    BOOL istaffsendstaffmessage;
    BOOL istaffsendstudentmessage;
    BOOL istaffsendleadmessage;
    BOOL overrideextensiontime;
    BOOL istaffsendparentnote;
    BOOL istaffshowstudentcontact;
    BOOL overrideassessmentresponse;
    BOOL istaffextendclass;
    NSString *istaffmakeupmode;
    BOOL istaffclassalert;
    BOOL transferenrollment;
    BOOL closeothertask;
    BOOL deletemessage;
    BOOL withdrawcash;
    BOOL showdailyscheduletotalcount;
    BOOL promotestudentgrade;
    BOOL istaffshowoutstanding;
    BOOL editmakeupquota;
    BOOL enablerequestaction;
    BOOL istaffshowclasslevel;
    BOOL publishinphotocorner;
    BOOL editothersphotocornerpost;
    BOOL istaffshowadditionalstudentinfo;
    BOOL classchangealert;
    BOOL istaffviewalloutboxmessage;
    BOOL istaffedithotnews;
    BOOL istaffviewallstudents;
    BOOL istaffviewcentermessage;
    BOOL receiveparentmessage;
    BOOL sendvideomessage;
    BOOL istaffsendvideomessage;
    BOOL sendvoicemessage;
    BOOL istaffsendvoicemessage;
    BOOL showpaymentreceivedchart;
    BOOL addnewstudent;
    BOOL showstudentpage;
    BOOL istaffshowmystudentpage;
    BOOL addclassroom;
    BOOL editclassroom;
    BOOL addmarketing;
    BOOL editmarketing;
    BOOL addlicense;
    BOOL sendmessagecenterrole;
    BOOL viewsetupsubscription;
    BOOL showenrollmentcountchart;
    BOOL editdiscount;
    BOOL editpaiddate;
    BOOL editcentercalendar;
    BOOL issuepoint;
    BOOL issuecoupon;
    BOOL applycoupon;
    BOOL showwhatsnew;
    BOOL allowdatebackpaiddate;
    BOOL receiveallstudentnotifications;
    BOOL istaffreceiveallstudentnotifications;
    BOOL edituserschedule;
    BOOL editonetimediscount;
    BOOL editenrollmentfee;
    BOOL showcenterstaffpage;
    BOOL showautonotificationsettings;
    BOOL bimgtmsreports;
    BOOL bimgtmdreports;
    BOOL bimgtmpreports;
    BOOL bimgtmareports;
    BOOL bimgtmireports;
    BOOL bimgtmtreports;
    BOOL editlockclassperiod;
    BOOL editlockedclass;
    BOOL showcentercoursepage;
    BOOL showcenterproductpage;
    BOOL showcentermarketingpage;
    BOOL showcenterpolicypage;
    BOOL showcenterclassroompage;
    BOOL editdiscountifpaid;
    BOOL sendbroadcastmessage;
    BOOL istaffsendbroadcastmessage;
    BOOL editbilldate;
    BOOL editenrollmentdate;
    BOOL editclassforexpiredpromotion;
    BOOL editstaffprivilege;
    BOOL editclassforpaidenrollment;
    BOOL edittimetableinstructorcolor;
    BOOL edittimetablesubjectcolor;
    BOOL edittimetableclassroomcolor;
    BOOL editmakeupsettings;
}
@property (strong,nonatomic) NSString *centerkey;
@property (strong,nonatomic) NSString *usertype;
@property (strong,nonatomic) NSString *privilegekey;
@property (nonatomic) BOOL showallothertaskinnotificationview;
@property (nonatomic) BOOL showallothertaskintaskassignmentview;
@property (nonatomic) BOOL addsubject;
@property (nonatomic) BOOL editsubject;
@property (nonatomic) BOOL addstaff;
@property (nonatomic) BOOL editstaff;
@property (nonatomic) BOOL addproduct;
@property (nonatomic) BOOL editproduct;

@property (nonatomic) BOOL viewstudentprofile;
@property (nonatomic) BOOL viewdailyclassschedule;
@property (nonatomic) BOOL viewclasstimetable;
@property (nonatomic) BOOL viewclassrenewal;
@property (nonatomic) BOOL viewpaymentinformation;
@property (nonatomic) BOOL viewmessagecenter;
@property (nonatomic) BOOL viewtaskassignment;
@property (nonatomic) BOOL viewleadprofile;
@property (nonatomic) BOOL viewassessment;
@property (nonatomic) BOOL viewcenterinformation;
@property (nonatomic) BOOL viewsettings;
@property (nonatomic) BOOL viewallinstructorclass;
@property (nonatomic) BOOL viewclassphoto;
@property (nonatomic) BOOL viewcontactindailyschedule;
@property (nonatomic) BOOL voidenrollment;
@property (nonatomic) BOOL voidsales;
@property (nonatomic) BOOL changesalesproduct;
@property (nonatomic) BOOL deleteenrollment;
@property (nonatomic) BOOL deletesales;
@property (nonatomic) BOOL vieweditsalaryrate;
@property (nonatomic) BOOL editstudentsubjectlevel;
@property (nonatomic) BOOL istafftakingattendance;
@property (nonatomic) BOOL sendmessage;
@property (nonatomic) BOOL editcenterinformation;
@property (nonatomic) BOOL editcenterpolicy;
@property (nonatomic) BOOL biviewmanagerfolder;
@property (nonatomic) BOOL showstudentcategorycount;
@property (nonatomic) BOOL istaffsendstaffmessage;
@property (nonatomic) BOOL istaffsendstudentmessage;
@property (nonatomic) BOOL istaffsendleadmessage;
@property (nonatomic) BOOL overrideextensiontime;
@property (nonatomic) BOOL istaffsendparentnote;
@property (nonatomic) BOOL istaffshowstudentcontact;
@property (nonatomic) BOOL overrideassessmentresponse;
@property (nonatomic) BOOL istaffextendclass;
@property (nonatomic) NSString *istaffmakeupmode;
@property (nonatomic) BOOL istaffclassalert;
@property (nonatomic) BOOL transferenrollment;
@property (nonatomic) BOOL closeothertask;
@property (nonatomic) BOOL deletemessage;
@property (nonatomic) BOOL withdrawcash;
@property (nonatomic) BOOL showdailyscheduletotalcount;
@property (nonatomic) BOOL promotestudentgrade;
@property (nonatomic) BOOL istaffshowoutstanding;
@property (nonatomic) BOOL editmakeupquota;
@property (nonatomic) BOOL enablerequestaction;
@property (nonatomic) BOOL istaffshowclasslevel;
@property (nonatomic) BOOL publishinphotocorner;
@property (nonatomic) BOOL editothersphotocornerpost;
@property (nonatomic) BOOL istaffshowadditionalstudentinfo;
@property (nonatomic) BOOL classchangealert;
@property (nonatomic) BOOL istaffviewalloutboxmessage;
@property (nonatomic) BOOL istaffedithotnews;
@property (nonatomic) BOOL istaffviewallstudents;
@property (nonatomic) BOOL istaffviewcentermessage;
@property (nonatomic) BOOL receiveparentmessage;
@property (nonatomic) BOOL sendvideomessage;
@property (nonatomic) BOOL istaffsendvideomessage;
@property (nonatomic) BOOL sendvoicemessage;
@property (nonatomic) BOOL istaffsendvoicemessage;
@property (nonatomic) BOOL showpaymentreceivedchart;
@property (nonatomic) BOOL addnewstudent;
@property (nonatomic) BOOL showstudentpage;
@property (nonatomic) BOOL istaffshowmystudentpage;
@property (nonatomic) BOOL addclassroom;
@property (nonatomic) BOOL editclassroom;
@property (nonatomic) BOOL addmarketing;
@property (nonatomic) BOOL editmarketing;
@property (nonatomic) BOOL addlicense;
@property (nonatomic) BOOL sendmessagecenterrole;
@property (nonatomic) BOOL viewsetupsubscription;
@property (nonatomic) BOOL viewchangelog;
@property (nonatomic) BOOL bistandarddreports;
@property (nonatomic) BOOL bistandardireports;
@property (nonatomic) BOOL bistandardsreports;
@property (nonatomic) BOOL bistandardereports;
@property (nonatomic) BOOL bistandardlreports;
@property (nonatomic) BOOL bistandardqreports;
@property (nonatomic) BOOL showenrollmentcountchart;
@property (nonatomic) BOOL editdiscount;
@property (nonatomic) BOOL editpaiddate;
@property (nonatomic) BOOL editcentercalendar;
@property (nonatomic) BOOL issuepoint;
@property (nonatomic) BOOL issuecoupon;
@property (nonatomic) BOOL applycoupon;
@property (nonatomic) BOOL showwhatsnew;
@property (nonatomic) BOOL allowdatebackpaiddate;
@property (nonatomic) BOOL receiveallstudentnotifications;
@property (nonatomic) BOOL istaffreceiveallstudentnotifications;
@property (nonatomic) BOOL edituserschedule;
@property (nonatomic) BOOL editonetimediscount;
@property (nonatomic) BOOL editenrollmentfee;
@property (nonatomic) BOOL showcenterstaffpage;
@property (nonatomic) BOOL showautonotificationsettings;
@property (nonatomic) BOOL bimgtmsreports;
@property (nonatomic) BOOL bimgtmdreports;
@property (nonatomic) BOOL bimgtmpreports;
@property (nonatomic) BOOL bimgtmareports;
@property (nonatomic) BOOL bimgtmireports;
@property (nonatomic) BOOL bimgtmtreports;
@property (nonatomic) BOOL editlockclassperiod;
@property (nonatomic) BOOL editlockedclass;
@property (nonatomic) BOOL showcentercoursepage;
@property (nonatomic) BOOL showcenterproductpage;
@property (nonatomic) BOOL showcentermarketingpage;
@property (nonatomic) BOOL showcenterpolicypage;
@property (nonatomic) BOOL showcenterclassroompage;
@property (nonatomic) BOOL editdiscountifpaid;
@property (nonatomic) BOOL sendbroadcastmessage;
@property (nonatomic) BOOL istaffsendbroadcastmessage;
@property (nonatomic) BOOL editbilldate;
@property (nonatomic) BOOL editenrollmentdate;
@property (nonatomic) BOOL editclassforexpiredpromotion;
@property (nonatomic) BOOL editstaffprivilege;
@property (nonatomic) BOOL editclassforpaidenrollment;
@property (nonatomic) BOOL edittimetableinstructorcolor;
@property (nonatomic) BOOL edittimetablesubjectcolor;
@property (nonatomic) BOOL edittimetableclassroomcolor;
@property (nonatomic) BOOL editmakeupsettings;
//#pragma mark -
//#pragma mark Class Methods

-(id)initPrivilegeRecordwithCenterkey:(NSString *)ccenterkey UserType:(NSString *)cusertype Privilegekey:(NSString *)cprivilegekey ShowAllOtherTaskInNotificationView:(BOOL)cshowallothertaskinnotificationview ShowAllOtherTaskInTaskAssignmentView:(BOOL)cshowallothertaskintaskassignmentview AddSubject:(BOOL)caddsubject EditSubject:(BOOL)ceditsubject AddStaff:(BOOL)caddstaff EditStaff:(BOOL)ceditstaff AddProduct:(BOOL)caddproduct EditProduct:(BOOL)ceditproduct viewstudentprofile:(BOOL)cviewstudentprofile viewdailyclasschedule:(BOOL)cviewdailyclassschedule viewclasstimetable:(BOOL)cviewclasstimetable viewclassrenewal:(BOOL)cviewclassrenewal viewpaymentinformation:(BOOL)cviewpaymentinformation viewmessagecenter:(BOOL)cviewmessagecenter viewtaskassignment:(BOOL)cviewtaskassignment viewleadprofile:(BOOL)cviewleadprofile viewassessment:(BOOL)cviewassessment viewcenterinformation:(BOOL)cviewcenterinformation viewsettings:(BOOL)cviewsettings viewallinstructorclass:(BOOL)cviewallinstructorclass viewclassphoto:(BOOL)cviewclassphoto viewcontactindailyschedule:(BOOL)cviewcontactindailyschedule voidenrollment:(BOOL)cvoidenrollment voidsales:(BOOL)cvoidsales deleteenrollment:(BOOL)cdeleteenrollment deletesales:(BOOL)cdeletesales vieweditsalaryrate:(BOOL)cvieweditsalaryrate editstudentsubjectlevel:(BOOL)ceditstudentsubjectlevel istafftakingattendance:(BOOL)cistafftakingattendance sendmessage:(BOOL)csendmessage editcenterinformation:(BOOL)ceditcenterinformation editcenterpolicy:(BOOL)ceditcenterpolicy biviewmanagerfolder:(BOOL)cbiviewmanagerfolder showstudentcategorycount:(BOOL)cshowstudentcategorycount istaffsendstaffmessage:(BOOL)cistaffsendstaffmessage istaffsendstudentmessage:(BOOL)cistaffsendstudentmessage istaffsendleadmessage:(BOOL)cistaffsendleadmessage overrideextensiontime:(BOOL)coverrideextensiontime istaffsendparentnote:(BOOL)cistaffsendparentnote istaffshowstudentcontact:(BOOL)cistaffshowstudentcontact overrideassessmentresponse:(BOOL)coverrideassessmentresponse istaffextendclass:(BOOL)cistaffextendclass istaffmakeupmode:(NSString *)cistaffmakeupmode istaffclassalert:(BOOL)cistaffclassalert transferenrollment:(BOOL)ctransferenrollment closeothertask:(BOOL)ccloseothertask deletemessage:(BOOL)cdeletemessage withdrawcash:(BOOL)cwithdrawcash showdailyscheduletotalcount:(BOOL)cshowdailyscheduletotalcount promotestudentgrade:(BOOL)cpromotestudentgrade istaffshowoutstanding:(BOOL)cistaffshowoutstanding editmakeupquota:(BOOL)ceditmakeupquota enablerequestaction:(BOOL)cenablerequestaction istaffshowclasslevel:(BOOL)cistaffshowclasslevel publishinphotocorner:(BOOL)cpublishinphotocorner editothersphotocornerpost:(BOOL)ceditothersphotocornerpost istaffshowadditionalstudentinfo:(BOOL)cistaffshowadditionalstudentinfo classchangealert:(BOOL)cclasschangeclart istaffviewalloutboxmessage:(BOOL)cistaffviewalloutboxmessage istaffedithotnews:(BOOL)cistaffedithotnews istaffviewallstudents:(BOOL)cistaffviewallstudents istaffviewcentermessage:(BOOL)cistaffviewcentermessage receiveparentmessage:(BOOL)creceiveparentmessage sendvideomessage:(BOOL)csendvideomessage istaffsendvideomessage:(BOOL)cistaffsendvideomessage sendvoicemessage:(BOOL)csendvoicemessage istaffsendvoicemessage:(BOOL)cistaffsendvoicemessage showpaymentreceivedchart:(BOOL)cshowpaymentreceivedchart addnewstudent:(BOOL)caddnewstudent showstudentpage:(BOOL)cshowstudentpage istaffshowmystudentpage:(BOOL)cistaffshowmystudentpage addclassroom:(BOOL)caddclassroom editclassroom:(BOOL)ceditclassroom addmarketing:(BOOL)caddmarketing editmarketing:(BOOL)ceditmarketing addlicense:(BOOL)caddlicense sendmessagecenterrole:(BOOL)csendmessagecenterrole viewsetupsubscription:(BOOL)cviewsetupsubscription viewchangelog:(BOOL)cviewchangelog bistandarddreports:(BOOL)cbistandarddreports bistandardireports:(BOOL)cbistandardireports bistandardsreports:(BOOL)cbistandardsreports bistandardereports:(BOOL)cbistandardereports bistandardlreports:(BOOL)cbistandardlreports bistandardqreports:(BOOL)cbistandardqreports  showenrollmentcountchart:(BOOL)cshowenrollmentcountchart editdiscount:(BOOL)ceditdiscount editpaiddate:(BOOL)ceditpaiddate editcentercalendar:(BOOL)ceditcentercalendar issuepoint:(BOOL)cissuepoint issuecoupon:(BOOL)cissuecoupon applycoupon:(BOOL)capplycoupon showwhatsnew:(BOOL)cshowwhatsnew allowdatebackpaiddate:(BOOL)callowdatebackpaiddate receiveallstudentnotifications:(BOOL)creceiveallstudentnotifications istaffreceiveallstudentnotifications:(BOOL)cistaffreceiveallstudentnotifications edituserschedule:(BOOL)cedituserschedule editonetimediscount:(BOOL)ceditonetimediscount editenrollmentfee:(BOOL)ceditenrollmentfee showcenterstaffpage:(BOOL)cshowcenterstaffpage showautonotificationsettings:(BOOL)cshowautonotificationsettings bimgtmsreports:(BOOL)cbimgtmsreports bimgtmdreports:(BOOL)cbimgtmdreports bimgtmpreports:(BOOL)cbimgtmpreports bimgtmareports:(BOOL)cbimgtmareports bimgtmireports:(BOOL)cbimgtmireports editlockclassperiod:(BOOL)ceditlockclassperiod editlockedclass:(BOOL)ceditlockedclass showcentercoursepage:(BOOL)cshowcentercoursepage showcenterclassroompage:(BOOL)cshowcenterclassroompage showcenterproductpage:(BOOL)cshowcenterproductpage showcenterpolicypage:(BOOL)cshowcenterpolicypage showcentermarketingpage:(BOOL)cshowcentermarketingpage bimgtmtreports:(BOOL)cbimgtmtreports editdiscountifpaid:(BOOL)ceditdiscountifpaid sendbroadcastmessage:(BOOL)csendbroadcastmessage istaffsendbroadcastmessage:(BOOL)cistaffsendbroadcastmessage editbilldate:(BOOL)ceditbilldate editenrollmentdate:(BOOL)ceditenrollmentdate editclassforexpiredpromotion:(BOOL)ceditclassforexpiredpromotion editstaffprivilege:(BOOL)ceditstaffprivilege editclassforpaidenrollment:(BOOL)ceditclassforpaidenrollment edittimetableinstructorcolor:(BOOL)cedittimetableinstructorcolor edittimetablesubjectcolor:(BOOL)cedittimetablesubjectcolor edittimetableclassroomcolor:(BOOL)cedittimetableclassroomcolor editmakeupsettings:(BOOL)ceditmakeupsettings changesalesproduct:(BOOL)cchangesalesproduct;
 


@end


@interface ExtendedClassRecord : NSObject
{
    NSString *centerkey;
    NSString *extendkey;
    NSString *fromclasskey;
    NSString *toclasskey;
    NSString *classdate;
    NSString *classtime;
    int extensiontime;
    int extendedminute;
    NSString *schedulekey;
    NSString *subject;
}
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * extendkey;
@property (strong,nonatomic) NSString * fromclasskey;
@property (strong,nonatomic) NSString * toclasskey;
@property (strong,nonatomic) NSString * classdate;
@property (strong,nonatomic) NSString * classtime;
@property (nonatomic) int extensiontime;
@property (nonatomic) int extendedminute;
@property (strong,nonatomic) NSString * schedulekey;
@property (strong,nonatomic) NSString * subject;


#pragma mark -
#pragma mark Class Methods

-(id)initExtendedClassRecordwithCenterkey:(NSString *)ccenterkey Extendkey:(NSString *)cextendkey FromClasskey:(NSString *)cfromclasskey ToClasskey:(NSString *)ctoclasskey Classdate:(NSString *)cclassdate Classtime:(NSString *)cclasstime Extensiontime:(int)cextensiontime Extendedminute:(int)cextendedminute Schedulekey:(NSString *)cschedulekey Subject:(NSString *)csubject;

@end


@interface SortingRecord : NSObject
{
    NSString *item;
    NSString *order;
}
@property (strong,nonatomic) NSString * item;
@property (strong,nonatomic) NSString * order;


#pragma mark -
#pragma mark Class Methods

-(id)initSortingRecordwithItem:(NSString *)citem Order:(NSString *)corder;

@end

@interface SiblingRecord : NSObject
{
    NSString *studentname;
    NSString *studentkey;
    NSString *relationship;
}
@property (strong,nonatomic) NSString * studentname;
@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * relationship;

#pragma mark -
#pragma mark Class Methods

-(id)initSiblingRecordwithStudentname:(NSString *)cstudentname Studentkey:(NSString *)cstudentkey Relationship:(NSString *)crelationship;

@end


@interface ViewHistoryRecord : NSObject
{
    NSString *typekey;
    NSString *name;
    NSString *ID;
    NSString *gender;
}
@property (strong,nonatomic) NSString * typekey;
@property (strong,nonatomic) NSString * name;
@property (strong,nonatomic) NSString * ID;
@property (strong,nonatomic) NSString * gender;

#pragma mark -
#pragma mark Class Methods

-(id)initViewHistoryRecordwithTypekey:(NSString *)ctypekey Name:(NSString *)cname ID:(NSString *)cID Gender:(NSString *)cgender;

@end


@interface ScanHistoryRecord : NSObject
{
    NSString *studentkey;
    NSString *studentname;
    NSString *studentid;
    NSString *image;
    NSString *gender;
    NSString *status;
    BOOL success;
}
@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * studentname;
@property (strong,nonatomic) NSString * studentid;
@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString * gender;
@property (strong,nonatomic) NSString * status;
@property (nonatomic) BOOL success;

#pragma mark -
#pragma mark Class Methods

-(id)initScanHistoryRecordwithStudentkey:(NSString *)cstudentkey StudentName:(NSString *)cstudentname StudentID:(NSString *)cstudentid Image:(NSString *)cimage Gender:(NSString *)cgender Status:(NSString *)cstatus Success:(BOOL)csuccess;

@end



@interface SubjectCategoryRecord : NSObject
{
    NSString *centerkey;
    NSString *scategorykey;
    NSString *englishname;
    NSString *chinesename;
    NSInteger colorcode;
    BOOL bundleforapppayment;
}
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * scategorykey;
@property (strong,nonatomic) NSString * englishname;
@property (strong,nonatomic) NSString * chinesename;
@property (nonatomic) NSInteger colorcode;
@property (nonatomic) BOOL bundleforapppayment;

#pragma mark -
#pragma mark Class Methods

-(id)initSubjectCategoryRecordwithCenterkey:(NSString *)ccenterkey SCategoryKey:(NSString *)cscategorykey Englishname:(NSString *)cenglishname Chinesename:(NSString *)cchinesename colorcode:(NSInteger)ccolorcode bundleforapppayment:(BOOL)cbundleforapppayment;

@end

@interface AssessmentFormRowObject : NSObject
{
    NSString *formitemkey;
    NSString *title;
    NSString *questiontype;
    NSMutableArray *valuearray;
    NSMutableArray *responsearray;
}
@property (strong,nonatomic) NSString * formitemkey;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * questiontype;
@property (strong,nonatomic) NSMutableArray * valuearray;
@property (strong,nonatomic) NSMutableArray * responsearray;

#pragma mark -
#pragma mark Class Methods

-(id)initAssessmentFormRowObjectwithFormItemKey:(NSString *)cformitemkey Title:(NSString *)ctitle QuestionType:(NSString *)cquestiontype ValueArray:(NSMutableArray *)cvaluearray ResponseArray:(NSMutableArray *)cresponsearray;

@end

@interface AssessmentFormSectionObject : NSObject
{
    NSString *title;
    NSMutableArray *questionarray;
}
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSMutableArray * questionarray;

#pragma mark -
#pragma mark Class Methods

-(id)initAssessmentFormSectionObjectwithTitle:(NSString *)ctitle QuestionArray:(NSMutableArray *)cquestinarray;

@end

@interface AssessmentFormListObject : NSObject
{
    NSString *formkey;
    NSString *formname;
    NSString *lastsubmittedtime;
    NSString *submitter;
    NSString *formtype;
    NSMutableArray *subjectarray;
    BOOL active;
    NSMutableArray *gradearray;
    NSString *remarks;
}
@property (strong,nonatomic) NSString * formkey;
@property (strong,nonatomic) NSString * formname;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * lastsubmittedtime;
@property (strong,nonatomic) NSString * submitter;
@property (strong,nonatomic) NSString * formtype;
@property (strong,nonatomic) NSMutableArray *subjectarray;
@property (strong,nonatomic) NSMutableArray *gradearray;
@property (nonatomic) BOOL active;

#pragma mark -
#pragma mark Class Methods

-(id)initAssessmentFormListObjectwithFormKey:(NSString *)cformkey FormName:(NSString *)cformname LastSubmittedTime:(NSString *)clastsubmittedtime Submitter:(NSString *)csubmitter formType:(NSString *)cformtype subjectarray:(NSMutableArray *)csubjectarray active:(BOOL)cactive gradearray:(NSMutableArray *)cgradearray remarks:(NSString *)cremarks;

@end


@interface GroupRecord : NSObject
{
    NSString *groupkey;
    NSString *groupname;
    NSString *description;
    BOOL makeuparrangementnotification;
    BOOL autorenewalfailurenotification;
    BOOL onlineenrollmentnotification;
    BOOL onlinepaymentnotification;
}
@property (strong,nonatomic) NSString * groupkey;
@property (strong,nonatomic) NSString * groupname;
@property (strong,nonatomic) NSString * description;
@property (nonatomic) BOOL makeuparrangementnotification;
@property (nonatomic) BOOL autorenewalfailurenotification;
@property (nonatomic) BOOL onlineenrollmentnotification;
@property (nonatomic) BOOL onlinepaymentnotification;

#pragma mark -
#pragma mark Class Methods

-(id)initGroupRecordwithgroupkey:(NSString *)cgroupkey groupname:(NSString *)cgroupname description:(NSString *)cdescription makeuparrangementnotification:(BOOL)cmakeuparrangementnotification autorenewalfailurenotification:(BOOL)cautorenewalfailurenotification onlineenrollmentnotification:(BOOL)conlineenrollmentnotification onlinepaymentnotification:(BOOL)conlinepaymentnotification;

@end

@interface GroupMemberRecord : NSObject
{
    NSString *groupkey;
    BOOL leader;
}
@property (strong,nonatomic) NSString * groupkey;
@property (nonatomic) BOOL leader;

#pragma mark -
#pragma mark Class Methods

-(id)initGroupMemberRecordwithgroupkey:(NSString *)cgroupkey leader:(BOOL)cleader;

@end



@interface NoOfMonthLesson : NSObject
{
    float totallesson;
    float nooflesson;
}
@property (nonatomic) float totallesson;
@property (nonatomic) float nooflesson;

#pragma mark -
#pragma mark Class Methods

-(id)initNoOfMonthLessonwithtotallesson:(float)ctotallesson nooflesson:(float)cnooflesson;

@end


@interface StudentRequestRecord : NSObject
{
    NSInteger studentrequestkey;
    NSString * centerkey;
    NSString *requesting_category;
    NSInteger requesting_categorykey;
    NSString *request_for_type;
    NSString *request_for_value;
    NSString * request_for_leavenaturelistkey;
    NSString *request_for_value_reason;
    NSDate *requestingdatetime;
    NSString *request_for_instructor;
    NSString *request_for_classroom;
    NSString *request_status;
    NSString *requestor_username;
    NSDate *request_time;
    NSString *actionby;
    NSDate *actiontime;
    NSString *studentfullname;
    NSString *subjectfullname;
    NSString *actionbyfullname;
    ClassRecord *classrecord;
    BOOL count_quota;
    NSString *request_from_date;
    NSString *request_from_time;
    NSString *request_from_value;
    NSString *request_from_instructor;
    NSString *request_from_classroom;
    
}
@property (nonatomic) NSInteger studentrequestkey;
@property (nonatomic,strong) NSString * centerkey;
@property (strong,nonatomic) NSString *requesting_category;
@property (nonatomic) NSInteger requesting_categorykey;
@property (strong,nonatomic) NSString *request_for_type;
@property (strong,nonatomic) NSString *request_for_value;
@property (nonatomic,strong) NSString * request_for_leavenaturelistkey;
@property (strong,nonatomic) NSString *request_for_value_reason;
@property (nonatomic) NSDate *requestingdatetime;
@property (strong,nonatomic) NSString *request_for_instructor;
@property (strong,nonatomic) NSString *request_for_classroom;
@property (strong,nonatomic) NSString *request_status;
@property (strong,nonatomic) NSString *requestor_username;
@property (nonatomic) NSDate *request_time;
@property (strong,nonatomic) NSString *actionby;
@property (nonatomic) NSDate *actiontime;
@property (strong,nonatomic) NSString *studentfullname;
@property (strong,nonatomic) NSString *subjectfullname;
@property (strong,nonatomic) NSString *actionbyfullname;
@property (strong,nonatomic) ClassRecord *classrecord;
@property (nonatomic) BOOL count_quota;
@property (strong,nonatomic) NSString *request_from_date;
@property (strong,nonatomic) NSString *request_from_time;
@property (strong,nonatomic) NSString *request_from_value;
@property (strong,nonatomic) NSString *request_from_instructor;
@property (strong,nonatomic) NSString *request_from_classroom;

#pragma mark -
#pragma mark Class Methods

-(id)initStudentRequestRecordWithStudentRequestKey:(NSInteger)cstudentrequestkey CenterKey:(NSString *)ccenterkey requesting_category:(NSString *)crequesting_category requesting_categorykey:(NSInteger)crequesting_categorykey request_for_type:(NSString *)crequest_for_type request_for_value:(NSString *)crequest_for_value request_for_leavenaturelistkey:(NSString *)crequest_for_leavenaturelistkey request_for_value_reason:(NSString *)crequest_for_value_reason requestingdatetime:(NSDate *)crequestingdatetime request_status:(NSString *)crequest_status requestor_username:(NSString *)crequestor_username request_time:(NSDate *)crequest_time actionby:(NSString *)cactionby actiontime:(NSDate*)cactiontime studentfullname:(NSString *)cstudentfullname subjectfullname:(NSString *)csubjectfullname actionbyfullname:(NSString *)cactionbyfullname classrecord:(ClassRecord *)cclassrecord request_for_instructor:(NSString *)crequest_for_instructor request_for_classroom:(NSString *)crequest_for_classroom count_quota:(BOOL)ccount_quota request_from_date:(NSString *)crequest_from_date request_from_time:(NSString *)crequest_from_time request_from_value:(NSString *)crequest_from_value request_from_instructor:(NSString *)crequest_from_instructor request_from_classroom:(NSString *)crequest_from_classroom;

@end

@interface LeaveNatureRecord : NSObject{
    
    NSString * leavenaturelistkey;
    NSString * centerkey;
    NSString * nature_desc_english;
    NSString * nature_desc_chinese;
    BOOL is_student_request;
    NSString * remarks;
    NSString * listorder;
    NSMutableDictionary *configdict;
    
}

@property (nonatomic,strong) NSString * leavenaturelistkey;
@property (nonatomic,strong) NSString * centerkey;
@property (strong,nonatomic) NSString * nature_desc_english;
@property (strong,nonatomic) NSString * nature_desc_chinese;
@property (nonatomic) BOOL is_student_request;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * listorder;
@property (strong,nonatomic) NSMutableDictionary * configdict;

#pragma mark -
#pragma mark Class Methods

-(id)initLeaveNatureRecordWithLeaveNatureListKey:(NSString *)cleavenaturelistkey centerKey:(NSString *)ccenterkey nature_desc_english:(NSString *)cnature_desc_english nature_desc_chinese:(NSString *)cnature_desc_chinese is_student_request:(BOOL)cis_student_request remarks:(NSString *)cremarks listOrder:(NSString *)clistorder configDict:(NSMutableDictionary *)cconfigdict;

@end

@interface LeaveNatureConfig : NSObject{
    
    NSString * leavenatureconfigkey;
    NSString * leavenaturelistkey;
    NSString * attendance;
    BOOL count_quota;
    BOOL default_nature_for_student;
    BOOL default_nature_for_staff;
    BOOL require_approval;
    
}

@property (nonatomic,strong) NSString * leavenatureconfigkey;
@property (nonatomic,strong) NSString * leavenaturelistkey;
@property (nonatomic,strong) NSString * attendance;
@property (nonatomic) BOOL count_quota;
@property (nonatomic) BOOL default_nature_for_student;
@property (nonatomic) BOOL default_nature_for_staff;
@property (nonatomic) BOOL require_approval;

#pragma mark -
#pragma mark Class Methods

-(id)initLeaveNatureConfigWithLeaveNatureConfigKey:(NSString *)cleavenatureconfigkey leaveNatureLeaveKey:(NSString *)cleavenaturelistkey attendance:(NSString *)cattendance count_quota:(BOOL)ccount_quota default_nature_for_student:(BOOL)cdefault_nature_for_student default_nature_for_staff:(BOOL)cdefault_nature_for_staff require_approval:(BOOL)crequire_approval;

@end

@interface LessonRecord2 : NSObject{
    
    NSString *datetime;
    NSString *instructor;
    NSString *classroom;
    NSString *level;
    NSString *sinstructor;
}

@property (strong,nonatomic) NSString *datetime;
@property (strong,nonatomic) NSString *instructor;
@property (strong,nonatomic) NSString *sinstructor;
@property (strong,nonatomic) NSString *classroom;
@property (strong,nonatomic) NSString *level;

#pragma mark -
#pragma mark Class Methods

-(id)initLessonRecord2withdatetime:(NSString *)cdatetime instructor:(NSString *)cinstructor classroom:(NSString *)cclassroom level:(NSString *)clevel sinstructor:(NSString *)csinstructor;

@end

@interface ARCodeRecord : NSObject{
    
    NSString *centerkey;
    NSString *arckey;
    NSString *arcode;
}

@property (strong,nonatomic) NSString *centerkey;
@property (strong,nonatomic) NSString *arckey;
@property (strong,nonatomic) NSString *arcode;

#pragma mark -
#pragma mark Class Methods

-(id)initARCodeRecordwitharckey:(NSString *)carckey centerkey:(NSString *)ccenterkey arcode:(NSString *)carcode;

@end

@interface ClassKeys : NSObject{
    
    NSString *enrollmentkey;
    NSString *classkey;
}

@property (strong,nonatomic) NSString *enrollmentkey;
@property (strong,nonatomic) NSString *classkey;

#pragma mark -
#pragma mark Class Methods

-(id)initClassKeysWithEnrollmentkey:(NSString *)cenrollmentkey Classkey:(NSString *)cclasskey;

@end

@interface AvailabilityRecord : NSObject{
    
    NSString *date;
    NSString *starttime;
    NSString *endtime;
}

@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSString *starttime;
@property (strong,nonatomic) NSString *endtime;

#pragma mark -
#pragma mark Class Methods

-(id)initAvailabilityRecordWithDate:(NSString *)cdate StartTime:(NSString *)cstarttime EndTime:(NSString *)cendtime;

@end

@interface InvoiceLogRecord : NSObject{
    
    NSString *invoicelogkey;
    NSString *invoicenumber;
    NSDate *createtime;
    NSString *staff;
    float totalamount;
    float totalpaid;
    NSMutableArray *itemarray;
}

@property (strong,nonatomic) NSString *invoicelogkey;
@property (strong,nonatomic) NSDate *createtime;
@property (strong,nonatomic) NSString *invoicenumber;
@property (strong,nonatomic) NSString *staff;
@property (nonatomic) float totalamount;
@property (nonatomic) float totalpaid;
@property (strong,nonatomic) NSMutableArray *itemarray;

#pragma mark -
#pragma mark Class Methods

-(id)initInvoiceLogRecordWithInvoiceLogKey:(NSString *)cinvoicelogkey InvoiceNumber:(NSString *)cinvoicenumber CreateTime:(NSDate *)ccreatetime Staff:(NSString *)cstaff TotalAmount:(float)ctotalamount TotalPaid:(float)ctotalpaid ItemArray:(NSMutableArray *)citemarray;

@end

@interface InvoiceLogItem : NSObject{
    
    NSString *studentkey;
    NSString *type;
    NSString *typekey;
    NSString *itemcode;
    float amount;
    float paid;
    NSString *studentfullname;
    NSString *itemdescription;
    NSString *lastpaymentkey;
}

@property (strong,nonatomic) NSString *studentkey;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *typekey;
@property (strong,nonatomic) NSString *itemcode;
@property (nonatomic) float amount;
@property (nonatomic) float paid;
@property (strong,nonatomic) NSString *studentfullname;
@property (strong,nonatomic) NSString *itemdescription;
@property (strong,nonatomic) NSString *lastpaymentkey;

#pragma mark -
#pragma mark Class Methods

-(id)initInvoiceLogItemWithStudentKey:(NSString *)cstudentkey Type:(NSString *)ctype TypeKey:(NSString *)ctypekey ItemCode:(NSString *)citemcode Amount:(float)camount Paid:(float)cpaid studentfullname:(NSString *)cstudentfullname itemdescription:(NSString *)citemdescription lastpaymentkey:(NSString *)clastpaymentkey;

@end

@interface SlidePhotoRecord : NSObject{
    
    NSString *centerkey;
    NSString *typekey;
    NSString *type;
    NSString *filename;
    NSString *title;
    NSString *postdate;
    NSString *width;
    NSString *height;
    NSString *hn_expiry_date;
    BOOL editable;
    NSString *filetype;
    NSString *thumbnailurl;
    NSString *fileurl;
}
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * typekey;
@property (strong,nonatomic) NSString * type;
@property (strong,nonatomic) NSString * filename;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * postdate;
@property (strong,nonatomic) NSString * width;
@property (strong,nonatomic) NSString * height;
@property (strong,nonatomic) NSString * hn_expiry_date;
@property (nonatomic) BOOL editable;
@property (strong,nonatomic) NSString * filetype;
@property (strong,nonatomic) NSString * thumbnailurl;
@property (strong,nonatomic) NSString * fileurl;


#pragma mark -
#pragma mark Class Methods

-(id)initSlidePhotoRecordwithcenterkey:(NSString *)ccenterkey type:(NSString *)ctype typekey:(NSString *)ctypekey filename:(NSString *)cfilename title:(NSString *)ctitle postdate:(NSString *)cpostdate width:(NSString *)cwidth height:(NSString *)cheight hn_expiry_date:(NSString *)chn_expiry_date editable:(BOOL)ceditable filetype:(NSString *)cfiletype thumbnailurl:(NSString *)cthumbnailurl fileurl:(NSString *)cfileurl;

@end


@interface PhotoCornerFileRecord : NSObject{
    NSString *centerkey;
    NSString *photocornerfilekey;
    NSString *fileurl;
    UIImageView *imageview;
    CGFloat width;
    CGFloat height;
    NSURL *internalurl;
    NSString *filetype;
    NSString *filename;
    NSString *thumbnailurl;
    NSString *action;
    NSString *downloadfiletype;
    NSString *title;
}
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * photocornerfilekey;
@property (strong,nonatomic) NSString * fileurl;
@property (strong,nonatomic) UIImageView * imageview;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (strong,nonatomic) NSString * filetype;
@property (strong,nonatomic) NSURL *internalurl;
@property (strong,nonatomic) NSString *filename;
@property (strong,nonatomic) NSString *thumbnailurl;
@property (strong,nonatomic) NSString * action;
@property (strong,nonatomic) NSString * downloadfiletype;
@property (strong,nonatomic) NSString * title;

-(id)initPhotoCornerFileRecordWithCenterKey:(NSString *)scenterkey PhotoCornerFileKey:(NSString *)sphotocornerfilekey FileURL:(NSString *)sfileurl ImageView:(UIImageView *)simageview Width:(CGFloat)swidth Height:(CGFloat)sheight FileType:(NSString *)sfiletype InternalURL:(NSURL *)sinternalurl FileName:(NSString *)sfilename ThumbnailURL:(NSString *)sthumbnailurl Action:(NSString *)saction DownloadFileType:(NSString *)sdownloadfiletype title:(NSString *)stitle;


@end

@interface FullScreenFileRecord : NSObject{
    NSString *centerkey;
    NSString *typekey;
    NSString *fileurl;
    UIImageView *imageview;
    CGFloat width;
    CGFloat height;
    NSURL *internalurl;
    NSString *filetype;
    NSString *filename;
    NSString *thumbnailurl;
    NSString *action;
    NSString *downloadfiletype;
    NSString *title;
}
@property (strong,nonatomic) NSString * centerkey;
@property (strong,nonatomic) NSString * typekey;
@property (strong,nonatomic) NSString * fileurl;
@property (strong,nonatomic) UIImageView * imageview;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (strong,nonatomic) NSString * filetype;
@property (strong,nonatomic) NSURL *internalurl;
@property (strong,nonatomic) NSString *filename;
@property (strong,nonatomic) NSString *thumbnailurl;
@property (strong,nonatomic) NSString * action;
@property (strong,nonatomic) NSString * downloadfiletype;
@property (strong,nonatomic) NSString * title;

-(id)initFullScreenFileRecordWithCenterkey:(NSString *)scenterkey TypeKey:(NSString *)stypekey FileURL:(NSString *)sfileurl ImageView:(UIImageView *)simageview Width:(CGFloat)swidth Height:(CGFloat)sheight FileType:(NSString *)sfiletype InternalURL:(NSURL *)sinternalurl FileName:(NSString *)sfilename ThumbnailURL:(NSString *)sthumbnailurl Action:(NSString *)saction DownloadFileType:(NSString *)sdownloadfiletype Title:(NSString *)stitle;


@end


@interface CountryCodeRecord : NSObject{
    
    NSString *country_name;
    NSString *iso_code;
    NSString *country_code;
    NSString *countrycodekey;
    
}
@property (strong,nonatomic) NSString * countrycodekey;
@property (strong,nonatomic) NSString * country_code;
@property (strong,nonatomic) NSString * country_name;
@property (strong,nonatomic) NSString * iso_code;


#pragma mark -
#pragma mark Class Methods

-(id)initCountryCodeRecordwithcountrycodekey:(NSString *)ccountrycodekey country_code:(NSString *)ccountry_code country_name:(NSString *)ccountry_name iso_code:(NSString *)ciso_code;

@end

@interface PaymentReceivedDetailsRecord : NSObject{
    
    NSString *paymentkey;
    NSString *paiddate;
    NSString *studentkey;
    NSString *paymenttype;
    NSString *subject;
    NSString *noofclass;
    NSString *product;
    NSString *quantity;
    NSString *paymentremarks;
    NSString *receiptremarks;
    NSString *remarks;
    NSString *staffname;
    NSString *paidmethod;
    NSString *paidamount;
    NSString *studentfullname;
    NSString *itemdescription;
    NSString *paymenttypekey;
    
}
@property (strong,nonatomic) NSString * paymentkey;
@property (strong,nonatomic) NSString * paiddate;
@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * paymenttype;
@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * noofclass;
@property (strong,nonatomic) NSString * product;
@property (strong,nonatomic) NSString * quantity;
@property (strong,nonatomic) NSString * paymentremarks;
@property (strong,nonatomic) NSString * receiptremarks;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * staffname;
@property (strong,nonatomic) NSString * paidmethod;
@property (strong,nonatomic) NSString * paidamount;
@property (strong,nonatomic) NSString * studentfullname;
@property (strong,nonatomic) NSString * itemdescription;
@property (strong,nonatomic) NSString * paymenttypekey;


#pragma mark -
#pragma mark Class Methods

-(id)initPaymentReceivedDetailsRecordwithpaymentkey:(NSString *)cpaymentkey paiddate:(NSString *)cpaiddate studentkey:(NSString *)cstudentkey paymenttype:(NSString *)cpaymenttype subject:(NSString *)csubject noofclass:(NSString *)cnoofclass product:(NSString *)cproduct quantity:(NSString *)cquantity paymentremarks:(NSString *)cpaymentremarks receiptremarks:(NSString *)creceiptremarks remarks:(NSString *)cremarks staffname:(NSString *)cstaffname paidmethod:(NSString *)cpaidmethod paidamount:(NSString *)cpaidamount studentfullname:(NSString *)cstudentfullname itemdescription:(NSString *)citemdescription paymenttypekey:(NSString *)cpaymenttypekey;

@end

@interface PaymentReceivedRecord : NSObject{
    
    NSString *paiddate;
    NSMutableArray *paymentrecords;
    NSMutableDictionary *paiddict;
    
}
@property (strong,nonatomic) NSString * paiddate;
@property (strong,nonatomic) NSMutableArray * paymentrecords;
@property (strong,nonatomic) NSMutableDictionary * paiddict;


#pragma mark -
#pragma mark Class Methods

-(id)initPaymentReceivedRecordwithpaiddate:(NSString *)cpaiddate paymentrecords:(NSMutableArray *)cpaymentrecords paiddict:(NSMutableDictionary *)cpaiddict;

@end

@interface AutoNotificationSettingsRecord : NSObject{
    
    NSString *ansettingkey;
    NSString *message_type;
    NSString *schedule_time;
    NSString *day_before_event;
    NSString *repeat_day;
    NSString *channel;
    BOOL enable;
    NSString *message_en;
    NSString *message_zh;
    BOOL paymentreminder;
}
@property (strong,nonatomic) NSString * ansettingkey;
@property (strong,nonatomic) NSString * message_type;
@property (strong,nonatomic) NSString * schedule_time;
@property (strong,nonatomic) NSString * day_before_event;
@property (strong,nonatomic) NSString * repeat_day;
@property (strong,nonatomic) NSString * channel;
@property (strong,nonatomic) NSString * message_en;
@property (strong,nonatomic) NSString * message_zh;
@property (nonatomic) BOOL enable;
@property (nonatomic) BOOL paymentreminder;


#pragma mark -
#pragma mark Class Methods

-(id)initAutoNotificationSettingsRecordwithansettingkey:(NSString *)cansettingkey message_type:(NSString *)cmessage_type schedule_time:(NSString *)cschedule_time day_before_event:(NSString *)cday_before_event repeat_day:(NSString *)crepeat_day channel:(NSString *)cchannel message_en:(NSString *)cmessage_en message_zh:(NSString *)cmessage_zh enable:(BOOL)cenable paymentreminder:(BOOL)cpaymentreminder;

@end

@interface WhatsNewRecord : NSObject{
    
    NSString *version;
    NSString *title;
    NSString *description;
    NSString *imagefile;
    NSString *imagewidth;
    NSString *imageheight;
    NSString *videourl;
}
@property (strong,nonatomic) NSString * version;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * description;
@property (strong,nonatomic) NSString * imagefile;
@property (strong,nonatomic) NSString * imagewidth;
@property (strong,nonatomic) NSString * imageheight;
@property (strong,nonatomic) NSString * videourl;


#pragma mark -
#pragma mark Class Methods

-(id)initWhatsnewRecordwithversion:(NSString *)cversion title:(NSString *)ctitle description:(NSString *)cdescription imagefile:(NSString *)cimagefile imagewidth:(NSString *)cimagewidth imageheight:(NSString *)cimageheight videourl:(NSString *)cvideourl;

@end

@interface MultiCoordinate : NSObject{
    
    NSInteger x;
    NSInteger y;
    NSInteger z;
}
@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;
@property (nonatomic) NSInteger z;


#pragma mark -
#pragma mark Class Methods

-(id)initMultiCoordinatewithx:(NSInteger)cx y:(NSInteger)cy z:(NSInteger)cz;

@end

@interface TrainingCategory : NSObject{
    
    NSString * category;
    NSMutableArray *itemrecords;
}
@property (nonatomic,strong) NSString * category;
@property (nonatomic,strong) NSMutableArray *itemrecords;


#pragma mark -
#pragma mark Class Methods

-(id)initTrainingCategorywithCategory:(NSString *)ccategory itemrecords:(NSMutableArray *)citemrecords;

@end

@interface TrainingItem : NSObject{
    
    NSString * title;
    NSString * fileurl;
    NSString * filetype;
}
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * fileurl;
@property (nonatomic,strong) NSString * filetype;


#pragma mark -
#pragma mark Class Methods

-(id)initTrainingItemwithTitle:(NSString *)ctitle fileurl:(NSString *)cfileurl filetype:(NSString *)cfiletype;

@end

@interface ChangeLogRecord : NSObject{
    
    NSString *date;
    NSString *username;
    NSString *studentkey;
    NSString *type;
    NSString *action;
    NSString *change;
    NSString *subject;
    NSString *product;
    NSString *enrollmentkey;
    NSString *saleskey;
    NSString *classkey;
    NSString *subtype;
    NSString *subtypekey;
    NSString *useractivity;
    NSString *apiaction;
}
@property (strong,nonatomic) NSString * date;
@property (strong,nonatomic) NSString * username;
@property (strong,nonatomic) NSString * studentkey;
@property (strong,nonatomic) NSString * type;
@property (strong,nonatomic) NSString * action;
@property (strong,nonatomic) NSString * change;
@property (strong,nonatomic) NSString * subject;
@property (strong,nonatomic) NSString * product;
@property (strong,nonatomic) NSString * enrollmentkey;
@property (strong,nonatomic) NSString * saleskey;
@property (strong,nonatomic) NSString * classkey;
@property (strong,nonatomic) NSString *subtype;
@property (strong,nonatomic) NSString *subtypekey;
@property (strong,nonatomic) NSString *useractivity;
@property (strong,nonatomic) NSString *apiaction;

#pragma mark -
#pragma mark Class Methods

-(id)initChangeLogRecordWithDate:(NSString *)cdate username:(NSString *)cusername studentkey:(NSString *)cstudentkey type:(NSString *)ctype action:(NSString *)caction change:(NSString *)cchange subject:(NSString *)csubject product:(NSString *)cproduct enrollmentkey:(NSString *)cenrollmentkey saleskey:(NSString *)csaleskey classkey:(NSString *)cclasskey subtype:(NSString *)csubtype subtypekey:(NSString *)csubtypekey useractivity:(NSString *)cuseractivity apiaction:(NSString *)capiaction;

@end

@interface PointRecord : NSObject{
    NSString *pointkey;
    NSString *issuedatetime;
    NSString *type;
    NSString *subtype;
    NSString *point;
    NSString *expirydate;
    NSString *remarks;
    NSString *unusedpoint;
}

@property (strong,nonatomic) NSString * pointkey;
@property (strong,nonatomic) NSString * issuedatetime;
@property (strong,nonatomic) NSString * type;
@property (strong,nonatomic) NSString * subtype;
@property (strong,nonatomic) NSString * point;
@property (strong,nonatomic) NSString * expirydate;
@property (strong,nonatomic) NSString * remarks;
@property (strong,nonatomic) NSString * unusedpoint;

#pragma mark -
#pragma mark Class Methods

-(id)initPointRecordWithpointkey:(NSString *)cpointkey issuedatetime:(NSString *)cissuedatetime type:(NSString *)ctype subtype:(NSString *)csubtype point:(NSString *)cpoint expirydate:(NSString *)cexpirydate remarks:(NSString *)cremarks unusedpoint:(NSString *)cunusedpoint;

@end

@interface MembershipTierRecord : NSObject{
    
    NSString *tierkey;
    NSString *title;
    NSString *title_chinese;
    NSString *requirement;
    NSString *pointmultiplier;
    NSString *birthdaypoint;
    NSString *image;
    NSString *totalspending;
}
@property (strong,nonatomic) NSString * tierkey;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * title_chinese;
@property (strong,nonatomic) NSString * requirement;
@property (strong,nonatomic) NSString * pointmultiplier;
@property (strong,nonatomic) NSString * birthdaypoint;
@property (strong,nonatomic) NSString * image;
@property (strong,nonatomic) NSString * totalspending;


#pragma mark -
#pragma mark Class Methods

-(id)initMembershipTierRecordRecordwithtierkey:(NSString *)ctierkey title:(NSString *)ctitle title_chinese:(NSString *)ctitle_chinese requirement:(NSString *)crequirement pointmultiplier:(NSString *)cpointmulitplier birthdaypoint:(NSString *)cbirthdaypoint image:(NSString *)cimage totalspending:(NSString *)ctotalspending;

@end

@interface ColorScheme : NSObject{
    
    NSString * colorschemekey;
    UIColor * main_color;
}
@property (nonatomic,strong) NSString * colorschemekey;
@property (nonatomic,strong) UIColor * main_color;


#pragma mark -
#pragma mark Class Methods

-(id)initColorSchemeWithColorSchemeKey:(NSString *)ccolorschemekey colorScheme:(UIColor *)cmain_color;

@end

@interface GlobalVariables : NSObject{
    NSString *primaryserverpath;
    NSString *secondaryserverpath;
    NSString *serverpath;
    NSString *generalphpfilename;
    NSString *generalphpfullpath;
    NSString *mediaDomain;
    NSString *activeserver;
    NSString *classdate;
    NSString *classtime;
    NSString *subject;
    NSString *instructor;
    NSString *reloadcenterdata;
    NSString *appbecomeactiveaction;
    NSString *username;
    NSString *password;
    NSString *lastlogin;
    NSString *lastlogout;
    NSString *deviceToken;
    NSString *deviceidentifier;
    NSString *userdevicekey;
    CenterRecord *centerrecord;
    NSMutableArray *centersettingsarray;
    GlobalSettings *globalsettings;
    NSMutableArray *userprivilegearray;
    NSString *lastviewcontroller;
    NSString *newlogin;
    NSMutableArray *centerdayofweekarray;
    DocumentFolder *documentfolder;
    NSString *imagelastupdatetime;
    NSString *language;
    NSMutableDictionary *languagetitledictionary;
    NSMutableDictionary *languagepackdictionary;
    BOOL reloadleftmenu;
    NSMutableDictionary *subjectlistarray;
    NSMutableDictionary *productlistarray;
    NSMutableDictionary *stafflistarray;
    NSMutableDictionary *classroomlistarray;
    NSMutableDictionary *leavenaturearray;
    NSMutableDictionary *arcodelistarray;
    NSMutableDictionary *countrycodearray;
    BOOL backfromappstore;
    NSString *leftmenuindex;
    NSMutableDictionary *CenterDict;
    NSMutableDictionary *lastupdatedict;
    NSString *rawusername;
    NSMutableDictionary *marketinglistarray;
    NSMutableArray *subjectcategoryarray;
    NSMutableArray *privilegearray;
    NSMutableDictionary *studentlistarray;
    NSMutableDictionary *leadlistarray;
    //NSMutableArray *studentnamedisplayorder;
    //NSMutableArray *leadnamedisplayorder;
    sqlite3 *isdb;
    UIView *loadingindicatorview;
    NSMutableDictionary *centerdaydictionary;
    ScheduleRecord *addhocschedulerecord;
    AVAudioPlayer *audioplayer;

    UIImage *boyimage;
    UIImage *girlimage;
    NSArray *colorcodearray;
    NSString *firstredirectscreen;
    UIImageView *unreadmessagecountview;
    NSDate *lastgetunreadmessagecountdatetime;
    NSInteger unreadmessagecount;
    NSArray *contactrelationshiparray;
    NSMutableDictionary *receiptlanguagetitledictionary;
    NSMutableDictionary *messagecontactlist;
    MessageContactRecord *selectedmessagecontact;
    NSMutableArray *messageArray;
    NSMutableArray *filteredMessageArray;
    MessageContactRecord *messagecontactrecord;
    UIImageView *pendingrequestcountview;
    NSInteger pendingrequestcount;
    NSString *passwordexpirydate;
    NSString *passwordexpirylastshowndate;
    long long lastunixtimestampreceived;
    NSDate *lastunixtimestampreceivedtime;
}

@property (strong,nonatomic) NSString *primaryserverpath;
@property (strong,nonatomic) NSString *secondaryserverpath;
@property (strong,nonatomic) NSString *serverpath;
@property (strong,nonatomic) NSString *generalphpfilename;
@property (strong,nonatomic) NSString *generalphpfullpath;
@property (strong,nonatomic) NSString *mediaDomain;
@property (strong,nonatomic) NSString *activeserver;
@property (strong,nonatomic) NSString *classdate;
@property (strong,nonatomic) NSString *classtime;
@property (strong,nonatomic) NSString *subject;
@property (strong,nonatomic) NSString *instructor;
@property (strong,nonatomic) NSString *reloadcenterdata;
@property (strong,nonatomic) NSString *username;
@property (strong,nonatomic) NSString *password;
@property (strong,nonatomic) NSString *lastlogin;
@property (strong,nonatomic) NSString *lastlogout;
@property (strong,nonatomic) NSString *deviceToken;
@property (strong,nonatomic) NSString *deviceidentifier;
@property (strong,nonatomic) NSString *userdevicekey;
@property (strong,nonatomic) CenterRecord *centerrecord;
@property (strong,nonatomic) NSMutableArray *centersettingsarray;
@property (strong,nonatomic) GlobalSettings *globalsettings;
@property (strong,nonatomic) NSMutableArray *userprivilegearray;
@property (strong,nonatomic) NSMutableArray *privilegearray;
@property (strong,nonatomic) NSString *lastviewcontroller;
@property (strong,nonatomic) NSString *newlogin;
@property (strong,nonatomic) NSMutableArray *centerdayofweekarray;
@property (strong,nonatomic) DocumentFolder *documentfolder;
@property (strong,nonatomic) NSString *language;
@property (strong,nonatomic) NSMutableDictionary *languagetitledictionary;
@property (strong,nonatomic) NSMutableDictionary *languagepackdictionary;
@property (nonatomic) BOOL reloadleftmenu;
@property (strong,nonatomic) NSMutableDictionary *subjectlistarray;
@property (strong,nonatomic) NSMutableDictionary *productlistarray;
@property (strong,nonatomic) NSMutableDictionary *stafflistarray;
@property (strong,nonatomic) NSMutableDictionary *classroomlistarray;
@property (strong,nonatomic) NSMutableDictionary *leavenaturearray;
@property (strong,nonatomic) NSMutableDictionary *arcodelistarray;
@property (strong,nonatomic) NSMutableDictionary *countrycodearray;
@property (nonatomic) BOOL backfromappstore;
@property (strong,nonatomic) NSString *leftmenuindex;
@property (strong,nonatomic) NSMutableDictionary *CenterDict;
@property (strong,nonatomic) NSMutableDictionary *lastupdatedict;
@property (strong,nonatomic) NSString *rawusername;
@property (strong,nonatomic) NSMutableDictionary *marketinglistarray;
@property (strong,nonatomic) NSString *appbecomeactiveaction;
@property (strong,nonatomic) NSMutableArray *subjectcategoryarray;
@property (strong,nonatomic) NSMutableDictionary *studentlistarray;
@property (strong,nonatomic) NSMutableDictionary *leadlistarray;
//@property (strong,nonatomic) NSMutableArray *studentnamedisplayorder;
//@property (strong,nonatomic) NSMutableArray *leadnamedisplayorder;
@property (nonatomic) sqlite3 *isdb;
@property (strong,nonatomic) UIView *loadingindicatorview;
@property (strong,nonatomic) NSMutableDictionary *centerdaydictionary;
@property (strong,nonatomic) ScheduleRecord *addhocschedulerecord;
@property (strong,nonatomic) AVAudioPlayer *audioplayer;

@property (strong,nonatomic) UIImage *boyimage;
@property (strong,nonatomic) UIImage *girlimage;
@property (strong,nonatomic) NSArray *colorcodearray;
@property (strong,nonatomic) NSString *firstredirectscreen;
@property (strong,nonatomic) UIImageView *unreadmessagecountview;
@property (nonatomic) NSDate *lastgetunreadmessagecountdatetime;
@property (nonatomic) NSInteger unreadmessagecount;
@property (strong,nonatomic) NSArray *contactrelationshiparray;
@property (strong,nonatomic) NSMutableDictionary *documentfolderdict;
@property (strong,nonatomic) NSMutableDictionary *messagecontactlist;
@property (strong,nonatomic) MessageContactRecord *selectedmessagecontact;
@property (strong,nonatomic) NSMutableArray *messageArray;
@property (strong,nonatomic) NSMutableArray *filteredMessageArray;
@property (strong,nonatomic) MessageContactRecord *messagecontactrecord;
@property (nonatomic) NSInteger pendingrequestcount;
@property (strong,nonatomic) UIImageView *pendingrequestcountview;
@property (strong,nonatomic) NSString *passwordexpirydate;
@property (strong,nonatomic) NSString *passwordexpirylastshowndate;
@property (nonatomic) long long lastunixtimestampreceived;
@property (strong,nonatomic) NSDate *lastunixtimestampreceivedtime;
+(GlobalVariables *) singleObj;

@end



