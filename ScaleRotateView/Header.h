//
//  Header.h
//  ScaleRotateView
//
//  Created by MyCompany on 16/10/18.
//  Copyright © 2016年 Babyvilla. All rights reserved.
//

#ifndef Header_h
#define Header_h


#import <UIKit/UIKit.h>

#ifdef DEBUG
#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   LxPrintf(@"CheckTime: %f", -[startTime timeIntervalSinceNow])
#else
#define TICK
#define TOCK
#endif

#endif /* Header_h */
