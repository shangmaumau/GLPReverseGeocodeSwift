

# 简介
示例提供了集合的六种地理坐标反编码的方法，分别为苹果地图，高德地图，百度地图，谷歌地图，微软地图（前必应地图），以及 OpenStreetMap 开放地图（OSM）。
除了苹果地图和 OSM ，其他几个地图服务，都需要导入相应的 SDK 。在 GLPReverseGeocode.swift 中，默认导入了所有服务，因此要想使示例运行，请先运行 `pod install` 安装所有依赖的地图服务库。
# 注意
在 SceneDelegate.swift 中，除谷歌 API key 之外，其他几个地图服务都提供了示例的 key ，是与 Bundle ID 绑定在一起的，目前都可用。
谷歌 API 目前是通用的 API ，不再提供单独的地图 API key ，但是可以配置为仅使用地图服务。详情可自行搜索了解，此处不赘述。

# 使用

提供了 `service` 外部变量，可根据使用要求而更改。

## 方式一
适用于同时触发多次请求的情况。在 resultHandler 中处理即可。
```swift
    geocode = GLPReverseGeocode.init(service: .apple)
    geocode.resultHandler = { [weak self] (address, error) in
        DispatchQueue.main.async {
            self?.hideProgressHUD()
            if error == nil {
                self?.addressText.text = address?.line
            }
        }
    }
```

## 方式二
适用于单次请求。
```swift
    geocode = GLPReverseGeocode.init(service: .apple)
    geocode.reverseGeocode(with: coordi) { (address, error) in
        DispatchQueue.main.async {
            self?.hideProgressHUD()
            if error == nil {
                self?.addressText.text = address?.line
            }
        }
    }
```

# License
GLPReverseGeocode 使用 [MIT License](http://opensource.org/licenses/MIT) 。
