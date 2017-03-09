//
//  MonthSelectionVC.h
//  TrackMiles
//
//  Created by Jahangir on 6/14/16.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthSelectionVC : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickr;
@property (nonatomic) NSInteger seelctedIndex;
- (IBAction)doneBtnPressed:(id)sender;
@end
