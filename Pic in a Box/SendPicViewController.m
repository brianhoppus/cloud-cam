//
//  SendPicViewController.m
//  Pic in a Box
//
//  Created by Brian Saunders on 1/31/15.
//  Copyright (c) 2015 Brian Saunders. All rights reserved.
//

#import "SendPicViewController.h"

@interface SendPicViewController ()

@end

@implementation SendPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.imageView.image = self.image;
    [self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.image = image;
    }

    return self;
}

- (IBAction)uploadPicture:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
