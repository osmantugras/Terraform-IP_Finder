#!/bin/bash
i1=192; i2=168; i3=1; i4=0
max=255
eval printf -v ip "%s\ " 192.168.1.{$i4..$max}

for i in $ip; do
  ping $i -c 3 2>/dev/null 1>/dev/null
  if [ $? -eq 1 ]
  then
    echo $i "Empty IP Address found"
    VALUE=$i
    cn='echo "$i" | sed 's/^.*\.\([^.]*\)$/\1/''
    echo $cn
    export VM_IP="$VALUE"
    echo $VM_IP > ./IPAddress.txt
    cp ./vars.tf_template ./vars.tf
    sed -i 's@K3SJenkins@'"K3SJenkins$cn"'@' ./vars.tf
    sed -i 's@IPAD@'"$VM_IP"'@' ./vars.tf
    break
  fi
done
