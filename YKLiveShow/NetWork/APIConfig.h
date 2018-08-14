//
//  APIConfig.h
//

#import <Foundation/Foundation.h>

@interface APIConfig : NSObject

#define SERVER_HOST @"http://service.ingkee.com"
//首页数据
#define API_LiveGetTop @"api/live/gettop"

//附近的人
#define API_NearLocation @"api/live/near_recommend?uid=117894363&latitude=%@&longitude=%@"
//85149891

//查找经纬度
#define API_SearchLatlong @"https://api.map.baidu.com/geocoder?output=json&address=%@"
@end
