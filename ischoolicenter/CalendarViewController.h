//
//  CalendarViewController.h
//  ischoolicenter
//
//  Created by Jasmond Luk on 27/2/2017.
//  Copyright © 2017 DreamHigh Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "MyClass.h"

@protocol myCalendarViewControllerDelegate <NSObject>

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray;

@end

@interface CalendarViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    GlobalVariables *globalvariables;
    NSDateFormatter *df;
    NSArray *dayofweekArray;
    float monthfontsize;
    float monthheight;
    float monthdayheight;
    float monthoffset;
    float cellheight;
    float selecteddatebackgroundsize;
    UIColor *monthbackgroundcolor;
    UIColor *tablebackgroundcolor;
    UIColor *monthtitlecolor;
    NSMutableArray *classdayarray;
    UIActivityIndicatorView *ailoadindicator;
    UIButton *todaybutton;
    BOOL checkcsstartdate;
    BOOL checkcsenddate;
    BOOL loadSections;
}

@property (weak,nonatomic)id<myCalendarViewControllerDelegate>delegate;
@property (nonatomic,strong) NSMutableArray *selecteddatearray;
@property (nonatomic,strong) NSString *scrolltodate;
@property (nonatomic,strong) ScheduleRecord *schedulerecord;
@property (nonatomic) BOOL canpickholiday;
@property (nonatomic) BOOL multipleselection;
@property (nonatomic) float calendarwidth;
@property (nonatomic) float calendarheight;
@property (nonatomic,strong) UITableView *CalendarTable;
@property (nonatomic) int theme;
@property (nonatomic) BOOL showtodaybutton;
@property (nonatomic) BOOL showclassdot;
@property (nonatomic,strong) NSString *instructorselected;
@property (nonatomic,strong) NSString *updateschedulemode;

-(void) scrollToSelectedDate;
-(void) getclassddayrecord;
-(void) refreshviewwithoption:(NSString *)option;

@end
