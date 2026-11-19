//
//  PickerViewController.m
//  iCenter
//
//  Created by Jasmond on 12/7/2019.
//  Copyright © 2019 DreamHigh Company Limited. All rights reserved.
//

#import "PickerViewController.h"
#import "MyTableViewCell.h"

@interface PickerViewController ()

@end

@implementation PickerViewController
@synthesize selecteditems,datatype,dataindex,bottommode,showsearchbar,itemsarray,viewtitle,button,multipleSelection;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    globalvariables=[GlobalVariables singleObj];
    searchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    pickerTable.sectionHeaderHeight=0;
    pickerTable.sectionFooterHeight=0;
    pickerTable.rowHeight=UITableViewAutomaticDimension;
    if ([datatype isEqualToString:@"countrycode"]) {
        itemsarray=[MyClass returnCountryCodeArray];
    }else if ([datatype isEqualToString:@"relationship"]){
        itemsarray=[[NSMutableArray alloc]initWithArray:globalvariables.contactrelationshiparray];
    }else if ([datatype isEqualToString:@"colorcode"]){
        itemsarray=[[NSMutableArray alloc]initWithArray:globalvariables.colorcodearray];
    }else if ([datatype isEqualToString:@"quickpay"]){
        if (!itemsarray) {
            itemsarray=[[NSMutableArray alloc]initWithArray:[MyClass returnPaidMethodArray]];
        }
    }else if ([datatype isEqualToString:@"EvaluationSubject"]){
        itemsarray=[MyClass retrievesubjectinformationwithstatus:@"Active" category:@"All" flushcachedata:NO];
    }else if ([datatype isEqualToString:@"EvaluationGrade"]){
        itemsarray=[NSMutableArray arrayWithArray:[((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).grade componentsSeparatedByString:@","]];
    }
    
    if ([datatype isEqualToString:@"GroupMessageAction"]) {
        pickerTable.scrollEnabled=FALSE;
    }else{
        pickerTable.scrollEnabled=TRUE;
    }

    searchbar.hidden=!showsearchbar;
    if (bottommode) {
        bottombutton.hidden=NO;
        [bottombutton setTitle:[MyClass returntitlewithtitle:bottommode] forState:UIControlStateNormal];
    }else{
        bottombutton.hidden=YES;
    }
    
    if([datatype isEqualToString:@"EvaluationSubject"] || [datatype isEqualToString:@"EvaluationGrade"]){
        bottombutton2.hidden=NO;
        [bottombutton2 setTitle:[MyClass returntitlewithtitle:@"None"] forState:UIControlStateNormal];
    }else{
        bottombutton2.hidden=YES;
    }
    
    
    headerview.hidden=!viewtitle;
    headertitle.text=[MyClass returntitlewithtitle:viewtitle];
    
    
    
    [self returnFiltereditemsarray];
    

    
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
    if ([datatype isEqualToString:@"relationship"]) {
        CGFloat height=pickerTable.contentSize.height+(bottommode?40:0);
        self.preferredContentSize=CGSizeMake(220, height);
    }else if ([datatype isEqualToString:@"countrycode"]){
        CGFloat height=pickerTable.contentSize.height+56;
        self.preferredContentSize=CGSizeMake(220, height);
    }else if ([datatype isEqualToString:@"ReadStatusDetails"] && !viewtitle){
        CGFloat height=pickerTable.contentSize.height;
        self.preferredContentSize=CGSizeMake(300, height);
    }else if ([datatype isEqualToString:@"attachment"]){
        CGFloat height=pickerTable.contentSize.height;
        self.preferredContentSize=CGSizeMake(220, height);
    }else if ([datatype isEqualToString:@"qrcoderefreshfrequency"]){
        CGFloat height=pickerTable.contentSize.height;
        self.preferredContentSize=CGSizeMake(120, height);
    }else if ([datatype isEqualToString:@"classactions"]){
        CGFloat height=pickerTable.contentSize.height;
        self.preferredContentSize=CGSizeMake(180, height);
    }
    [self.view layoutIfNeeded];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [filtereditemsarray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell;
    
    if ([datatype isEqualToString:@"countrycode"]) {
        static NSString *CellIdentifier = @"countrycodecell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CountryCodeRecord *object=[filtereditemsarray objectAtIndex:indexPath.row];
        [MyClass downloadImageWithImageview:cell.imageview1 gender:nil type:@"flag" typekey:object.iso_code image:@"Yes" async:YES];
        cell.label1.text=[MyClass returntitlewithtitle2:object.country_name];
        
        cell.imageview2.hidden=![selecteditems containsObject:object.iso_code];
    }else if ([datatype isEqualToString:@"sharedocument"]) {
        static NSString *CellIdentifier = @"sharedocumentcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if ([[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@"Print"]) {
            [cell.imageview1 setImage:[UIImage imageNamed:@"print_icon.png"]];
        }else if ([[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@"Send eInvoice"] || [[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@"Send eReceipt"]|| [[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@"Send Message"]) {
            [cell.imageview1 setImage:[UIImage imageNamed:@"messagegray_icon.png"]];
        }else if ([[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@"Send Email"]) {
            [cell.imageview1 setImage:[UIImage imageNamed:@"email2_icon.png"]];
        }else if ([[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@"Add to Folder"]) {
            [cell.imageview1 setImage:[UIImage imageNamed:@"documentfolder2_icon.png"]];
        }else if ([[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@"More"]) {
            [cell.imageview1 setImage:[UIImage imageNamed:@"more_icon.png"]];
        }
        cell.label1.text=[MyClass returntitlewithtitle:[filtereditemsarray objectAtIndex:indexPath.row]];

    }else if ([datatype isEqualToString:@"relationship"]){
        static NSString *CellIdentifier = @"relationshipcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        cell.label1.text=[MyClass returntitlewithtitle:[filtereditemsarray objectAtIndex:indexPath.row]];
        cell.imageview2.hidden=![selecteditems containsObject:[filtereditemsarray objectAtIndex:indexPath.row]];
    }else if ([datatype isEqualToString:@"colorcode"]){
        static NSString *CellIdentifier = @"colorcodecell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.label1.backgroundColor=[filtereditemsarray objectAtIndex:indexPath.row];
        cell.imageview2.hidden=![selecteditems containsObject:[@(indexPath.row)stringValue]];
    }else if ([datatype isEqualToString:@"colorscheme"]){
        static NSString *CellIdentifier = @"colorcodecell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.label1.backgroundColor=((ColorScheme *)[filtereditemsarray objectAtIndex:indexPath.row]).main_color;
        cell.imageview2.hidden=![selecteditems containsObject:((ColorScheme *)[filtereditemsarray objectAtIndex:indexPath.row]).colorschemekey];
    }else if ([datatype isEqualToString:@"MessageChannel"]){
        static NSString *CellIdentifier = @"labelcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        cell.label1.text=[MyClass returnMessageChannelNameWithChannelCode:[filtereditemsarray objectAtIndex:indexPath.row]];
        cell.imageview2.hidden=![selecteditems containsObject:[filtereditemsarray objectAtIndex:indexPath.row]];
    }else if ([datatype isEqualToString:@"MessageContact"]){
        static NSString *CellIdentifier = @"messagecontactcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        MessageContactRecord *obj=[filtereditemsarray objectAtIndex:indexPath.row];
        cell.label1.text=obj.messagecontactdisplayname;
        if ([obj.messagecontacttype isEqualToString:@"Student"]) {
            Student *studentObject=[MyClass returnstudentwithstudentkey:obj.messagecontact];
            cell.label2.text=[MyClass returntitlewithtitle:@"Student"];
            [MyClass downloadImageWithImageview:cell.imageview1 gender:studentObject.gender type:@"student" typekey:studentObject.studentkey image:studentObject.image async:YES];
        }else if ([obj.messagecontacttype isEqualToString:@"Staff"]){
            cell.label2.text=[MyClass returntitlewithtitle:@"Staff"];
            [MyClass downloadImageWithImageview:cell.imageview1 gender:nil type:@"staff" typekey:obj.messagecontact image:@"Yes" async:YES];
        }else if ([obj.messagecontacttype isEqualToString:@"Group"]){
            cell.label2.text=[MyClass returntitlewithtitle:@"Group"];
            [cell.imageview1 setImage:[UIImage imageNamed:@"group_icon.png"]];
        }
        
        cell.imageview2.hidden=![self isSelectedMessageContact:obj];
    }else if ([datatype isEqualToString:@"Student"]){
        static NSString *CellIdentifier = @"messagecontactcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        Student *studentObject=[filtereditemsarray objectAtIndex:indexPath.row];
        cell.label1.text=[MyClass returnStudentnameWithStudentkey:studentObject.studentkey option:@"full"];
        cell.label2.text=studentObject.studentid;
        [MyClass downloadImageWithImageview:cell.imageview1 gender:studentObject.gender type:@"student" typekey:studentObject.studentkey image:studentObject.image async:YES];

        
        cell.imageview2.hidden=YES;
    }else if ([datatype isEqualToString:@"ReadStatusDetails"]){
        
        static NSString *CellIdentifier = @"readstatusdetailscell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        ReadStatusRecord *record=[filtereditemsarray objectAtIndex:indexPath.row];
        if ([record.channel isEqualToString:@"A"]) {
            cell.label1.hidden=NO;
            cell.imageview3.hidden=NO;
            cell.label1.text=[MyClass returntitlewithtitle:record.relationship];
            if ([MyClass stringcontainscharacterwithstring:record.recipientkey character:@"@"]) {
                cell.label2.text=record.recipientkey;
                cell.imageview3.hidden=YES;
                [MyClass downloadImageWithImageview:cell.imageview1 gender:nil type:@"staff" typekey:record.recipientkey image:@"Yes" async:YES];
            }else{
                cell.imageview3.hidden=NO;
                cell.label2.text=[MyClass returnLocalNumberWithContact:record.recipientkey ISOCode:record.iso_code];
                [MyClass downloadImageWithImageview:cell.imageview3 gender:nil type:@"flag" typekey:record.iso_code image:@"Yes" async:YES];
            }
            

            if ([record.readtime isEqualToString:@""]) {
                cell.label3.text=[MyClass returntitlewithtitle:@"Unread"];
            }else{
                cell.label3.text=[MyClass convertDateFormatWithDate:record.readtime FromDateFormat:@"yyyy-MM-dd HH:mm:ss" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
            }
        }else if ([record.channel isEqualToString:@"S"]){
            cell.label1.hidden=NO;
            cell.imageview3.hidden=NO;
            cell.label1.text=[MyClass returntitlewithtitle:record.relationship];
            cell.label2.text=[MyClass returnLocalNumberWithContact:record.recipientkey ISOCode:record.iso_code];
            [MyClass downloadImageWithImageview:cell.imageview2 gender:nil type:@"flag" typekey:record.iso_code image:@"Yes" async:YES];
            cell.label3.text=[MyClass returntitlewithtitle:@"SMS"];
        }else if ([record.channel isEqualToString:@"E"]){
            cell.label1.hidden=YES;
            cell.imageview3.hidden=YES;
            cell.label2.text=record.recipientkey;
            cell.label3.text=[MyClass returntitlewithtitle:@"Email"];
        }
        
        
        

    }else if ([datatype isEqualToString:@"ReadStatusStudent"]){
        
        static NSString *CellIdentifier = @"readstatuscell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        ReadStatusRecord *readstatusobject=[filtereditemsarray objectAtIndex:indexPath.row];
        cell.label1.text=readstatusobject.recipientname;
            cell.label2.text=readstatusobject.recipientid;
            
            NSString *readstatus=[self returnreadstatussummarywithcontactgrouparray:readstatusobject.contactgroup];
            
            if ([readstatus isEqualToString:@"NA"] ) {
                if ([readstatusobject.channel isEqualToString:@"S"]) {
                    cell.label3.text=[NSString stringWithFormat:@"%@(SMS)",[MyClass returntitlewithtitle:@"NA"]];
                }else{
                    cell.label3.text=[NSString stringWithFormat:@"%@(Email)",[MyClass returntitlewithtitle:@"NA"]];
                }
                cell.label3.hidden=NO;
                cell.imageview3.hidden=YES;
            }else if ([readstatus isEqualToString:@"NR"]){
                cell.imageview3.hidden=NO;
                [cell.imageview3 setImage:[UIImage imageNamed:@"doublegraycheck_icon.png"]];
                cell.label3.hidden=YES;
            }else if ([readstatus isEqualToString:@"SR"]){
                cell.imageview3.hidden=NO;
                [cell.imageview3 setImage:[UIImage imageNamed:@"graybluecheck_icon.png"]];
                cell.label3.hidden=YES;
            }else{
                cell.imageview3.hidden=NO;
                [cell.imageview3 setImage:[UIImage imageNamed:@"doublebluecheck_icon.png"]];
                cell.label3.hidden=YES;
            }
            
            Student *studentobject=[MyClass returnstudentwithstudentkey:readstatusobject.recipientkey];
            
            
            [MyClass downloadImageWithImageview:cell.imageview1 gender:studentobject.gender type:@"student" typekey:studentobject.studentkey image:studentobject.image async:YES];
        

    }else if ([datatype isEqualToString:@"ReadStatusStaff"]){
        
        static NSString *CellIdentifier = @"readstatusstaffcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
          ReadStatusRecord *readstatusobject=[filtereditemsarray objectAtIndex:indexPath.row];
          cell.label1.text=readstatusobject.recipientname;
          
        
        cell.label2.text=readstatusobject.recipientkey;
        if ([readstatusobject.readtime isEqualToString:@""]){
            cell.imageview3.hidden=NO;
            [cell.imageview3 setImage:[UIImage imageNamed:@"singlegraycheck_icon.png"]];
            cell.label3.text=[MyClass returntitlewithtitle:@"Unread"];
        }else{
            cell.imageview3.hidden=NO;
            [cell.imageview3 setImage:[UIImage imageNamed:@"singlebluecheck_icon.png"]];
            cell.label3.text=[MyClass convertDateFormatWithDate:[readstatusobject.readtime substringToIndex:10] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
        }
        [cell.imageview1 setImage:globalvariables.boyimage];

    }else if ([datatype isEqualToString:@"ReadStatusLead"]){
        
        static NSString *CellIdentifier = @"readstatuscell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        ReadStatusRecord *readstatusobject=[filtereditemsarray objectAtIndex:indexPath.row];
        cell.label1.text=readstatusobject.recipientname;
        
        cell.label2.text=readstatusobject.recipientid;
        if ([readstatusobject.channel isEqualToString:@"S"]) {
            cell.label3.text=[NSString stringWithFormat:@"%@(SMS)",[MyClass returntitlewithtitle:@"NA"]];
            cell.label3.hidden=NO;
            cell.imageview3.hidden=YES;
        }else{
            cell.label3.text=[NSString stringWithFormat:@"%@(Email)",[MyClass returntitlewithtitle:@"NA"]];
            cell.label3.hidden=NO;
            cell.imageview3.hidden=YES;
        }
        
        Lead *leadobject=[MyClass returnleadwithleadkey:readstatusobject.recipientkey];
        [MyClass downloadImageWithImageview:cell.imageview1 gender:leadobject.gender type:@"lead" typekey:leadobject.studentkey image:leadobject.image async:YES];
    }else if ([datatype isEqualToString:@"classstarttime"] || [datatype isEqualToString:@"classendtime"]){
        static NSString *CellIdentifier = @"labelcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        cell.label1.text=[NSString stringWithFormat:@"%@:%@",[[filtereditemsarray objectAtIndex:indexPath.row] substringToIndex:2],[[filtereditemsarray objectAtIndex:indexPath.row] substringFromIndex:2]];
        cell.imageview2.hidden=![selecteditems containsObject:[filtereditemsarray objectAtIndex:indexPath.row]];
    }else if ([datatype isEqualToString:@"CalendarDay"]){
        static NSString *CellIdentifier = @"labelcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        cell.label1.text=[MyClass returntitlewithtitle:[filtereditemsarray objectAtIndex:indexPath.row]];
        cell.imageview2.hidden=![selecteditems containsObject:[filtereditemsarray objectAtIndex:indexPath.row]];
        
        if([[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@"Working Day"]){
            cell.label1.textColor=[UIColor blackColor];
        }else if([[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@"Holiday"]){
            cell.label1.textColor=[UIColor redColor];
        }else if([[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@"Reserve"]){
            cell.label1.textColor=[UIColor orangeColor];
        }
    }else if ([datatype isEqualToString:@"subjectCategory"]){
        static NSString *CellIdentifier = @"labelcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        SubjectCategoryRecord *obj=[filtereditemsarray objectAtIndex:indexPath.row];

        
        if (indexPath.row==0) {
            cell.label1.text=[MyClass returntitlewithtitle:@"All Categories"];
        }else{
            cell.label1.text=[MyClass returnsubjectcategorynamewithscategorykey:obj.scategorykey];
        }
        
        cell.imageview2.hidden=![selecteditems containsObject:obj.scategorykey];
    }else if ([datatype isEqualToString:@"EvaluationSubject"]){
        static NSString *CellIdentifier = @"subjectcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        SubjectRecord *subjectobj=[filtereditemsarray objectAtIndex:indexPath.row];
        
        cell.label1.text=[MyClass returnsubjectnamewithsubject_shortname:subjectobj.subject_shortname centerkey:globalvariables.centerrecord.centerkey];
        cell.label2.text=subjectobj.subject_shortname;
        
        cell.imageview2.hidden=!([selecteditems containsObject:((SubjectRecord *)[filtereditemsarray objectAtIndex:indexPath.row]).subjectkey] || (selecteditems && selecteditems.count==0));
    }else if ([datatype isEqualToString:@"EvaluationGrade"]){
        static NSString *CellIdentifier = @"labelcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        cell.label1.text=[filtereditemsarray objectAtIndex:indexPath.row];
        
        cell.imageview2.hidden=!([selecteditems containsObject:[filtereditemsarray objectAtIndex:indexPath.row]] || (selecteditems && selecteditems.count==0));
    }else if([datatype isEqualToString:@"quickpay"] && [[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@"Credit Balance"]){
        static NSString *CellIdentifier = @"labelcellblue";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.label1.text=[MyClass returntitlewithtitle:[filtereditemsarray objectAtIndex:indexPath.row]];
        cell.imageview2.hidden=![selecteditems containsObject:[filtereditemsarray objectAtIndex:indexPath.row]];
    }else if([datatype isEqualToString:@"qrcoderefreshfrequency"]){
        static NSString *CellIdentifier = @"labelcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
                
        if ([[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@""]) {
            cell.label1.text=[MyClass returntitlewithtitle:@"Never"];
        }else if ([[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@"PD"]) {
            cell.label1.text=[MyClass returntitlewithtitle:@"Daily"];
        }else if ([[filtereditemsarray objectAtIndex:indexPath.row] isEqualToString:@"PM"]) {
            cell.label1.text=[MyClass returntitlewithtitle:@"Monthly"];
        }else{
            cell.label1.text=[MyClass returnreplacedtitlewithtitle:@"%@1 mins" replacementarray:@[[filtereditemsarray objectAtIndex:indexPath.row]]];
        }

        cell.imageview2.hidden=![selecteditems containsObject:[filtereditemsarray objectAtIndex:indexPath.row]];
    }else{
        static NSString *CellIdentifier = @"labelcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        cell.label1.text=[MyClass returntitlewithtitle:[filtereditemsarray objectAtIndex:indexPath.row]];
        cell.imageview2.hidden=![selecteditems containsObject:[filtereditemsarray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

-(BOOL) isSelectedMessageContact:(MessageContactRecord *)obj
{
    return [selecteditems containsObject:obj];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([datatype isEqualToString:@"EvaluationSubject"]){
        return UITableViewAutomaticDimension;
    }
    return 44;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([datatype isEqualToString:@"ReadStatusDetails"]) {
        return 44;
    }
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedItem;
    if ([datatype isEqualToString:@"countrycode"]) {
        selecteditems=[[NSMutableArray alloc]initWithObjects:((CountryCodeRecord *)[filtereditemsarray objectAtIndex:indexPath.row]).iso_code, nil];
    }else if ([datatype isEqualToString:@"relationship"]){
        selecteditems=[[NSMutableArray alloc]initWithObjects:[filtereditemsarray objectAtIndex:indexPath.row], nil];
    }else if ([datatype isEqualToString:@"colorcode"]){
        selecteditems=[[NSMutableArray alloc]initWithObjects:[@(indexPath.row) stringValue], nil];
    }else if ([datatype isEqualToString:@"colorscheme"]){
        ColorScheme *obj=[filtereditemsarray objectAtIndex:indexPath.row];
        selecteditems=[[NSMutableArray alloc]initWithObjects:obj.colorschemekey, nil];
    }else if ([datatype isEqualToString:@"ReadStatusStudent"] || [datatype isEqualToString:@"ReadStatusLead"]){
        [pickerTable deselectRowAtIndexPath:[pickerTable indexPathForSelectedRow] animated:NO];
        NSMutableArray *readstatusdetailsarray=((ReadStatusRecord *)[filtereditemsarray objectAtIndex:indexPath.row]).contactgroup;
        //MyTableViewCell *cell = (MyTableViewCell *)[pickerTable cellForRowAtIndexPath:indexPath];
        
        [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"ReadStatusDetails" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(300, readstatusdetailsarray.count*40) View:self FromRect:[pickerTable rectForRowAtIndexPath:indexPath] ItemsArray:readstatusdetailsarray Title:nil Tableview:pickerTable];
        return;
    }else if ([datatype isEqualToString:@"ReadStatusDetails"] || [datatype isEqualToString:@"ReadStatusStaff"]){
        return;
    }else if ([datatype isEqualToString:@"MessageContact"]){
        if (multipleSelection) {
            if ([selecteditems containsObject:[filtereditemsarray objectAtIndex:indexPath.row]]) {
                [selecteditems removeObject:[filtereditemsarray objectAtIndex:indexPath.row]];
            }else{
                [selecteditems addObject:[filtereditemsarray objectAtIndex:indexPath.row]];
            }
            [pickerTable reloadData];
        }else{
            selecteditems=[[NSMutableArray alloc]initWithObjects:[filtereditemsarray objectAtIndex:indexPath.row], nil];
            [self.delegate returnPickerValueWithDataType:datatype DataIndex:dataindex SelectedItems:selecteditems Button:button];
        }
        
        return;
    }else if ([datatype isEqualToString:@"subjectCategory"]){
        selecteditems=[[NSMutableArray alloc]initWithObjects:((SubjectCategoryRecord *)[filtereditemsarray objectAtIndex:indexPath.row]).scategorykey, nil];
    }else if ([datatype isEqualToString:@"assessmentscore"]){
        selecteditems=[[NSMutableArray alloc]initWithObjects:[filtereditemsarray objectAtIndex:indexPath.row], nil];
    }else if ([datatype isEqualToString:@"Student"]){
        selecteditems=[[NSMutableArray alloc]initWithObjects:((Student *)[filtereditemsarray objectAtIndex:indexPath.row]).studentkey, nil];
    }else if ([datatype isEqualToString:@"EvaluationSubject"]){
        selectedItem=((SubjectRecord *)[filtereditemsarray objectAtIndex:indexPath.row]).subjectkey;
    }else if ([datatype isEqualToString:@"EvaluationGrade"]){
        selectedItem=[filtereditemsarray objectAtIndex:indexPath.row];
    }else{
        selecteditems=[[NSMutableArray alloc]initWithObjects:[filtereditemsarray objectAtIndex:indexPath.row], nil];
    }

    if(multipleSelection){
//        if ([selecteditems containsObject:selectedItem]) {
//            [selecteditems removeObject:selectedItem];
//        }else{
//            [selecteditems addObject:selectedItem];
//        }
        
        if ([datatype isEqualToString:@"EvaluationSubject"]){
            if (selecteditems && selecteditems.count==0) {
                for (int i=0; i<itemsarray.count; i++) {
                    if (![selectedItem isEqualToString:((SubjectRecord *)[itemsarray objectAtIndex:i]).subjectkey]) {
                        [selecteditems addObject:((SubjectRecord *)[itemsarray objectAtIndex:i]).subjectkey];
                    }
                }
            }else{
                if(!selecteditems){
                    selecteditems=[[NSMutableArray alloc]init];
                }
                if ([selecteditems containsObject:selectedItem]) {
                    [selecteditems removeObject:selectedItem];
                    if(selecteditems.count==0){
                        selecteditems=nil;
                    }
                }else{
                    [selecteditems addObject:selectedItem];
                    if(selecteditems.count==itemsarray.count){
                        selecteditems=[[NSMutableArray alloc]init];
                    }
                }
            }
        }else if ([datatype isEqualToString:@"EvaluationGrade"]){
            if (selecteditems && selecteditems.count==0) {
                for (int i=0; i<itemsarray.count; i++) {
                    if (![selectedItem isEqualToString:[itemsarray objectAtIndex:i]]) {
                        [selecteditems addObject:[itemsarray objectAtIndex:i]];
                    }
                }
            }else{
                if(!selecteditems){
                    selecteditems=[[NSMutableArray alloc]init];
                }
                if ([selecteditems containsObject:selectedItem]) {
                    [selecteditems removeObject:selectedItem];
                    if(selecteditems.count==0){
                        selecteditems=nil;
                    }
                }else{
                    [selecteditems addObject:selectedItem];
                    if(selecteditems.count==itemsarray.count){
                        selecteditems=[[NSMutableArray alloc]init];
                    }
                }
            }
        }
        
        
        
        
        [pickerTable reloadData];
        [self.delegate returnPickerValueWithDataType:datatype DataIndex:dataindex SelectedItems:selecteditems Button:button];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.delegate returnPickerValueWithDataType:datatype DataIndex:dataindex SelectedItems:selecteditems Button:button];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self returnFiltereditemsarray];
    
    if (filtereditemsarray.count>0) {
        [pickerTable setScrollsToTop:YES];
    }
}

-(void) returnFiltereditemsarray
{
    
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (![searchbar.text isEqualToString:@""]) {
        if ([datatype isEqualToString:@"countrycode"]) {
            newCondition = [NSPredicate predicateWithFormat:@"SELF.iso_code contains[c] %@ or self.country_name contains[c] %@ or self.country_code contains[c] %@",searchbar.text,searchbar.text,searchbar.text];
        }else if ([datatype isEqualToString:@"MessageContact"]){
            newCondition = [NSPredicate predicateWithFormat:@"SELF.messagecontact contains[c] %@ or self.messagecontactdisplayname contains[c] %@ or self.messagecontacttype contains[c] %@",searchbar.text,searchbar.text,searchbar.text];
        }else if ([datatype isEqualToString:@"ReadStatusStudent"] || [datatype isEqualToString:@"ReadStatusLead"] || [datatype isEqualToString:@"ReadStatusStaff"]){
            newCondition = [NSPredicate predicateWithFormat:@"self.recipientname contains[c] %@ or self.recipientid contains[c] %@ or self.recipientkey contains[c] %@",searchbar.text,searchbar.text,searchbar.text];
        }else if ([datatype isEqualToString:@"Student"]){
            newCondition = [NSPredicate predicateWithBlock:^BOOL(Student *object, NSDictionary *bindings) {
                NSString *studentfullname=[MyClass returnStudentnameWithStudentkey:object.studentkey option:@"full"];
                NSString *studentid=((Student *)[MyClass returnstudentwithstudentkey:object.studentkey]).studentid;
                return [studentfullname rangeOfString:searchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [studentid rangeOfString:searchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound;
            }];
        }else if ([datatype isEqualToString:@"EvaluationSubject"]){
            newCondition = [NSPredicate predicateWithBlock:^BOOL(SubjectRecord *object, NSDictionary *bindings) {
                return [object.subject_shortname rangeOfString:searchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.subject_chinesename rangeOfString:searchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.subject_englishname rangeOfString:searchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound;
            }];
        }else{
            newCondition = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchbar.text];
        }
        
        [nsPredicatearray addObject:newCondition];
        
    }

    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filtereditemsarray= [[NSMutableArray alloc]initWithArray:[itemsarray filteredArrayUsingPredicate:predicate]];
    }else{
        filtereditemsarray= [[NSMutableArray alloc]initWithArray:itemsarray];
    }
    [pickerTable reloadData];
}



- (IBAction)bottombuttonpressed:(id)sender {
    if ([datatype isEqualToString:@"MessageContact"]) {
        [self.delegate pickerBottomButtonPressedWithDataType:datatype DataIndex:dataindex BottomMode:bottommode SelectedItems:selecteditems];
    }else if ([datatype isEqualToString:@"EvaluationSubject"]) {
        if ([bottommode isEqualToString:@"All"]) {
            selecteditems=[[NSMutableArray alloc]init];
            [self.delegate returnPickerValueWithDataType:datatype DataIndex:dataindex SelectedItems:selecteditems Button:button];
        }
        [pickerTable reloadData];
    }else if ([datatype isEqualToString:@"EvaluationGrade"]) {
        if ([bottommode isEqualToString:@"All"]) {
            selecteditems=[[NSMutableArray alloc]init];
            [self.delegate returnPickerValueWithDataType:datatype DataIndex:dataindex SelectedItems:selecteditems Button:button];
        }
        [pickerTable reloadData];
    }else{
        [self.delegate pickerBottomButtonPressedWithDataType:datatype DataIndex:dataindex BottomMode:bottommode SelectedItems:selecteditems];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)bottombutton2pressed:(id)sender {
    if ([datatype isEqualToString:@"EvaluationSubject"]) {
        selecteditems=nil;
        [self.delegate returnPickerValueWithDataType:datatype DataIndex:dataindex SelectedItems:selecteditems Button:button];
        [pickerTable reloadData];
    }else if ([datatype isEqualToString:@"EvaluationGrade"]) {
        selecteditems=nil;
        [self.delegate returnPickerValueWithDataType:datatype DataIndex:dataindex SelectedItems:selecteditems Button:button];
        [pickerTable reloadData];
    }
}

- (IBAction)readstatusdetailsbuttonpressed:(id)sender {
}

-(NSString *) returnreadstatussummarywithcontactgrouparray:(NSMutableArray *)contactgrouparray
{
    BOOL NA=TRUE;
    BOOL AR=TRUE;
    BOOL NR=TRUE;
    
    for (int i=0; i<contactgrouparray.count; i++) {
        if ([((ReadStatusRecord *)[contactgrouparray objectAtIndex:i]).channel isEqualToString:@"A"]) {
            NA=FALSE;
            if ([((ReadStatusRecord *)[contactgrouparray objectAtIndex:i]).readtime isEqualToString:@""]) {
                AR=FALSE;
                if (!NR) {
                    break;
                }
            }else{
                NR=FALSE;
                if (!AR) {
                    break;
                }
            }
        }
    }
    
    if (NA) {
        return @"NA";
    }else{
        if (NR) {
            return @"NR";
        }else if (AR) {
            return @"AR";
        }else{
            return @"SR";
        }
    }
}

@end
