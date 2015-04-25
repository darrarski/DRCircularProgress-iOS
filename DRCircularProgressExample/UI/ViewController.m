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

    self.progressView.progressValue = 0.667f;
}

@end
