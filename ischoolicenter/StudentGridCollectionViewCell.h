//
//  StudentGridCollectionViewCell.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 15/1/15.
//  Copyright (c) 2015 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol myStudentGridCollectionViewCellDelegate <NSObject>

-(void) copycancelbuttonpressed:(UIButton *)sender;
-(void) copyokbuttonpressed:(UIButton *)sender;
-(void) informationbuttonpressed:(UIButton *)sender;

@end

@interface StudentGridCollectionViewCell : UICollectionViewCell{

}

@property (strong, nonatomic) IBOutlet UILabel *studentnamelabel;
@property (strong, nonatomic) IBOutlet UIImageView *studentimage;
@property (strong, nonatomic) IBOutlet UIButton *informationbutton;
@property (strong, nonatomic) IBOutlet UIButton *okbutton;
@property (strong, nonatomic) IBOutlet UIButton *cancelbutton;
@property (strong, nonatomic) IBOutlet UILabel *errormessagelabel;
@property (strong, nonatomic) IBOutlet UIView *messageview;
@property (weak,nonatomic) id<myStudentGridCollectionViewCellDelegate>delegate;

- (IBAction)okbuttonpressed:(id)sender;
- (IBAction)cancelbuttonpressed:(id)sender;
- (IBAction)informationbuttonpressed:(id)sender;

@end
