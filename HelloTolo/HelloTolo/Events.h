//
//  Events.h
//  HelloTolo
//
//  Created by Ephraim Tekle on 8/23/13.
//  Copyright (c) 2013 Ephraim Tekle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventProgressUpdated : NSObject
@property(nonatomic) CGFloat progress;
@end


@interface EventValueChanged : NSObject
@property(nonatomic, strong) NSString *value;
@end

