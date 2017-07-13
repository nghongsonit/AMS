//
//  DataProxy.h
//  IQC
//
//  Created by SonTayTo on 9/21/16.
//  Copyright © 2016 SonTayTo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseProxy.h"
#import "UserRecord.h"
#import "ListAquacultureRecord.h"
#import "AquacultureRecord.h"
#import "HealthRecord.h"
#import "CurrentInfoRecord.h"
#import "ListDataRecord.h"
#import "FoodRecord.h"
#import "Health1Record.h"
#import "MedicineRecord.h"
#import "CommandRecord.h"
#import "FishDeadRecord.h"
#import "DetailFishDeadRecord.h"
#import "FishSizeRecord.h"
#import "ChartFoodRecord.h"
#import "ChartEnvironmentRecord.h"
#import "EnvironmentRecord.h"
#import "CheckListDetailRecord.h"
#import "UserAreaRecord.h"
#import "OpenUDID.h"
#import "NotificationRecord.h"

@interface DataProxy: BaseProxy

- (void)login:(NSString *)username password:(NSString *)password
completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)getListAquaculture :(NSString *)pageNum PerPage:(NSString *)perPage
         completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)getAquacultureDetail :(NSString *)aquaId completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)getListFood:(NSString *)pageNum PerPage:(NSString *)perPage
completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
- (void)getListHealth:(NSString *)pageNum PerPage:(NSString *)perPage
      completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
- (void)getListMedicine:(NSString *)pageNum PerPage:(NSString *)perPage
        completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)uploadData:(NSData *)jsonData completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)updateData:(NSData *)jsonData completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
- (void)getStaffCommand:(NSString *)pageNum PerPage:(NSString *)perPage
        completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)getListAquacultureManager :(NSString *)pageNum PerPage:(NSString *)perPage completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)getAquacultureDetailManager :(NSString *)aquaId completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)getChartFishDead:(NSString *)aquaId FromDate:(NSString *)fromDate ToDate:(NSString *)toDate completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)getChartFishSize:(NSString *)aquaId FromDate:(NSString *)fromDate ToDate:(NSString *)toDate completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)getChartFood:(NSString *)aquaId FromDate:(NSString *)fromDate ToDate:(NSString *)toDate completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)getChartEnvironment:(NSString *)aquaId FromDate:(NSString *)fromDate ToDate:(NSString *)toDate completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
- (void)getCheckListDetail:(NSString *)aquaId completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
- (void)checkVersion:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
- (void)searchAquaStaff:(NSString *)key completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
- (void)searchAquaManager:(NSString *)key completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
- (void)getManagerCommand:(NSString *)pageNum PerPage:(NSString *)perPage
          completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)getListUserByArea :(NSString *)pageNum PerPage:(NSString *)perPage completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)postCommand :(NSString *)username Message:(NSString *)message completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
- (void)changePassword:(NSString *)oldPass NewPass:(NSString *)newPass
       completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)updateToken:(NSString *)userName token:(NSString *)token completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)removeToken:(NSString *)userName completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
- (void)getNotify:(NSString *)pageNum PerPage:(NSString *)perPage
  completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)updateStatusNotify:(NSString *)notifyId completeHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
-(void)getBadge:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;

-(void)getStaffCommandDetail :(NSString *)commandId completionHandler:(DidGetResultBlock)handler errorHandler:(ErrorBlock)errHandler;
@end
