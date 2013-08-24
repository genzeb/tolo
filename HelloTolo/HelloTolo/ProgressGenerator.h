//
//  ProgressGenerator.h
//  HelloTolo
//
//  Created by Ephraim Tekle on 8/23/13.
//  Copyright (c) 2013 Ephraim Tekle. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This class generates a random progress at 1Hz. It is also signed up as a publisher -- so all new subscribers will be notified of the last value upon subscription (regardless of what order this generator and the sbuscribers are created).
 */

@interface ProgressGenerator : NSObject

@end
