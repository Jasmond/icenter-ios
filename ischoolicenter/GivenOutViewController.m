//
//  GivenOutViewController.m
//  iCenter
//
//  Created by Jasmond Luk on 31/3/2022.
//  Copyright © 2022 DreamHigh Company Limited. All rights reserved.
//

#import "GivenOutViewController.h"
#import "MyTableViewCell.h"

@interface GivenOutViewController ()

@end

@implementation GivenOutViewController
@synthesize salesrecords;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    NSString *productcode=((SalesRecord *)salesrecords[0]).productcode;
    productobject=[MyClass returnProductInformationWithCode:productcode centerkey:globalvariables.centerrecord.centerkey];
    
//    self.preferredContentSize=CGSizeMake(400, 600);
    [selectallbutton setTitle:[MyClass returntitlewithtitle:@"Select all"] forState:UIControlStateNormal];
    [deselectallbutton setTitle:[MyClass returntitlewithtitle:@"Deselect all"] forState:UIControlStateNormal];
    [updatebutton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    
    selectedSaleskeys=[[NSMutableArray alloc]init];
    [self returnFilteredItemArray];
    
    [itemtable reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) returnFilteredItemArray
{
//    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
//    if (![searchField.stringValue isEqualToString:@""]) {
//        newCondition = [NSPredicate predicateWithFormat:@"SELF.remarks contains[c] %@",searchField.stringValue];
//        [nsPredicatearray addObject:newCondition];
//    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredSalesRecord= [[NSMutableArray alloc]initWithArray:[salesrecords filteredArrayUsingPredicate:predicate]];
    }else{
        filteredSalesRecord= [[NSMutableArray alloc]initWithArray:salesrecords];
    }
    
    NSSortDescriptor *sortbystudentname = [NSSortDescriptor sortDescriptorWithKey:@"remarks" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[sortbystudentname];
    filteredSalesRecord=[NSMutableArray arrayWithArray:[filteredSalesRecord sortedArrayUsingDescriptors:sortDescriptors]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return filteredSalesRecord.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *blankcell = @"itemcell";
    MyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:blankcell];
    
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blankcell];
    }
    SalesRecord *object=[filteredSalesRecord objectAtIndex:indexPath.row];
    [MyClass downloadImageWithImageview:cell.imageview2 gender:nil type:@"student" typekey:object.studentkey image:@"Yes" async:YES];
    cell.label1.text=object.remarks;
    cell.label2.text=[NSString stringWithFormat:@"%@: %d",[MyClass returntitlewithtitle:@"Yet Given"],[object.quantity intValue]-[object.givenout intValue]];

    if(![selectedSaleskeys containsObject:object.saleskey]){
        cell.imageview1.layer.opacity=0.3;
    }else{
        cell.imageview1.layer.opacity=1;
    }
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    SalesRecord *sales=[filteredSalesRecord objectAtIndex:indexPath.row];
    if ([selectedSaleskeys containsObject:sales.saleskey]) {
        //deselect
        [selectedSaleskeys removeObject:sales.saleskey];
    }else{
        //select if stock is sufficient
        if ([productobject.stockcount integerValue]>=[self totalgivenoutstockcount]+[sales.quantity intValue]-[sales.givenout intValue]) {
            [selectedSaleskeys addObject:sales.saleskey];
        }else{
            [self showWarning];
        }
    }
    
    [itemtable reloadData];

}

- (IBAction)updatebuttonpressed:(id)sender {
    
    [self.delegate returnSelectedSaleskeysForYetGivenOutOrder:selectedSaleskeys];
}

- (IBAction)deselectallbuttonpressed:(id)sender {
    
    selectedSaleskeys=[[NSMutableArray alloc]init];
    [itemtable reloadData];
    
    
}

- (IBAction)selectallbuttonpressed:(id)sender {
    BOOL showwarning=FALSE;
    for (int i=0; i<salesrecords.count; i++) {
        SalesRecord *sales=[salesrecords objectAtIndex:i];
        if(![selectedSaleskeys containsObject:sales.saleskey]){
            if ([productobject.stockcount integerValue]>=[self totalgivenoutstockcount]+[sales.quantity intValue]-[sales.givenout intValue]) {
                [selectedSaleskeys addObject:sales.saleskey];
            }else{
                showwarning=TRUE;
            }
        }
    }
    [itemtable reloadData];
    
    if(showwarning){
        [self showWarning];
    }
}

-(void) showWarning
{
    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Inventory"] message:[MyClass returntitlewithtitle:@"Insufficient stock available!"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [erroralert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [erroralert addAction:OKAction];
    [self presentViewController:erroralert animated:YES completion:nil];
}

-(NSInteger) totalgivenoutstockcount
{
    NSInteger stockcount=0;
    for (int i=0; i<salesrecords.count; i++) {
        SalesRecord *obj=[salesrecords objectAtIndex:i];
        if ([selectedSaleskeys containsObject:obj.saleskey]) {
            stockcount+=[obj.quantity intValue]-[obj.givenout intValue];
        }
    }
    return stockcount;
}

@end
