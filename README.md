

# 简介
示例提供了集合的六种地理坐标反编码的方法，分别为苹果地图，高德地图，百度地图，谷歌地图，微软地图（前必应地图），以及 OpenStreetMap 开放地图（OSM）。
除了苹果地图和 OSM ，其他几个地图服务，都需要导入相应的 SDK ，在 GLPReverseGeocode.h 中，如果导入了相应的 SDK ，则取消注释相应的 define 即可。
示例使用的是 CocoaPods 导入方式，手动导入的，可能不需要尖括号导入。

# 注意
在 SceneDelegate.m 中，需要提供自己申请的相应的地图的 SDK 的授权 key 。与此同时，你同时需要更改示例的 Bundle ID 。

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
