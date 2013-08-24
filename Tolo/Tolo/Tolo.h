//
//  Tolo.h
//  Tolo
//
//  Created by Ephraim Tekle on 8/23/13.
//  Copyright (c) 2013 Ephraim Tekle. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SUBSCRIBE(_event_name_) - (void) on##_event_name_:(_event_name_ *) event

#define PUBLISHER(_event_name_) - (_event_name_ *) get##_event_name_

#define REGISTER() [Tolo.sharedInstance subscribe:self]

#define UNREGISTER() [Tolo.sharedInstance unsubscribe:self]

#define PUBLISH(_value_) [Tolo.sharedInstance publish:_value_]

@interface Tolo : NSObject

@property(nonatomic) BOOL forceMainThread;

- (void) subscribe:(NSObject *)object;
- (void) unsubscribe:(NSObject *)object;
- (void) publish:(id<NSObject>)type;

// This doesn't prevent you from creating as many instances as you like. This way, you have at least
// one shared instance that you can use right off the bat.
+ (Tolo *) sharedInstance;

@end

