//
//  MDViewController.m
//  1024AI
//
//  Created by Matthieu DESILE on 15/03/14.
//  Copyright (c) 2014 Matthieu DESILE. All rights reserved.
//

#import "MDViewController.h"
#import "MDGrid.h"
#import "MDGridScene.h"

@implementation MDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    MDGrid* grid = [[MDGrid alloc] initWithWidth: 4 andHeight: 4];
    [grid putTile: 4 row: 1 column: 1];
    [grid putTile: 2 row: 2 column: 1];
    //[grid addRandomTiles: 2];
    SKScene * scene = [[MDGridScene alloc] initWithSize: skView.bounds.size andGrid: grid];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
