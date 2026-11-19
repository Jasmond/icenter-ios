//
//  CalenderView.h
//  iCenter
//
//  Created by Jasmond Luk on 12/1/2018.
//  Copyright © 2018 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "MyClass.h"
#import "CalendarCollectionViewCell.h"

@protocol myCalendarViewDelegate <NSObject>

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray;
-(void) returnCalendarYear:(NSString *)year;

@end

@interface CalendarView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
{
    GlobalVariables *globalvariables;
    NSDateFormatter *df;
    

    IBOutlet UITableView *CalendarTable;
    IBOutlet UIButton *todaybutton;
    __weak IBOutlet UIView *dayofweekheader;
    __weak IBOutlet UILabel *sunlabel;
    __weak IBOutlet UILabel *monlabel;
    __weak IBOutlet UILabel *tuelabel;
    __weak IBOutlet UILabel *wedlabel;
    __weak IBOutlet UILabel *thulabel;
    __weak IBOutlet UILabel *frilabel;
    __weak IBOutlet UILabel *satlabel;
    
    NSInteger theme;
    BOOL showtodaybutton;
    BOOL canpickholiday;
    //BOOL multipleselection;
    BOOL showclassdot;
    NSString *updateschedulemode;
    NSString *instructorselected;
    //NSMutableArray *selecteddatearray;
    NSString *scrolltodate;
    //ScheduleRecord *schedulerecord;
    CGSize calendersize;
    NSString *datatype;

    
    NSArray *dayofweekArray;
    float monthfontsize;
    float monthheight;
    float monthdayheight;
    float monthoffset;
    float cellheight;
    int cellwidth;
    float selecteddatebackgroundsize;
    UIColor *monthbackgroundcolor;
    UIColor *tablebackgroundcolor;
    UIColor *monthtitlecolor;
    NSMutableArray *classdayarray;
    NSMutableDictionary *availablemakeuptimeslots;
    NSMutableDictionary *instructoravability;
    NSMutableDictionary *classrecords;
    
    IBOutlet UIActivityIndicatorView *ailoadindicator;
    
    BOOL checkcsstartdate;
    BOOL checkcsenddate;
    BOOL loadSections;
    BOOL disablecalendar;
}

@property (weak,nonatomic)id<myCalendarViewDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (nonatomic) BOOL multipleselection;
@property (strong, nonatomic) NSMutableArray *selecteddatearray;
@property (strong, nonatomic) ScheduleRecord *schedulerecord;

-(id) initWithFrame:(CGRect)frame Theme:(NSInteger)_theme CanPickHoliday:(BOOL)_canpickholiday MultipleSelection:(BOOL)_multipleselection ShowTodayButton:(BOOL)_showtodaybutton showclassdot:(BOOL)_showclassdot schedulerecord:(ScheduleRecord *)_schedulerecord UpdateScheduleMode:(NSString *)_updateschedulemode availablemakeuptimeslots:(NSMutableDictionary *)_availablemakeuptimeslots instructoravailability:(NSMutableDictionary *)_instructoravability dataType:(NSString *)_datatype disablecalendar:(BOOL)_disablecalender;
-(void) scrollToSelectedDateWithSelectedDateArray:(NSMutableArray *)_selecteddatearray ScrollToDate:(NSString *)_scrolltodate instructorselected:(NSString *)_instructorselected;
-(void) refreshviewwithoption:(NSString *)option;

- (IBAction)todaypressed:(id)sender;
-(void) reloadWithInstructorAvailability:(NSMutableDictionary *)dict ClassRecords:(NSMutableDictionary *)classrecordsdict;

@end
