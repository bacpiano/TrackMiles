//
//  HistoryVC.h
//  TrackMiles
//
//  Created by Adrian Borcea Saeed on 22/06/2016.
//  Copyright © 2016 Adrian Borcea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SWTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnTrash;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnShare;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;

@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;

- (IBAction)trashBtnPressed:(id)sender;
- (IBAction)shareBtnPressed:(id)sender;

- (IBAction)leftBtnPressed:(id)sender;
- (IBAction)rightBtnPressed:(id)sender;

@end
