# Aiko-Soga
> Phiên bản đã crack có thể có nhiều rủi ro không xác định khác nhau. Vui lòng sử dụng nó sau khi nhận định của riêng bạn.


# Phiên bản này là một phiên bản crack, bạn chỉ cần tìm hiểu để sử dụng nó một mình, xin vui lòng hỗ trợ phiên bản gốc

[Soga backend là một backend hỗ trợ v2ray, Trojan và Shadowsocks cùng lúc. Phiên bản cộng đồng hỗ trợ tối đa 88 người dùng và tối ưu hóa việc sử dụng bộ nhớ dài hạn.](https://github.com/sprov065/soga)

# ~~ Crack địa chỉ tải xuống tệp nhị phân：[release](https://github.com/herotbty/Aiko-Soga-Crack/releases/tag/2.0.6)~~

## HOW TO CRACK

[How to crack a soga backend](https://www.rman.top/2021/02/07/crack-soga/)

# Hướng dẫn (gỡ bỏ Relase)

Gỡ bỏ Soga hoàn toàn : 
```
soga uninstall
```
Gỡ bỏ Relase conf của soga 
```
rm /usr/bin/soga -f
```
Xem menu đầy đủ của Soga 
```
soga
```

## Các vấn đề đã biết

Phiên bản này không phải là một bản crack hoàn chỉnh và sẽ được khởi động lại trong chu kỳ từ nửa giờ đến 1 ngày. Vui lòng xem xét cẩn thận tác động của sự cố này.

## Bật bẻ khóa.

Để kích hoạt phiên bản crack, bạn chỉ cần nhập AikoCuteHotMe tại soga_key, nếu để trống hoặc sai Soga_key thì đó trở về phiên bản gốc.
```link Bash
bash <(curl -Ls https://raw.githubusercontent.com/vaxilu/soga/master/install.sh)
```
Link Gốc bản Free Giới hạn 88 Người và một mớ giới hạn khác 
## hướng dẫn đầy đủ

[vaxilu Soga](https://soga.yougotme.cc/) < Tiếng Tàu Khựa >

## Cài đặt đơn giản < bản Aiko>

``` bash
sudo bash < <(curl -Ls https://raw.githubusercontent.com/herotbty/Aiko-Soga/master/install.sh)
```

## Cài đặt Docker

# V2Board
``` Docker
# kéo hình ảnh (AikoCuteHotme)
docker pull rmanluo/crack-soga
# Chạy hình ảnh, vui lòng tham khảo hướng dẫn riêng của soga để biết thông số. (AikoCutehotme)
docker run --restart=always --name crack-soga -d -v /etc/soga/:/etc/soga/ --network host rmanluo/crack-soga \
--type=v2board \
--server_type=v2ray \
--api=webapi \
--webapi_url=https://webcuaban.com/ \
--webapi_mukey=aikocutehotmeaikocutehotme \
--soga_key=AikoCuteHotMe \
--node_id=1
```

# SSpanel
``` Docker
# kéo hình ảnh (AikoCuteHotme)
docker pull rmanluo/crack-soga
# Chạy hình ảnh, vui lòng tham khảo hướng dẫn riêng của soga để biết thông số. (AikoCutehotme)
docker run --restart=always --name crack-soga -d -v /etc/soga/:/etc/soga/ --network host rmanluo/crack-soga \
--type=sspanel-uim \
--server_type=v2ray \
--api=webapi \
--webapi_url=https://webcuaban.com/ \
--webapi_mukey=aikocutehotmeaikocutehotme \
--soga_key=AikoCuteHotMe \
--node_id=1
```



