//
//  ViewController.m
//  MovieLooperDemo
//
//  Created by Jun Kit Lee on 15/7/12.
//  Copyright (c) 2012 mohawk.riceball@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@interface ViewController ()

@end

@implementation ViewController

AVPlayer *player;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"WD0165" ofType:@"mov"];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        
        NSError *error = nil;
        AVKeyValueStatus status = [asset statusOfValueForKey:@"tracks" error:&error];
        
        if (status == AVKeyValueStatusLoaded)
        {
            //when the asset had loaded its tracks
            AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
            player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
            
            CALayer *viewLayer = self.view.layer;
            
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
            playerLayer.frame = self.view.bounds;
            [viewLayer addSublayer:playerLayer];
            
            //register end of track notification
            [[NSNotificationCenter defaultCenter]
             addObserver:self
             selector:@selector(playerItemDidReachEnd:)
             name:AVPlayerItemDidPlayToEndTimeNotification
             object:[player currentItem]];
            
            [player play];
        }
        
        
    }];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{  
    //rewind and play again when the video reaches the end
    [player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        [player play];
    }];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
