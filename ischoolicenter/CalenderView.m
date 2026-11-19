//
//  CalenderView.m
//  iCenter
//
//  Created by Jasmond Luk on 12/1/2018.
//  Copyright © 2018 DreamHigh Company Limited. All rights reserved.
//

#import "CalendarView.h"

@implementation CalendarView


-(id) initWithFrame:(CGRect)frame Theme:(NSInteger)_theme CanPickHoliday:(BOOL)_canpickholiday MultipleSelection:(BOOL)_multipleselection ShowTodayButton:(BOOL)_showtodaybutton showclassdot:(BOOL)_showclassdot instructorselected:(NSString *)_instructorselected selecteddatearray:(NSMutableArray *)_selecteddatearray scrolltodate:(NSString *)_scrolltodate schedulerecord:(ScheduleRecord *)_schedulerecord UpdateScheduleMode:(NSString *)_updateschedulemode
{
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    globalvariables=[GlobalVariables singleObj];
    
    df=[[NSDateFormatter alloc]init];
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    calendersize=frame.size;
    cellwidth=frame.size.width/7.0;
    theme=_theme;
    showtodaybutton=_showtodaybutton;
    canpickholiday=_canpickholiday;
    showclassdot=_showclassdot;
    multipleselection=_multipleselection;
    updateschedulemode=_updateschedulemode;
    selecteddatearray=_selecteddatearray;
    scrolltodate=_scrolltodate;
    schedulerecord=_schedulerecord;
    instructorselected=_instructorselected;
    
    
    
    if (theme==1) {
        monthfontsize=15;
        monthheight=35;
        monthdayheight=30;
        monthoffset=0;
        cellheight=35;
        selecteddatebackgroundsize=cellheight-4;
        monthbackgroundcolor=[UIColor lightGrayColor];
        tablebackgroundcolor=[UIColor colorWithRed:220.0/255.0 green:229.0/255.0 blue:240.0/255.0 alpha:1];
        monthtitlecolor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0];
    }else if (theme==2) {
        monthfontsize=15;
        monthheight=35;
        monthdayheight=30;
        monthoffset=0;
        cellheight=35;
        selecteddatebackgroundsize=cellheight-4;
        monthbackgroundcolor=[UIColor colorWithRed:82.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1];
        tablebackgroundcolor=[UIColor colorWithRed:220.0/255.0 green:229.0/255.0 blue:240.0/255.0 alpha:1];
        monthtitlecolor=[UIColor orangeColor];
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
    
    if ([globalvariables.language isEqualToString:@"English"]) {
        dayofweekArray=[[NSArray alloc]initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat", nil];
    }else{
        dayofweekArray=[[NSArray alloc]initWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    }
    
    [self scrollToSelectedDate];
    
    NSString* nibName = NSStringFromClass([self class]);
    self = [super initWithFrame:frame];
    if (self) {
        if ([[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]) {
            
            
            
            //[self.view layoutIfNeeded];
            self.view.frame=self.bounds;
            [self addSubview:self.view];
        }
    }
    return self;
    
    
}

-(void) scrollToSelectedDate
{
    if (!selecteddatearray) {
        selecteddatearray=[[NSMutableArray alloc]init];
    }else{
        if (!scrolltodate) {
            scrolltodate=[selecteddatearray firstObject];
        }
    }
    
    
    if (scrolltodate) {
        NSInteger section=[MyClass returnMonthOffsetWithDate:[MyClass convertToNSDateWithDate:scrolltodate DateFormat:@"dd-MMM-yyyy"]];

        [CalendarTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
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
    return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return monthheight+monthdayheight;
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
    
    //determine number of week row
    NSString *monthyear=[MyClass returnMonthFromBaseDateWithOffset:indexPath.section];
    NSDate *date = [MyClass convertToNSDateWithDate:monthyear DateFormat:@"MMMM yyyy"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSRange weekRange = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitMonth forDate:date];
    NSInteger weeksCount = weekRange.length;
    
    
    calendarview.frame=CGRectMake((self.view.frame.size.width-(cellwidth*7))/2, 0, cellwidth*7, cellheight*(weeksCount+1));
    [calendarview reloadData];
    
    
    //configure the cell
    cell.backgroundColor=tablebackgroundcolor;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, calendersize.width, monthheight+monthdayheight)];
    headerView.backgroundColor=tablebackgroundcolor;
    
    UIView *monthview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, calendersize.width, monthheight)];
    monthview.backgroundColor=monthbackgroundcolor;
    [headerView addSubview:monthview];
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(0, monthoffset, calendersize.width, monthheight-monthoffset);
    myLabel.font = [UIFont systemFontOfSize:monthfontsize];
    myLabel.textAlignment=NSTextAlignmentCenter;
    myLabel.text = [MyClass returndateformatMMMM_yyyywithdate:[MyClass returnMonthFromBaseDateWithOffset:section]];
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
    
    return headerView;
}

-(void) refreshviewwithoption:(NSString *)option
{
    if ([option isEqualToString:@"start"]) {
        [ailoadindicator startAnimating];
        CalendarTable.hidden=YES;
        todaybutton.hidden=YES;
    }else{
        [ailoadindicator stopAnimating];
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
    
    
    __weak CalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSString *monthyear=[MyClass returnMonthFromBaseDateWithOffset:indexpath.section];
    NSDate *date = [MyClass convertToNSDateWithDate:monthyear DateFormat:@"MMMM yyyy"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSInteger daysCount = dayRange.length;
    
    //find starting day
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekday fromDate:date];
    long weekdayToday = [components weekday]-2;
    //cell.backgroundColor=[UIColor lightGrayColor];
    cell.daylabel.frame=CGRectMake(0, 0, cellwidth, cellheight);
    cell.todaybackground.frame=CGRectMake(0, 0, selecteddatebackgroundsize, selecteddatebackgroundsize);
    cell.todaybackground.layer.cornerRadius=cell.todaybackground.frame.size.width/2;
    cell.todaybackground.center=cell.daylabel.center;
    cell.hasclassviewdot.frame=CGRectMake(cellwidth/2-2, cellheight*3/4, 4, 4);
    
    NSString *year=[monthyear substringFromIndex:[monthyear length]-4];
    [df setDateFormat:@"MM"];
    NSString *month=[df stringFromDate:date];
    NSString *day=[NSString stringWithFormat:@"%ld",indexPath.row-weekdayToday];
    
    NSString *dateselectedstring=[NSString stringWithFormat:@"%@-%@-%02i",year,month,[day intValue]];
    NSDate *dateselected=[MyClass convertToNSDateWithDate:dateselectedstring DateFormat:@"yyyy-MM-dd"];
    
    
    if (indexPath.row>weekdayToday && indexPath.row<=daysCount+weekdayToday) {
        cell.daylabel.text=day;
    }else{
        cell.daylabel.text=@"";
    }
    
    if ([selecteddatearray containsObject:[MyClass convertToNSStringWithNSDate:dateselected DateFormat:@"dd-MMM-yyyy"]]){
        cell.todaybackground.hidden=NO;
    }else{
        cell.todaybackground.hidden=YES;
    }
    
    if (showclassdot) {
        //if has class
        if ([classdayarray containsObject:dateselectedstring]) {
            cell.hasclassviewdot.hidden=NO;
        }else{
            cell.hasclassviewdot.hidden=YES;
        }
    }else{
        cell.hasclassviewdot.hidden=YES;
    }
    
    NSString *centerday=[globalvariables.centerdaydictionary objectForKey:[NSString stringWithFormat:@"%@#%@",dateselectedstring,globalvariables.centerrecord.centerkey]];
    
    [cell setUserInteractionEnabled:NO];
    
    
    if (!schedulerecord || [schedulerecord.schedulekey intValue]<0) {
        if ([centerday isEqualToString:@"H"]) {
            cell.daylabel.textColor=[UIColor redColor];
            if (canpickholiday) {
                [cell setUserInteractionEnabled:YES];
                cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
            }
        }else if ([centerday isEqualToString:@"R"]) {
            cell.daylabel.textColor=[UIColor colorWithRed:255.0/255.0 green:69.0/255.0 blue:0.0/255.0 alpha:1.0];
            [cell setUserInteractionEnabled:YES];
            cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
        }else {
            if (![cell.daylabel.text isEqualToString:@""]){
                [cell setUserInteractionEnabled:YES];
            }
            cell.daylabel.textColor=[UIColor blackColor];
            cell.tag=[[NSString stringWithFormat:@"%@%@%02i",year,month,[day intValue]] intValue];
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
                        [cell setUserInteractionEnabled:YES];
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
    
    return cell;
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
    NSString *selected_date_string=[MyClass convertToNSStringWithNSDate:selected_date DateFormat:@"dd-MMM-yyyy"];
    
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
    [self.delegate returncalendarselecteddatearray:selecteddatearray];
}

-(void) getclassddayrecord
{
    if (showclassdot) {
        classdayarray=[MyClass retrieveClassDaywithInstructor:instructorselected];
    }
}


- (IBAction)todaypressed:(id)sender {
    [CalendarTable reloadData];
    [self.delegate returncalendarselecteddatearray:[[NSMutableArray alloc]initWithObjects:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"], nil]];
}
@end
