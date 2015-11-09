//
//  LaunchingViewController.m
//  Battleship
//
//  Created by Labuser on 11/4/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import "LaunchingViewController.h"
@interface LaunchingViewController ()
@end

@implementation LaunchingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playWithAi:(UIButton *)sender {
    [Game resetWithMode:0];
    [self performSegueWithIdentifier:@"AI" sender:sender];
}
- (IBAction)passNPlay:(UIButton *)sender {
    [Game resetWithMode:1];
    [self performSegueWithIdentifier:@"pass" sender:sender];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

