//
//  twoPlayersViewController.m
//  Battleship
//
//  Created by Bojian Li on 10/31/15.
//  Copyright © 2015 Bojian Li. All rights reserved.
//

#import "twoPlayersViewController.h"

@interface twoPlayersViewController ()
@property Game *game;
@property Player *player;

@property UIImageView *ship5;
@property UIImageView *ship4;
@property UIImageView *ship3a;
@property UIImageView *ship3b;
@property UIImageView *ship2;
@property UIView *theMoveingView;
@property CGPoint oldCenter;
-(void)dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event;
-(void)dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position;
-(void)dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position;
@end

@implementation twoPlayersViewController
#define ROTATE_ANIMATION_DURATION_SECONDS 0.15    // Determines how fast a piece size grows when it is moved.
#define MOVE_ANIMATION_DURATION_SECONDS 0.15  // Determines how fast a piece size shrinks when a piece stops moving.
float gridsize;
int size;
int oldX;
int oldY;
int shipLenth;
int currentShip;
BOOL rotated;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.game = [Game getGame];
    if (self.game.setting.playTurn == 0) {
        self.player = self.game.player1;
    } else {
        self.player = self.game.player2;
    }
    self.turnLabel.text = [NSString stringWithFormat:@"Player %d's turn to deploy",self.game.setting.playTurn + 1];
    size = 10;
    gridsize = 64;
    for (int i = 0; i <  size; i++) {
        for (int j = 0; j < size; j++) {
            UIImageView *grid = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gridsmall.png"]];
            grid.frame = CGRectMake( grid.frame.size.width * i + 25, grid.frame.size.height * j + 50, grid.frame.size.width, grid.frame.size.height);
            [self.view addSubview:grid];
        }
    }
    if (!self.ship5) {
        self.ship5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ship5.png"]];
        self.ship5.alpha = 0.8;
        self.ship5.frame = CGRectMake(25, 50, self.ship5.frame.size.width, self.ship5.frame.size.height);
    }
    if (!self.ship4) {
        self.ship4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ship4.png"]];
        self.ship5.alpha = 0.8;
        self.ship4.frame = CGRectMake(gridsize + 25, 50, self.ship4.frame.size.width, self.ship4.frame.size.height);
    }
    if (!self.ship3a) {
        self.ship3a = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ship3.png"]];
        self.ship5.alpha = 0.8;
        self.ship3a.frame = CGRectMake(gridsize * 2 + 25, 50, self.ship3a.frame.size.width, self.ship3a.frame.size.height);
    }
    if (!self.ship3b) {
        self.ship3b = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ship3.png"]];
        self.ship5.alpha = 0.8;
        self.ship3b.frame = CGRectMake(gridsize * 3 + 25, 50, self.ship3b.frame.size.width, self.ship3b.frame.size.height);
    }
    if (!self.ship2) {
        self.ship2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ship2.png"]];
        self.ship5.alpha = 0.8;
        self.ship2.frame = CGRectMake(gridsize * 4 + 25, 50, self.ship2.frame.size.width, self.ship2.frame.size.height);
    }
    
    [self.view addSubview:self.ship5];
    [self.view addSubview:self.ship4];
    [self.view addSubview:self.ship3a];
    [self.view addSubview:self.ship3b];
    [self.view addSubview:self.ship2];
}
// Handles the start of a touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSUInteger numTaps = [[touches anyObject] tapCount];
    if (numTaps == 2) {
        for (UITouch *touch in touches) {
            // Send to the dispatch method, which will make sure the appropriate subview is acted upon
            [self rotate:[touch locationInView:self.view] forEvent:nil];
        }
    } else {
        for (UITouch *touch in touches) {
            // Send to the dispatch method, which will make sure the appropriate subview is acted upon
            [self dispatchFirstTouchAtPoint:[touch locationInView:self.view] forEvent:nil];
        }
    }
}

// Checks to see which view, or views, the point is in and then calls a method to perform the opening animation,
// which  makes the piece slightly larger, as if it is being picked up by the user.
-(void)rotateHelper:(int)num{
    self.oldCenter = self.theMoveingView.center;
    oldX = (self.theMoveingView.frame.origin.x - 25) / gridsize;
    oldY = (self.theMoveingView.frame.origin.y - 50) / gridsize;
    Ship* ship = self.player.ships[num];
    rotated = ship.rotated;
    shipLenth = ship.size;
    currentShip = 10 + num;
    for (int i = 0; i < shipLenth; i++) {
        if (rotated) {
            self.player.board[oldX + i][oldY] = @0;
        } else {
            self.player.board[oldX][oldY + i] = @0;
        }
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ROTATE_ANIMATION_DURATION_SECONDS];
    if (ship.rotated) {
        self.theMoveingView.transform = CGAffineTransformMakeRotation(0);
        ship.rotated = NO;
    } else {
        self.theMoveingView.transform = CGAffineTransformMakeRotation(M_PI_2);
        ship.rotated = YES;
    }
    //move to the proper position
    float x = self.theMoveingView.frame.origin.x;
    float y = self.theMoveingView.frame.origin.y;
    int xx = (x - 25 + gridsize / 2) / gridsize;
    int yy = (y - 50 + gridsize / 2) / gridsize;
    self.theMoveingView.center = CGPointMake(xx * gridsize + 25 + self.theMoveingView.frame.size.width / 2, yy * gridsize + 50 + self.theMoveingView.frame.size.height / 2);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ROTATE_ANIMATION_DURATION_SECONDS / 2];
    for (int i = 0; i < shipLenth; i++) {
        if (ship.rotated) {
            if (xx + i < 0 || xx + i >= 10 || yy < 0 || yy >= 10 || ![self.player.board[xx + i][yy]  isEqual: @0]) {
                for (int i = 0; i < shipLenth; i++) {
                    self.player.board[oldX][oldY + i] = [NSNumber numberWithInt:currentShip];
                }
                self.theMoveingView.transform = CGAffineTransformMakeRotation(0);
                ship.rotated = NO;
                self.theMoveingView.center = self.oldCenter;
                [UIView commitAnimations];
                self.theMoveingView = nil;
                return;
            }
        } else {
            if (yy + i < 0 || yy + i >= 10 || xx < 0 || xx >= 10 || ![self.player.board[xx][yy + i]  isEqual: @0]) {
                for (int i = 0; i < shipLenth; i++) {
                    self.player.board[oldX + i][oldY] = [NSNumber numberWithInt:currentShip];
                }
                self.theMoveingView.transform = CGAffineTransformMakeRotation(M_PI_2);
                ship.rotated = YES;
                self.theMoveingView.center = self.oldCenter;
                [UIView commitAnimations];
                self.theMoveingView = nil;
                return;
            }
        }
    }
    for (int i = 0; i < shipLenth; i++) {
        if (ship.rotated) {
            self.player.board[xx + i][yy] = [NSNumber numberWithInt:currentShip];
        } else {
            self.player.board[xx][yy + i] = [NSNumber numberWithInt:currentShip];
        }
    }
    ship.startX = xx;
    ship.startY = yy;
    self.theMoveingView = nil;
    [UIView commitAnimations];
}

-(void)rotate:(CGPoint)touchPoint forEvent:(UIEvent *)event
{
    if (CGRectContainsPoint([self.ship5 frame], touchPoint)) {
        self.theMoveingView = self.ship5;
        [self rotateHelper:0];
    } else if (CGRectContainsPoint([self.ship4 frame], touchPoint)) {
        self.theMoveingView = self.ship4;
        [self rotateHelper:1];
    } else if (CGRectContainsPoint([self.ship3a frame], touchPoint)) {
        self.theMoveingView = self.ship3a;
        [self rotateHelper:2];
    } else if (CGRectContainsPoint([self.ship3b frame], touchPoint)) {
        self.theMoveingView = self.ship3b;
        [self rotateHelper:3];
    } else if (CGRectContainsPoint([self.ship2 frame], touchPoint)) {
        self.theMoveingView = self.ship2;
        [self rotateHelper:4];
    }
}
-(void)firstTouchHelper:(CGPoint)touchPoint withNum:(int)num{
    self.oldCenter = self.theMoveingView.center;
    oldX = (self.theMoveingView.frame.origin.x - 25) / gridsize;
    oldY = (self.theMoveingView.frame.origin.y - 50) / gridsize;
    Ship* ship = self.player.ships[num];
    rotated = ship.rotated;
    shipLenth = ship.size;
    currentShip = 10 + num;
    for (int i = 0; i < shipLenth; i++) {
        if (rotated) {
            self.player.board[oldX + i][oldY] = @0;
        } else {
            self.player.board[oldX][oldY + i] = @0;
        }
    }
    self.theMoveingView.center = touchPoint;
}
-(void)dispatchFirstTouchAtPoint:(CGPoint)touchPoint forEvent:(UIEvent *)event
{
    if (CGRectContainsPoint([self.ship5 frame], touchPoint)) {
        self.theMoveingView = self.ship5;
        [self firstTouchHelper:touchPoint withNum:0];
    } else if (CGRectContainsPoint([self.ship4 frame], touchPoint)) {
        self.theMoveingView = self.ship4;
        [self firstTouchHelper:touchPoint withNum:1];
    } else if (CGRectContainsPoint([self.ship3a frame], touchPoint)) {
        self.theMoveingView = self.ship3a;
        [self firstTouchHelper:touchPoint withNum:2];
    } else if (CGRectContainsPoint([self.ship3b frame], touchPoint)) {
        self.theMoveingView = self.ship3b;
        [self firstTouchHelper:touchPoint withNum:3];
    } else if (CGRectContainsPoint([self.ship2 frame], touchPoint)) {
        self.theMoveingView = self.ship2;
        [self firstTouchHelper:touchPoint withNum:4];
    }
    
}

// Handles the continuation of a touch.
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Enumerates through all touch objects
    for (UITouch *touch in touches) {
        // Send to the dispatch method, which will make sure the appropriate subview is acted upon
        [self dispatchTouchEvent:[touch view] toPosition:[touch locationInView:self.view]];
    }
}

// Checks to see which view, or views, the point is in and then sets the center of each moved view to the new postion.
// If views are directly on top of each other, they move together.
-(void)dispatchTouchEvent:(UIView *)theView toPosition:(CGPoint)position
{
    self.theMoveingView.center = position;
}

// Handles the end of a touch event.
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Enumerates through all touch object
    for (UITouch *touch in touches) {
        // Sends to the dispatch method, which will make sure the appropriate subview is acted upon
        [self dispatchTouchEndEvent:[touch view] toPosition:[touch locationInView:self.view]];
    }
}

// Checks to see which view, or views,  the point is in and then calls a method to perform the closing animation,
// which is to return the piece to its original size, as if it is being put down by the user.
-(void)dispatchTouchEndEvent:(UIView *)theView toPosition:(CGPoint)position
{
    if (!self.theMoveingView) {
        return;
    }
    //move to the proper position
    float x = self.theMoveingView.frame.origin.x;
    float y = self.theMoveingView.frame.origin.y;
    int xx = (x - 25 + gridsize / 2) / gridsize;
    int yy = (y - 50 + gridsize / 2) / gridsize;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:MOVE_ANIMATION_DURATION_SECONDS];
    for (int i = 0; i < shipLenth; i++) {
        if (rotated) {
            if (xx + i < 0 || xx + i >= 10 || yy < 0 || yy >= 10 || ![self.player.board[xx + i][yy]  isEqual: @0]) {
                for (int i = 0; i < shipLenth; i++) {
                    self.player.board[oldX + i][oldY] = [NSNumber numberWithInt:currentShip];
                }
                self.theMoveingView.center = self.oldCenter;
                [UIView commitAnimations];
                self.theMoveingView = nil;
                return;
            }
        } else {
            if (yy + i < 0 || yy + i >= 10 || xx < 0 || xx >= 10 || ![self.player.board[xx][yy + i]  isEqual: @0]) {
                for (int i = 0; i < shipLenth; i++) {
                    self.player.board[oldX][oldY + i] = [NSNumber numberWithInt:currentShip];
                }
                self.theMoveingView.center = self.oldCenter;
                [UIView commitAnimations];
                self.theMoveingView = nil;
                return;
            }
        }
    }
    self.theMoveingView.center = CGPointMake(xx * gridsize + 25 + self.theMoveingView.frame.size.width / 2, yy * gridsize + 50 + self.theMoveingView.frame.size.height / 2);
    [UIView commitAnimations];
    for (int i = 0; i < shipLenth; i++) {
        if (rotated) {
            self.player.board[xx + i][yy] = [NSNumber numberWithInt:currentShip];
        } else {
            self.player.board[xx][yy + i] = [NSNumber numberWithInt:currentShip];
        }
    }
    Ship* ship = self.player.ships[currentShip - 10];
    ship.startX = xx;
    ship.startY = yy;
    self.theMoveingView = nil;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Enumerates through all touch object
    for (UITouch *touch in touches) {
        // Sends to the dispatch method, which will make sure the appropriate subview is acted upon
        [self dispatchTouchEndEvent:[touch view] toPosition:[touch locationInView:self.view]];
    }
}


- (IBAction)finish:(id)sender {
    if (self.game.setting.mode == 1) {
        if (self.game.setting.playTurn == 0) {
            self.game.setting.playTurn = 1;
            [self performSegueWithIdentifier:@"twoPlayer1" sender:sender];
        } else {
            self.game.setting.playTurn = arc4random_uniform(2);
            [self performSegueWithIdentifier:@"twoPlayer2" sender:sender];
        }
    } else {
        [self.game.player2 AIDeploy];
        self.game.setting.playTurn = arc4random_uniform(2);
        [self performSegueWithIdentifier:@"onePlayer" sender:sender];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Releases necessary resources.
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
