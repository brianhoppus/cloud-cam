//
//  SettingsViewController.h
//  Pic in a Box
//
//  Created by Brian Saunders on 1/31/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *dropboxLinkButton;
@property (weak, nonatomic) IBOutlet UIButton *syncSettingButton;
@property (weak, nonatomic) IBOutlet UIButton *resolutionPickerButton;

- (IBAction)closeSettings:(id)sender;
- (IBAction)connectToDropbox:(id)sender;
- (IBAction)chooseSyncFolder:(id)sender;
- (IBAction)changeNetworkSyncSetting:(id)sender;
- (IBAction)changePictureResolution:(id)sender;

@end
