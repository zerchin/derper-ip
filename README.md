## 概述
基于 DERP 纯 IP 方案，构建 derp 镜像

## 使用方法
DERP 服务器运行：
```bash
docker run -itd --name derper --net host zerchin/derper-ip:v0.1
```

ACL 添加：
```yaml
"derpMap": {
  "OmitDefaultRegions": true,
  "Regions": {
    "900": {
      "RegionID":   900,
      "RegionCode": "custom-derp-server",
      "RegionName": "Custom Derp Server",
      "Nodes": [
        {
          "Name":       "900a",
          "RegionID":     900,
          "DERPPort":     33445,
          "IPv4":       "<ip_addr>", 
          "InsecureForTests": true,
        },
      ],
    },
  },
},
```
