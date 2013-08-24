//
//  ProgressGenerator.m
//  HelloTolo
//
//  Created by Ephraim Tekle on 8/23/13.
//  Copyright (c) 2013 Ephraim Tekle. All rights reserved.
//

#import "ProgressGenerator.h"

#define randomscaled() ((double)arc4random() / 0x100000000)

@implementation ProgressGenerator

- (id) init
{
    self = [super init];

    REGISTER();
    
    [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(somethingTriggersProgressUpdateInReallifeApplication)
                                   userInfo:nil
                                    repeats:YES];
    
    return self;
}

PUBLISHER(EventProgressUpdated)
{
    EventProgressUpdated *progress = [EventProgressUpdated new];
    progress.progress = randomscaled();
    
    return progress;
}

- (void) somethingTriggersProgressUpdateInReallifeApplication
{
    
    PUBLISH([self getEventProgressUpdated]);
    
}

@end
