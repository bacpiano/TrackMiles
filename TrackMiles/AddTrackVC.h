//
//  AddTrackVC.h
//  TrackMiles
//
//  Created by Jahangir on 6/4/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTrackVC : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong) Job *job;
@property (nonatomic,strong) Track *track;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickr;
@property (weak, nonatomic) IBOutlet UILabel *lblStartUnit;
@property (weak, nonatomic) IBOutlet UILabel *lblEndUnit;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UITextField *txtStart;
@property (weak, nonatomic) IBOutlet UITextField *txtEnd;
- (IBAction)saveBtnPressed:(id)sender;

@end
