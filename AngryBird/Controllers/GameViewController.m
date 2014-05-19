//
//  GameViewController.m
//  AngryBird
//
//  Created by Kiran Gangadharan on 19/05/14.
//  Copyright (c) 2014 kiran. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;
@property (nonatomic) UILabel *gameOverLabel;
@property (nonatomic) UIButton *playAgainButton;
@property (nonatomic) NSInteger score;
@property (nonatomic) UILabel *finalScoreLabel;

@property (nonatomic) BOOL isPaused;
@property(nonatomic) NSInteger birdFlight;
@property (nonatomic) NSTimer *birdMovement;
@property (nonatomic) NSTimer *wallMovement;

@end


@implementation GameViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.startButton.hidden = NO;
    self.bird.hidden = YES;
    self.bird.contentMode = UIViewContentModeScaleAspectFit;
    self.TopWall.hidden = YES;
    self.BottomWall.hidden = YES;
}

- (IBAction)startGame:(UIButton *)sender {
    self.bird.hidden = NO;
    self.TopWall.hidden = NO;
    self.BottomWall.hidden = NO;
    self.scoreLabel.hidden = NO;
    self.pauseButton.hidden = NO;
    
    self.startButton.hidden = YES;
    self.gameOverLabel.hidden = YES;
    self.playAgainButton.hidden = YES;
    self.finalScoreLabel.hidden = YES;
    self.isPaused = NO;
    
    self.score = 0;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
    
    [self placeWalls];
    [self startTimers];
}

- (void)startTimers {
    //Bird Movement
    self.birdMovement = [NSTimer scheduledTimerWithTimeInterval:0.04
                                                         target:self
                                                       selector:@selector(moveBird)
                                                       userInfo:nil
                                                        repeats:YES];
    
    //Wall Movement
    self.wallMovement = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                         target:self
                                                       selector:@selector(moveWalls)
                                                       userInfo:nil
                                                        repeats:YES];
}

/**
 *  Pause Game
 *
 *  @param sender sender
 */
- (IBAction)pauseGame:(UIButton *)sender {
    if (self.isPaused) {
        self.pauseButton.titleLabel.text = @"Pause";
        [self performSelector:@selector(startTimers) withObject:nil afterDelay:0.2];
    } else {
        self.isPaused = YES;
        self.pauseButton.titleLabel.text = @"Resume";
        [self.birdMovement invalidate];
        [self.wallMovement invalidate];
    }
}


/**
 *  Place Walls at random locations
 */
- (void)placeWalls {
    NSInteger topWallLocation = (arc4random() % 350) - 228;
    NSInteger bottomWallLocation = topWallLocation + 655;
    self.TopWall.center = CGPointMake(340, topWallLocation);
    self.BottomWall.center = CGPointMake(340, bottomWallLocation);
}

/**
 *  Move the bird
 */
- (void)moveBird {
    self.bird.center = CGPointMake(self.bird.center.x, self.bird.center.y - self.birdFlight);
    self.birdFlight = self.birdFlight - 5;
    
    if (self.birdFlight <= -15) {
        self.birdFlight = -15;
    }
    
    [self checkWallHit];
    if (self.BottomWall.frame.origin.x <= -53) {
        //bird has passed through the gap
        self.score = self.score + 1;
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
    }
    
    //Adding top and bottom boundary constraints
    if (self.bird.frame.origin.y <= 9 | self.bird.frame.origin.y >= 530) {
        [self gameOver];
    }
}

- (void)checkWallHit {
    if (CGRectIntersectsRect(self.bird.frame, self.TopWall.frame)) {
        [self gameOver];
    }
    
    if (CGRectIntersectsRect(self.bird.frame, self.BottomWall.frame)) {
        [self gameOver];
    }
}

- (void)gameOver {
    
    //Stop all movements
    [self.birdMovement invalidate];
    [self.wallMovement invalidate];
    
    self.bird.hidden = YES;
    self.TopWall.hidden = YES;
    self.BottomWall.hidden = YES;
    self.pauseButton.hidden = YES;
    self.scoreLabel.hidden = YES;
    
    self.gameOverLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 280, 234)];
    self.gameOverLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *gameOverString = @"Game Over";
    NSMutableAttributedString *gameOverText = [[NSMutableAttributedString alloc] initWithString:gameOverString];
    [gameOverText addAttribute:NSForegroundColorAttributeName
                         value:[UIColor blackColor]
                         range:NSMakeRange(0, [gameOverString length])];
    
    self.gameOverLabel.attributedText = gameOverText;
    [self.gameOverLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:33.0]];
    [self.view addSubview:self.gameOverLabel];
    
    self.finalScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, 280, 234)];
    self.finalScoreLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *finalScoreString = [NSString stringWithFormat:@"Score: %d", self.score];
    NSMutableAttributedString *finalScoreAttributedString = [[NSMutableAttributedString alloc] initWithString:finalScoreString];
    [finalScoreAttributedString addAttribute:NSForegroundColorAttributeName
                         value:[UIColor darkGrayColor]
                         range:NSMakeRange(0, [finalScoreString length])];
    
    self.finalScoreLabel.attributedText = finalScoreAttributedString;
    [self.finalScoreLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:25.0]];
    [self.view addSubview:self.finalScoreLabel];
    
    self.playAgainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playAgainButton setTitle:@"Play Again" forState:UIControlStateNormal];
    [self.playAgainButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.playAgainButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:33.0];
    [self.playAgainButton addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchUpInside];
    self.playAgainButton.frame = CGRectMake(20.0, 404.0, 280.0, 180.0);
    [self.view addSubview:self.playAgainButton];
 
    self.score = 0;
}

/**
 *  Move the walls
 */
- (void)moveWalls {
    self.TopWall.center = CGPointMake(self.TopWall.center.x - 1, self.TopWall.center.y);
    self.BottomWall.center = CGPointMake(self.BottomWall.center.x - 1, self.BottomWall.center.y);
    
    if (self.TopWall.center.x < -28) {
        [self placeWalls];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.birdFlight = 30;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
