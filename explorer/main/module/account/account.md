# 主网账户带宽，能量消耗恢复机制
## 20181029

net_limit: 冻结TRX获取的带宽总量
net_usage: 已经使用的能量。（累计方式：最近24小使用量，超过24小时的自动归还给冻结者，出块实时结算）

total_net_limit: 全网带宽上限
total_net_weight: 全网为获取net冻结的trx总量

当用户解冻时，其net_limit会在解冻交易确认时消减；如果已经使用的带宽未回复，则会出现带宽<0的情况。
当全网为获取带宽而冻结的trx总量增加时，用户分配的net会按比例减少，也可能导致net_limit - net_useage <0的情况出现

enery 逻辑相同


## 20181030

今日测试发现 getaccount 接口返回的 free_net_usage 字段不可用，
带宽消耗为：
    1. 冻结获取的net
    2. freeNetLimit, 累计为 freeNetUsed
    3. 消耗trx，trx的消耗量可以通过 getTransactionInfoByID 获取，里面有个 fee 字段表示trx消耗量，单位sun