//
//  Created by Dariusz Rybicki on 25/04/15.
//  Copyright (c) 2015 Darrarski. All rights reserved.
//

#import "ViewController.h"
#import "DRCircularProgressView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet DRCircularProgressView *progressView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.progressView.progressValue = 0.f;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self animateProgress];
}

- (void)animateProgress
{
    [UIView animateWithDuration:3
                     animations:^{
                         self.progressView.progressValue = 1.f;
                     }
                     completion:^(BOOL finished1) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             [UIView animateWithDuration:3
                                              animations:^{
                                                  self.progressView.progressValue = 0.f;
                                              }
                                              completion:^(BOOL finished2) {
                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                      [self animateProgress];
                                                  });
                                              }];
                         });
                     }];
}

@end
