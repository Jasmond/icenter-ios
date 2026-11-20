//
//  CalenderView.m
//  iCenter
//
//  Created by Jasmond Luk on 12/1/2018.
//  Copyright © 2018 DreamHigh Company Limited. All rights reserved.
//

#import "CalendarView.h"
#import "CalendarCViewCell.h"
#import "InstructorAvailabilityCViewCell.h"

@implementation CalendarView
@synthesize multipleselection,selecteddatearray,schedulerecord;


-(id) initWithFrame:(CGRect)frame Theme:(NSInteger)_theme CanPickHoliday:(BOOL)_canpickholiday MultipleSelection:(BOOL)_multipleselection ShowTodayButton:(BOOL)_showtodaybutton showclassdot:(BOOL)_showclassdot schedulerecord:(ScheduleRecord *)_schedulerecord UpdateScheduleMode:(NSString *)_updateschedulemode availablemakeuptimeslots:(NSMutableDictionary *)_availablemakeuptimeslots instructoravailability:(NSMutableDictionary *)_instructoravability dataType:(NSString *)_datatype disablecalendar:(BOOL)_disablecalender
{
    //self.view.backgroundColor=[UIColor systemGroupedBackgroundColor];
    
    globalvariables=[GlobalVariables singleObj];
    
    df=[[NSDateFormatter alloc]init];
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    NSString* nibName = NSStringFromClass([self class]);
    self = [super initWithFrame:frame];
    if (self) {
        if ([[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]) {
            
            
            
            calendersize=frame.size;
            cellwidth=frame.size.width/7;
            theme=_theme;
            showtodaybutton=_showtodaybutton;
            canpickholiday=_canpickholiday;
            showclassdot=_showclassdot;
            multipleselection=_multipleselection;
            updateschedulemode=_updateschedulemode;
            //selecteddatearray=_selecteddatearray;
            //scrolltodate=_scrolltodate;
            schedulerecord=_schedulerecord;
            availablemakeuptimeslots=_availablemakeuptimeslots;
            instructoravability=_instructoravability;
            datatype=_datatype;
            disablecalendar=_disablecalender;
            
            UIImageView *activityImageView=[[UIImageView alloc]init];
            activityImageView.animationImages=[MyClass returnLoadingIndicatorAnimatedImageWithBaseColor:@"lightgray"];
            activityImageView.alpha=1.0;
            activityImageView.animationDuration=1.5;
            activityImageView.frame=CGRectMake(0,0,45,45);
            [activityImageView startAnimating];
            
            ailoadindicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleMedium;
            ailoadindicator.alpha = 1.0;
            ailoadindicator.color=[UIColor clearColor];
            ailoadindicator.transform=CGAffineTransformMakeScale(1, 1);
            //ailoadindicator.center = CGPointMake(152.5,self.view.frame.size.height/2-7.5);
            ailoadindicator.hidesWhenStopped = YES;
            [ailoadindicator addSubview:activityImageView];
            [self.view addSubview:ailoadindicator];
            
            if ([globalvariables.language isEqualToString:@"English"]) {
                dayofweekArray=[[NSArray alloc]initWithObjects:@"S",@"M",@"T",@"W",@"T",@"F",@"S", nil];
            }else{
                dayofweekArray=[[NSArray alloc]initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
            }
            
            if (theme==1) {
                monthfontsize=15;
                monthheight=35;
                monthdayheight=30;
                monthoffset=0;
                cellheight=35;
                selecteddatebackgroundsize=cellheight-2;
                monthbackgroundcolor=[UIColor lightGrayColor];
                tablebackgroundcolor=[UIColor colorWithRed:220.0/255.0 green:229.0/255.0 blue:240.0/255.0 alpha:1];
                monthtitlecolor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0];
                dayofweekheader.hidden=YES;
            }else if (theme==2) {
                monthfontsize=15;
                monthheight=35;
                monthdayheight=30;
                monthoffset=0;
                cellheight=35;
                selecteddatebackgroundsize=cellheight-2;
                monthbackgroundcolor=[UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1];
                tablebackgroundcolor=[UIColor colorWithRed:220.0/255.0 green:229.0/255.0 blue:240.0/255.0 alpha:1];
                monthtitlecolor=[UIColor orangeColor];
                dayofweekheader.hidden=YES;
            }else if (theme==3) {
                monthfontsize=15;
                monthheight=0;
                monthdayheight=30;
                monthoffset=0;
                cellheight=showclassdot?50:45;
                selecteddatebackgroundsize=showclassdot?36-12:cellheight-12;
                monthbackgroundcolor=[UIColor lightGrayColor];
                tablebackgroundcolor=[UIColor colorWithRed:220.0/255.0 green:229.0/255.0 blue:240.0/255.0 alpha:1];
                monthtitlecolor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0];
                dayofweekheader.hidden=NO;
                sunlabel.text=[dayofweekArray objectAtIndex:0];
                monlabel.text=[dayofweekArray objectAtIndex:1];
                tuelabel.text=[dayofweekArray objectAtIndex:2];
                wedlabel.text=[dayofweekArray objectAtIndex:3];
                thulabel.text=[dayofweekArray objectAtIndex:4];
                frilabel.text=[dayofweekArray objectAtIndex:5];
                satlabel.text=[dayofweekArray objectAtIndex:6];
            }else if (theme==4) {
                //instructor availability
                monthfontsize=15;
                monthheight=0;
                monthdayheight=30;
                monthoffset=0;
                cellheight=70;
                selecteddatebackgroundsize=22;
                monthbackgroundcolor=[UIColor lightGrayColor];
                tablebackgroundcolor=[UIColor colorWithRed:220.0/255.0 green:229.0/255.0 blue:240.0/255.0 alpha:1];
                monthtitlecolor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0];
                dayofweekheader.hidden=NO;
                sunlabel.text=[dayofweekArray objectAtIndex:0];
                monlabel.text=[dayofweekArray objectAtIndex:1];
                tuelabel.text=[dayofweekArray objectAtIndex:2];
                wedlabel.text=[dayofweekArray objectAtIndex:3];
                thulabel.text=[dayofweekArray objectAtIndex:4];
                frilabel.text=[dayofweekArray objectAtIndex:5];
                satlabel.text=[dayofweekArray objectAtIndex:6];
            }else{
                monthfontsize=12;
                monthheight=20;
                monthdayheight=20;
                monthoffset=6;
                cellheight=31;
                selecteddatebackgroundsize=cellheight-8;
                monthbackgroundcolor=[UIColor whiteColor];
                tablebackgroundcolor=[UIColor whiteColor];
                monthtitlecolor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0];
                dayofweekheader.hidden=YES;
            }
            
            
            if (showtodaybutton) {
                todaybutton.hidden=NO;
                [todaybutton setTitle:[MyClass returntitlewithtitle:@"Today"] forState:UIControlStateNormal];
                
                todaybutton.backgroundColor=[UIColor whiteColor];
                todaybutton.layer.borderColor=[UIColor grayColor].CGColor;
                todaybutton.layer.borderWidth=1;
                [todaybutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            }else{
                todaybutton.hidden=YES;
            }
            
            if ([updateschedulemode isEqualToString:@"start"]) {
                checkcsstartdate=FALSE;
                checkcsenddate=TRUE;
            }else if ([updateschedulemode isEqualToString:@"end"]){
                checkcsstartdate=TRUE;
                checkcsenddate=FALSE;
            }else{
                checkcsstartdate=TRUE;
                checkcsenddate=TRUE;
            }
            
            
            
            CalendarTable.separatorColor=[UIColor clearColor];
            

            //[CalendarTable reloadData];
            //[self scrollToSelectedDate];
            
            
            
            
            self.view.frame=self.bounds;
            [self addSubview:self.view];
            //[self.view layoutIfNeeded];
            
        }
    }
    return self;
    
    
}

-(void) scrollToSelectedDateWithSelectedDateArray:(NSMutableArray *)_selecteddatearray ScrollToDate:(NSString *)_scrolltodate instructorselected:(NSString *)_instructorselected
{
    
    selecteddatearray=_selecteddatearray;
    scrolltodate=_scrolltodate;
    instructorselected=_instructorselected;
    
    [self getclassddayrecord];
    
    if (!selecteddatearray) {
        selecteddatearray=[[NSMutableArray alloc]init];
    }else{
        if (!scrolltodate) {
            scrolltodate=[selecteddatearray firstObject];
        }
    }
    
    [CalendarTable reloadData];
    if (scrolltodate) {
        NSInteger section=[MyClass returnMonthOffsetWithDate:[MyClass convertToNSDateWithDate:scrolltodate DateFormat:@"dd-MMM-yyyy"]];

        [CalendarTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    if(theme==3 || theme==4){
        [self.delegate returnCalendarYear:[NSString stringWithFormat:@"%ld",[self returnCalendarYear]]];
    }
}

-(long) returnCalendarYear
{
    NSArray *indexPathsForVisibleRows = [CalendarTable indexPathsForVisibleRows];
    //NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    float total=0;
    for ( NSIndexPath *indexPath in indexPathsForVisibleRows ) {
        //[indexSet addIndex:indexPath.section];
        total+=[MyClass returnYearFromBaseDateWithOffset:indexPath.section];
    }
    
    return lroundf(total/indexPathsForVisibleRows.count);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ((!selecteddatearray || selecteddatearray.count==0) && !scrolltodate) {
        loadSections=NO;
    }else{
        loadSections=YES;
    }
    
    return loadSections?300:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if(!showtodaybutton){
        return cellheight*6;
    }*/

    NSString *month=[MyClass returnMonthFromBaseDateWithOffset:indexPath.section];
    [df setDateFormat:@"MMMM yyyy"];
    NSDate *date = [df dateFromString:month];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSRange weekRange = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitMonth forDate:date];
    NSInteger weeksCount = weekRange.length;
    
    return cellheight*weeksCount;
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return cellheight*6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return monthheight+monthdayheight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UICollectionView *calendarview;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UICollectionViewFlowLayout *vfl=[[UICollectionViewFlowLayout alloc]init];
        calendarview=[[UICollectionView alloc]initWithFrame:CGRectMake(30, 70, 320, 50) collectionViewLayout:vfl];
        calendarview.delegate=self;
        calendarview.dataSource=self;
        calendarview.tag=211;
        calendarview.backgroundColor=[UIColor clearColor];
        [calendarview registerClass:[CalendarCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [cell.contentView addSubview:calendarview];
        
    }else{
        calendarview=(UICollectionView *)[cell.contentView viewWithTag:211];
    }
    
    UINib *cellNib;
    if (theme==4) {
        [calendarview registerClass:[InstructorAvailabilityCViewCell class] forCellWithReuseIdentifier:@"InstructorAvailabilityCViewCell"];
        cellNib = [UINib nibWithNibName:@"InstructorAvailabilityCViewCell" bundle:nil];
        
    }else{
        [calendarview registerClass:[CalendarCViewCell class] forCellWithReuseIdentifier:@"CalendarCViewCell"];
        cellNib = [UINib nibWithNibName:@"CalendarCViewCell" bundle:nil];
    }
    
    [calendarview registerNib:cellNib forCellWithReuseIdentifier:@"cell"];
    
    //determine number of week row
    NSString *monthyear=[MyClass returnMonthFromBaseDateWithOffset:indexPath.section];
    NSDate *date = [MyClass convertToNSDateWithDate:monthyear DateFormat:@"MMMM yyyy"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSRange weekRange = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitMonth forDate:date];
    NSInteger weeksCount = weekRange.length;
    
    
    calendarview.frame=CGRectMake(0, 0, calendersize.width, cellheight*(weeksCount+1));
    [calendarview reloadData];
    
    
    //configure the cell
    cell.backgroundColor=tablebackgroundcolor;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *monthyear=[MyClass returnMonthFromBaseDateWithOffset:section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, calendersize.width, monthheight+monthdayheight)];
    headerView.backgroundColor=tablebackgroundcolor;
    
    if(theme==3 || theme==4){
        NSDate *date = [MyClass convertToNSDateWithDate:monthyear DateFormat:@"MMMM yyyy"];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekday fromDate:date];
        NSDateComponents *todaycomponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekday fromDate:[NSDate date]];
        long i = [components weekday]-1;
        
        UILabel *dayofweeklabel;

        dayofweeklabel=[[UILabel alloc]initWithFrame:CGRectMake(i*cellwidth+(calendersize.width-7*cellwidth)/2, monthheight, cellwidth, monthdayheight)];
        dayofweeklabel.text=[MyClass convertDateFormatWithDate:[MyClass returnMonthFromBaseDateWithOffset:section] FromDateFormat:@"MMMM yyyy" ToDateFormat:@"MMM" Translate:YES];
        
        if (components.month==todaycomponents.month) {
            dayofweeklabel.textColor=[UIColor redColor];
        }else{
            dayofweeklabel.textColor=[UIColor blackColor];
        }
        
        dayofweeklabel.textAlignment=NSTextAlignmentCenter;
        dayofweeklabel.font=[UIFont boldSystemFontOfSize:16];
        dayofweeklabel.adjustsFontSizeToFitWidth=YES;
        [headerView addSubview:dayofweeklabel];
        //}
        
    }else{
        UIView *monthview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, calendersize.width, monthheight)];
        monthview.backgroundColor=monthbackgroundcolor;
        [headerView addSubview:monthview];
        
        UILabel *myLabel = [[UILabel alloc] init];
        myLabel.frame = CGRectMake(0, monthoffset, calendersize.width, monthheight-monthoffset);
        myLabel.font = [UIFont systemFontOfSize:monthfontsize];
        myLabel.textAlignment=NSTextAlignmentCenter;
        myLabel.text = [MyClass returndateformatMMMM_yyyywithdate:monthyear];
        myLabel.textColor=monthtitlecolor;
        [headerView addSubview:myLabel];
        
        UILabel *dayofweeklabel;
        //add day of week
        for (int i=0; i<7; i++) {
            dayofweeklabel=[[UILabel alloc]initWithFrame:CGRectMake(i*cellwidth+(calendersize.width-7*cellwidth)/2, monthheight, cellwidth, monthdayheight)];
            dayofweeklabel.text=[dayofweekArray objectAtIndex:i];
            dayofweeklabel.textColor=[UIColor blackColor];
            dayofweeklabel.textAlignment=NSTextAlignmentCenter;
            dayofweeklabel.font=[UIFont systemFontOfSize:10];
            [headerView addSubview:dayofweeklabel];
        }
        
        UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(3, monthheight+monthdayheight, calendersize.width-6, 0.8)];
        separator.backgroundColor=[UIColor lightGrayColor];
        [headerView addSubview:separator];
    }
    
    return headerView;
}

-(void) refreshviewwithoption:(NSString *)option
{
    if ([option isEqualToString:@"start"]) {
        [ailoadindicator startAnimating];
        CalendarTable.hidden=YES;
        todaybutton.hidden=YES;
    }else{
        [self->ailoadindicator stopAnimating];
        CalendarTable.hidden=NO;
        todaybutton.hidden=NO;
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CGPoint point = [collectionView convertPoint:CGPointZero toView:CalendarTable];
    NSIndexPath *indexpath =[CalendarTable indexPathForRowAtPoint:point];
    
    NSString *monthyear=[MyClass returnMonthFromBaseDateWithOffset:indexpath.section];
    NSDate *date = [MyClass convertToNSDateWithDate:monthyear DateFormat:@"MMMM yyyy"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSRange weekRange = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitMonth forDate:date];
    NSInteger weeksCount = weekRange.length;
    
    return (weeksCount+1)*7;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGPoint point = [collectionView convertPoint:CGPointZero toView:CalendarTable];
    NSIndexPath *indexpath =[CalendarTable indexPathForRowAtPoint:point];

    NSString *monthyear=[MyClass returnMonthFromBaseDateWithOffset:indexpath.section];
    NSDate *date = [MyClass convertToNSDateWithDate:monthyear DateFormat:@"MMMM yyyy"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSInteger daysCount = dayRange.length;
    
    //find starting day
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekday fromDate:date];
    long weekdayToday = [components weekday]-2;
    
    NSString *year=[monthyear substringFromIndex:[monthyear length]-4];
    [df setDateFormat:@"MM"];
    NSString *month=[df stringFromDate:date];
    NSString *day=[NSString stringWithFormat:@"%ld",indexPath.row-weekdayToday];
    
    NSString *dateselectedstring=[NSString stringWithFormat:@"%@-%@-%02i",year,month,[day intValue]];
    NSDate *dateselected=[MyClass convertToNSDateWithDate:dateselectedstring DateFormat:@"yyyy-MM-dd"];
    NSString *todaystring=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
    
    if (theme==4) {
        InstructorAvailabilityCViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.todaybackgroundheightcontstraint.constant=selecteddatebackgroundsize;
        cell.todaybackground.layer.cornerRadius=selecteddatebackgroundsize/2;
        [cell setUserInteractionEnabled:NO];
        
        if (indexPath.row>weekdayToday && indexPath.row<=daysCount+weekdayToday) {
            cell.view.hidden=NO;
            cell.daylabel.text=day;
            
            if ([dateselectedstring isEqualToString:todaystring]){
                [cell.todaybackground setBackgroundColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.4]];
            }else{
                [cell.todaybackground setBackgroundColor:nil];
            }
            
            if(multipleselection){
                if ([selecteddatearray containsObject:[MyClass convertToNSStringWithNSDate:dateselected DateFormat:@"dd-MMM-yyyy"]]){
                    cell.checkedview.hidden=NO;
                }else{
                    cell.checkedview.hidden=YES;
                }
            }else{
                cell.checkedview.hidden=YES;
            }
            
            NSMutableArray *records=[instructoravability valueForKey:dateselectedstring];
            NSMutableArray *classtimerecords=[classrecords valueForKey:dateselectedstring];
            [MyClass drawAvailabilityChartWithView:cell.availabilityimage AvailabilityRecords:records ClassRecords:classtimerecords Small:YES];
            
            
            NSString *centerday=[globalvariables.centerdaydictionary objectForKey:[NSString stringWithFormat:@"%@#%@",dateselectedstring,globalvariables.centerrecord.centerkey]];
            
            if ([centerday isEqualToString:@"H"]) {
                cell.daylabel.textColor=[UIColor redColor];
                if (canpickholiday) {
                    [cell setUserInteractionEnabled:YES];
                    cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
                }
            }else if ([centerday isEqualToString:@"R"]) {
                cell.daylabel.textColor=[UIColor colorWithRed:255.0/255.0 green:69.0/255.0 blue:0.0/255.0 alpha:1.0];
                if (![datatype isEqualToString:@"startdate"]) {
                    [cell setUserInteractionEnabled:YES];
                }
                
                cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
            }else {
                if (![cell.daylabel.text isEqualToString:@""]){
                    [cell setUserInteractionEnabled:YES];
                }
                cell.daylabel.textColor=[UIColor blackColor];
                cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
            }
            

            
            cell.separator.hidden=NO;
        }else{
            cell.view.hidden=YES;
            
        }
        
        return cell;
        
    }else{
        CalendarCViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.todaybackgroundheightcontstraint.constant=selecteddatebackgroundsize;
        cell.todaybackground.layer.cornerRadius=selecteddatebackgroundsize/2;
        [cell setUserInteractionEnabled:NO];
        
        if (indexPath.row>weekdayToday && indexPath.row<=daysCount+weekdayToday) {
            cell.view.hidden=NO;
            cell.daylabel.text=day;
            
            if ([selecteddatearray containsObject:[MyClass convertToNSStringWithNSDate:dateselected DateFormat:@"dd-MMM-yyyy"]]){
                [cell.todaybackground setBackgroundColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.4]];
            }else{
                [cell.todaybackground setBackgroundColor:nil];
            }
            
            if (showclassdot) {
                //if has class
                cell.hasclassviewdot.hidden=NO;
                if ([classdayarray containsObject:dateselectedstring]) {
                    [cell.hasclassviewdot setBackgroundColor:[UIColor darkGrayColor]];
                }else{
                    [cell.hasclassviewdot setBackgroundColor:nil];
                }
            }else{
                cell.hasclassviewdot.hidden=YES;
            }
            
            NSString *centerday=[globalvariables.centerdaydictionary objectForKey:[NSString stringWithFormat:@"%@#%@",dateselectedstring,globalvariables.centerrecord.centerkey]];
            
            //[cell setUserInteractionEnabled:NO];
            
            if(disablecalendar){
                cell.daylabel.textColor=[UIColor lightGrayColor];
            }else if(availablemakeuptimeslots){
                if ([availablemakeuptimeslots valueForKey:dateselectedstring]) {
                    if ([centerday isEqualToString:@"H"] || [centerday isEqualToString:@"R"]) {
                        cell.daylabel.textColor=[UIColor redColor];
                        if (canpickholiday) {
                            [cell setUserInteractionEnabled:YES];
                            cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
                        }
                    }else{
                        cell.daylabel.textColor=[UIColor blackColor];
                        if (![cell.daylabel.text isEqualToString:@""]){
                            [cell setUserInteractionEnabled:YES];
                            cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
                        }
                    }
                }else{
                    if ([centerday isEqualToString:@"H"] || [centerday isEqualToString:@"R"]) {
                        cell.daylabel.textColor=[UIColor redColor];
                    }else{
                        cell.daylabel.textColor=[UIColor lightGrayColor];
                    }
                }
            }else if (!schedulerecord || [schedulerecord.schedulekey intValue]<0) {
                if ([centerday isEqualToString:@"H"]) {
                    cell.daylabel.textColor=[UIColor redColor];
                    if (canpickholiday) {
                        [cell setUserInteractionEnabled:YES];
                        cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
                    }
                }else if ([centerday isEqualToString:@"R"]) {
                    cell.daylabel.textColor=[UIColor colorWithRed:255.0/255.0 green:69.0/255.0 blue:0.0/255.0 alpha:1.0];
                    if (![datatype isEqualToString:@"startdate"]) {
                        [cell setUserInteractionEnabled:YES];
                    }
                    cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
                }else {
                    if (![cell.daylabel.text isEqualToString:@""]){
                        [cell setUserInteractionEnabled:YES];
                    }
                    cell.daylabel.textColor=[UIColor blackColor];
                    cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
                }
                
                if([datatype isEqualToString:@"paiddate"]){
                    if(!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).allowdatebackpaiddate){
                        if([dateselected compare:[MyClass convertToNSDateWithDate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd"] DateFormat:@"yyyy-MM-dd"]] ==NSOrderedAscending){
                            cell.daylabel.textColor=[UIColor lightGrayColor];
                            [cell setUserInteractionEnabled:NO];
                        }
                        
                    }
                }
                
            }else{
                if ([MyClass schedulecontainscelldatetimewithdate:dateselected time:@"Any" schedulerecord:schedulerecord]) {
                    
                    
                    if (!checkcsstartdate || [schedulerecord.startdate isEqualToString:@""] || [[MyClass convertToNSDateWithDate:schedulerecord.startdate DateFormat:@"dd-MMM-yyyy"] compare:dateselected]!=NSOrderedDescending) {
                        if (!checkcsenddate || [schedulerecord.enddate isEqualToString:@""] || [dateselected compare:[MyClass convertToNSDateWithDate:schedulerecord.enddate DateFormat:@"dd-MMM-yyyy"]]!=NSOrderedDescending) {
                            if ([centerday isEqualToString:@"H"]) {
                                cell.daylabel.textColor=[UIColor redColor];
                                if (canpickholiday) {
                                    [cell setUserInteractionEnabled:YES];
                                    cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
                                }
                            }else if ([centerday isEqualToString:@"R"]) {
                                cell.daylabel.textColor=[UIColor colorWithRed:255.0/255.0 green:69.0/255.0 blue:0.0/255.0 alpha:1.0];
                                if (![datatype isEqualToString:@"startdate"]) {
                                    [cell setUserInteractionEnabled:YES];
                                }
                                cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
                            }else{
                                cell.daylabel.textColor=[UIColor blackColor];
                                if (![cell.daylabel.text isEqualToString:@""]){
                                    [cell setUserInteractionEnabled:YES];
                                    cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
                                }
                            }
                        }else{
                            cell.daylabel.textColor=[UIColor lightGrayColor];
                        }
                    }else{
                        cell.daylabel.textColor=[UIColor lightGrayColor];
                    }
                    
                }else{
                    cell.daylabel.textColor=[UIColor lightGrayColor];
                }
            }
            cell.separator.hidden=theme!=3;
        }else{
            cell.view.hidden=YES;
            /*cell.daylabel.text=@"";
            cell.todaybackground.hidden=YES;
            cell.hasclassviewdot.hidden=YES;*/
        }
        
        return cell;
    }
    

    
    
    
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%f",cellwidth);
    return CGSizeMake(cellwidth, cellheight);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSDate *selected_date=[MyClass convertToNSDateWithDate:[NSString stringWithFormat:@"%ld",(long)cell.tag] DateFormat:@"yyyyMMdd"];
    
    if (theme==4) {
        //if (!viewOnly) {
            if (multipleselection) {
                NSString *selected_date_string=[MyClass convertToNSStringWithNSDate:selected_date DateFormat:@"dd-MMM-yyyy"];
                if ([selecteddatearray containsObject:selected_date_string]) {
                    [selecteddatearray removeObject:selected_date_string];
                }else{
                    [selecteddatearray addObject:selected_date_string];
                }
                [CalendarTable reloadData];
                [self.delegate returncalendarselecteddatearray:[self returnStandardDateArrayWithDates:selecteddatearray] makeuptimearray:nil];
            }else{
                selecteddatearray=[[NSMutableArray alloc]initWithObjects:[MyClass convertToNSStringWithNSDate:selected_date DateFormat:@"yyyy-MM-dd"], nil];
                [self.delegate returncalendarselecteddatearray:selecteddatearray makeuptimearray:nil];
            }
        //}
    }else{
        
        NSString *selected_date_string=[MyClass convertToNSStringWithNSDate:selected_date DateFormat:@"dd-MMM-yyyy"];
        
        if(!availablemakeuptimeslots){
            if (multipleselection) {
                if ([selecteddatearray containsObject:selected_date_string]) {
                    [selecteddatearray removeObject:selected_date_string];
                }else{
                    [selecteddatearray addObject:selected_date_string];
                }
                //sort array
                NSMutableArray *tempClassDate=[[NSMutableArray alloc]init];
                for (int i=0; i<selecteddatearray.count; i++) {
                    [tempClassDate addObject:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:[selecteddatearray objectAtIndex:i]]];
                }
                tempClassDate=[[NSMutableArray alloc]initWithArray:[tempClassDate sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
                selecteddatearray=[[NSMutableArray alloc]init];
                for (int i=0; i<tempClassDate.count; i++) {
                    [selecteddatearray addObject:[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:[tempClassDate objectAtIndex:i]]];
                }
            }else{
                selecteddatearray=[[NSMutableArray alloc]initWithObjects:selected_date_string, nil];
            }
            
            [CalendarTable reloadData];
            [self.delegate returncalendarselecteddatearray:selecteddatearray makeuptimearray:nil];
        }else{
            selecteddatearray=[[NSMutableArray alloc]initWithObjects:selected_date_string, nil];
            NSArray *makeuptimearray=[MyClass returnclasstimewithdate:selected_date_string availablemakeupslots:availablemakeuptimeslots];
            
            [CalendarTable reloadData];
            [self.delegate returncalendarselecteddatearray:selecteddatearray makeuptimearray:makeuptimearray];
            
        }
    }

}



-(void) getclassddayrecord
{
    if (showclassdot) {
        classdayarray=[MyClass retrieveClassDaywithInstructor:instructorselected];
    }
}


- (IBAction)todaypressed:(id)sender {
    [CalendarTable reloadData];
    [self.delegate returncalendarselecteddatearray:[[NSMutableArray alloc]initWithObjects:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"], nil] makeuptimearray:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    
    if(theme==3 || theme==4){
        [self.delegate returnCalendarYear:[NSString stringWithFormat:@"%ld",[self returnCalendarYear]]];
    }
    
}


-(void) reloadWithInstructorAvailability:(NSMutableDictionary *)dict ClassRecords:(NSMutableDictionary *)classrecordsdict
{
    instructoravability=dict;
    classrecords=classrecordsdict;
    [CalendarTable reloadData];
}

-(NSMutableArray *) returnStandardDateArrayWithDates:(NSMutableArray *)datearray
{
    NSMutableArray *standardarray=[[NSMutableArray alloc]init];
    for (int i=0; i<datearray.count; i++) {
        [standardarray addObject:[MyClass convertDateFormatWithDate:[datearray objectAtIndex:i] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO]];
    }
    return standardarray;
}

@end
