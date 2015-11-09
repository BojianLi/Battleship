//
//  twoPlayersGameViewController.m
//  Battleship
//
//  Created by Labuser on 11/4/15.
//  Copyright (c) 2015 wustl. All rights reserved.
//

#import "twoPlayersGameViewController.h"

@interface twoPlayersGameViewController ()
@property Game *game;
@property Player *me;
@property Player *opo;
@property UIView *gridView;
@property (strong, nonatomic) IBOutlet UILabel *turnLabel;
@property (strong, nonatomic) IBOutlet UIButton *viewYourShips;
@property (strong, nonatomic) IBOutlet UILabel *player1Ship;
@property (strong, nonatomic) IBOutlet UILabel *player2Ship;
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UILabel *label2;


@end

@implementation twoPlayersGameViewController
#define delayTime 0.5
float gameGridsize;
int gameSize;
BOOL disable;

- (void)viewDidLoad {
    [super viewDidLoad];
    gameSize = 10;
    gameGridsize = 64;
    self.gridView = [[UIView alloc] initWithFrame:CGRectMake(25, 50, gameGridsize * gameSize, gameGridsize * gameSize)];
    [self.view addSubview: self.gridView];
    self.game = [Game getGame];
    [self drawScreen];
    
}
-(void)drawScreen {
    if (self.game.whoWinTheGame != 0) {
        self.turnLabel.text = [NSString stringWithFormat:@"Player %d win the game!!!!",self.game.whoWinTheGame];
        self.viewYourShips.hidden = YES;
        self.label1.hidden = YES;
        self.label2.hidden = YES;
        self.player1Ship.hidden = YES;
        self.player2Ship.hidden = YES;
        return;
    }
    if (self.game.setting.mode == 0) {
        if (self.game.setting.playTurn == 1) {
            self.viewYourShips.hidden = YES;
        } else {
            self.viewYourShips.hidden = NO;
        }
    }
    

    
    disable = NO;
    
    if (self.game.setting.playTurn == 0) {
        self.me = self.game.player1;
        self.opo = self.game.player2;
    } else {
        self.me = self.game.player2;
        self.opo = self.game.player1;
    }
    self.turnLabel.text = [NSString stringWithFormat:@"Player %d's turn to play",self.game.setting.playTurn + 1];
    self.player1Ship.text = [NSString stringWithFormat:@"%d",self.game.player1.playerNumOfShip];
    self.player2Ship.text = [NSString stringWithFormat:@"%d",self.game.player2.playerNumOfShip];
    for (int i = 0; i <  gameSize; i++) {
        for (int j = 0; j < gameSize; j++) {
            UIButton *grid = [[UIButton alloc] init];
            grid.tag = i * gameSize + j;//its position on the board
            if ([self.opo.board[i][j] isEqual:@1]) {//miss
                [grid setBackgroundColor:[UIColor greenColor]];
//                [grid setTitle:@"O" forState:UIControlStateNormal];
            } else if ([self.opo.board[i][j] isEqual:@2]) {//hitted
                [grid setBackgroundColor:[UIColor redColor]];
//                [grid setTitle:@"X" forState:UIControlStateNormal];
            } else {//no action
                [grid setBackgroundColor:[UIColor blueColor]];
            }
            grid.layer.borderWidth = 1;
            grid.layer.borderColor =[UIColor blackColor].CGColor;
            [grid addTarget:self action:@selector(fire:) forControlEvents:UIControlEventTouchUpInside];
//            grid.frame = CGRectMake( gameGridsize * i + 25, gameGridsize * j + 50, gameGridsize, gameGridsize);
            grid.frame = CGRectMake( gameGridsize * i, gameGridsize * j, gameGridsize, gameGridsize);
            [self.gridView addSubview: grid];
        }
    }
    if (self.game.setting.mode == 0 && self.game.setting.playTurn == 1) {
        disable = YES;
    }
    for (Ship *ship in self.opo.ships) {
        if (ship.remaining == 0) {
            UIImageView *image = ship.d;
            image.alpha = 0.8;
            if (ship.rotated) {
                image.transform = CGAffineTransformMakeRotation(M_PI_2);
            }
 //           image.frame = CGRectMake( ship.startX * gameGridsize + 25, ship.startY * gameGridsize + 50, image.frame.size.width, image.frame.size.height);
 //           [self.view addSubview:image];
            image.frame = CGRectMake( ship.startX * gameGridsize, ship.startY * gameGridsize, image.frame.size.width, image.frame.size.height);
            [self.gridView addSubview:image];
        }
    }
    
    //AIMove
    if (self.game.setting.mode == 0 && self.game.setting.playTurn == 1) {
        double delayInSeconds = delayTime;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            int position = 0;
            do {
                position = [self.opo AIPlay];
            } while (![self AIFireAt:position / gameSize and:position % gameSize]);
        });
    }
    
    
}
-(void)fire:(UIButton *) button {
    if (disable) {
        return;
    }
    int i = button.tag / gameSize;
    int j = button.tag % gameSize;
    int value = [self.opo.board[i][j] integerValue];
    if (value == 1 || value == 2) {
        return;
    }
    disable = YES;
    if (value == 0) {
        self.opo.board[i][j] = @1;//miss
        [button setBackgroundColor:[UIColor greenColor]];
    } else {
        int idOfShip = [self.opo.board[i][j] integerValue];
        [self.opo hitted:idOfShip];
        self.opo.board[i][j] = @2;//hit
        [button setBackgroundColor:[UIColor redColor]];
    }
    for (Ship *ship in self.opo.ships) {
        if (ship.remaining == 0) {
            UIImageView *image = ship.d;
            image.alpha = 0.8;
            if (ship.rotated) {
                image.transform = CGAffineTransformMakeRotation(M_PI_2);
            }
//            image.frame = CGRectMake( ship.startX * gameGridsize + 25, ship.startY * gameGridsize + 50, image.frame.size.width, image.frame.size.height);
//            [self.view addSubview:image];
            image.frame = CGRectMake( ship.startX * gameGridsize, ship.startY * gameGridsize, image.frame.size.width, image.frame.size.height);
            [self.gridView addSubview:image];
        }
    }
    self.game.setting.playTurn = 1 - self.game.setting.playTurn;
    double delayInSeconds = delayTime;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (UIView *v in [self.gridView subviews]) {
            [v removeFromSuperview];
        }
        [self drawScreen];
    });
}
-(BOOL)AIFireAt:(int)i and:(int)j {
    int value = [self.opo.board[i][j] integerValue];
    if (value == 1 || value == 2) {
        return NO;
    }
    UIButton *grid = [[UIButton alloc] init];
    if (value == 0) {
        self.opo.board[i][j] = @1;//miss
        [grid setBackgroundColor:[UIColor greenColor]];
    } else {
        int idOfShip = [self.opo.board[i][j] integerValue];
        [self.opo hitted:idOfShip];
        self.opo.board[i][j] = @2;//hit
        [grid setBackgroundColor:[UIColor redColor]];
    }
    [grid setTitle:@"" forState:UIControlStateNormal];
    grid.layer.borderWidth = 1;
    grid.layer.borderColor =[UIColor blackColor].CGColor;
    grid.frame = CGRectMake( gameGridsize * i, gameGridsize * j, gameGridsize, gameGridsize);
    [self.gridView addSubview:grid];
    for (Ship *ship in self.opo.ships) {
        if (ship.remaining == 0) {
            UIImageView *image = ship.d;
            image.alpha = 0.8;
            if (ship.rotated) {
                image.transform = CGAffineTransformMakeRotation(M_PI_2);
            }
            image.frame = CGRectMake( ship.startX * gameGridsize, ship.startY * gameGridsize, image.frame.size.width, image.frame.size.height);
            [self.gridView addSubview:image];
        }
    }
    self.game.setting.playTurn = 1 - self.game.setting.playTurn;
    double delayInSeconds = delayTime;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (UIView *v in [self.gridView subviews]) {
            [v removeFromSuperview];
        }
        [self drawScreen];
    });
    return YES;
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
