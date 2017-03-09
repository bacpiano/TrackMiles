//
//  AddJobVC.h
//  TrackMiles
//
//  Created by Jahangir on 6/4/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddJobVC : UIViewController<UITextFieldDelegate>

@property (nonatomic,strong) Job *job;

@property (weak, nonatomic) IBOutlet UITextField *txtField;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

- (IBAction)addBtnPressed:(id)sender;
@end
