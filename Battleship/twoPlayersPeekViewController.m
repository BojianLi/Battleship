//
//  twoPlayersPeekViewController.m
//  Battleship
//
//  Created by Labuser on 11/4/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//


#import "twoPlayersPeekViewController.h"

@interface twoPlayersPeekViewController ()
@property Game *game;
@property Player *player;
@property (strong, nonatomic) IBOutlet UILabel *turnLabel;

@end

@implementation twoPlayersPeekViewController
float peekGridsize;
int peekSize;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.game = [Game getGame];
    if (self.game.setting.playTurn == 0) {
        self.player = self.game.player1;
    } else {
        self.player = self.game.player2;
    }
    self.turnLabel.text = [NSString stringWithFormat:@"Player %d's ships",self.game.setting.playTurn + 1];
    peekSize = 10;
    peekGridsize = 64;
    for (int i = 0; i <  peekSize; i++) {
        for (int j = 0; j < peekSize; j++) {
            UIButton *grid = [[UIButton alloc] init];
            grid.tag = i * peekSize + j;//its position on the board
            int value = [self.player.board[i][j] integerValue];
            if (value == 1) {//miss
                [grid setBackgroundColor:[UIColor greenColor]];
//                [grid setTitle:@"O" forState:UIControlStateNormal];
            } else if (value == 2) {//hitted
                [grid setBackgroundColor:[UIColor redColor]];
//                [grid setTitle:@"X" forState:UIControlStateNormal];
            } else if (value >= 10){//ships
                [grid setBackgroundColor:[UIColor grayColor]];
            } else {//empty slot
                [grid setBackgroundColor:[UIColor blueColor]];
            }
            grid.layer.borderWidth = 1;
            grid.layer.borderColor =[UIColor blackColor].CGColor;
            grid.frame = CGRectMake( peekGridsize * i + 25, peekGridsize * j + 50, peekGridsize, peekGridsize);
            [self.view addSubview:grid];
        }
    }
    for (Ship *ship in self.player.ships) {
        UIImageView *image;
        if (ship.remaining == 0) {
            image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ship.destroyedImage]];
            image.alpha = 0.8;
        } else {
            image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:ship.image]];
            image.alpha = 0.5;
        }
        if (ship.rotated) {
            image.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        image.frame = CGRectMake( ship.startX * peekGridsize + 25, ship.startY * peekGridsize + 50, image.frame.size.width, image.frame.size.height);
        [self.view addSubview:image];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
