# How to spin up the instance

1. `cd awsInfra`
2. `terraform apply`
3. `ssh ubuntu@<ssh_host ip>`
4. `redis-cli -h <primary endpoint>`

# (Cluster disabled) Questions to Answer

![after failover](doc/cluster_disabled.png?raw=true)

1. What happen when primary fails?
   - It will auto failover to the replicas.
   - The Primary endpoint stays the same so write operations are not interupted.
     ![before failover](doc/Primary_failover_before.png?raw=true)
     ![after failover](doc/Primary_failover_after.png?raw=true)
2. What happen if we need to downgrade the node engine?
   - Tried from downgrade from redis 7 to 6. All nodes (both primary and relicas) in the cluster gets deleted and recreated. This means redis are down during the entire downgrade time.
     ![](doc/downgrade_recreate.png?raw=true)
3. What happen if we need to upgrade the node engine?
   - Tried to upgrade from redis 6 to 7. We can still write and read. At some moment the primary becomes replica so the write operations failed. However, it was only momentarily.
