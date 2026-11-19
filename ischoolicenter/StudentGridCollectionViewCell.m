//
//  StudentGridCollectionViewCell.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 15/1/15.
//  Copyright (c) 2015 Dreamware Limited. All rights reserved.
//

#import "StudentGridCollectionViewCell.h"
#import "MyClass.h"

@implementation StudentGridCollectionViewCell
@synthesize studentnamelabel,studentimage,informationbutton,okbutton,cancelbutton,messageview,errormessagelabel;


- (IBAction)okbuttonpressed:(id)sender {
    [self.delegate copyokbuttonpressed:sender];
}

- (IBAction)cancelbuttonpressed:(UIButton *)sender {
    [self.delegate copycancelbuttonpressed:sender];
}

- (IBAction)informationbuttonpressed:(id)sender {
    [self.delegate informationbuttonpressed:sender];
}

@end
