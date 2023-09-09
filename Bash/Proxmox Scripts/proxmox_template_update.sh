for VM in 600{0..2}
do
qm destroy $VM --destroy-unreferenced-disks 1 --purge &
done
wait

qm clone 9001 6000 --name ubuntu-desktop-cloud-master-template & \
qm clone 9002 6001 --name ubuntu2204-cloud-master-template & \
qm clone 9003 6002 --name ubuntu2204-cloud-master-extras-template & \
wait

for VM in 600{0..2}
do
qm set $VM --ipconfig0 ip=dhcp &
done
wait

for VM in 600{0..2}
do
qm start $VM &
done
wait

for VM in 600{0..2}
do
qm guest exec $VM -- /bin/bash -c "apt-get clean"
qm guest exec $VM -- /bin/bash -c "apt-get -y autoremove --purge"
qm guest exec $VM -- /bin/bash -c "apt-get -y clean"
qm guest exec $VM -- /bin/bash -c "apt-get -y autoclean"
qm guest exec $VM -- /bin/bash -c "cloud-init clean"
qm guest exec $VM -- /bin/bash -c "echo -n > /etc/machine-id"
qm guest exec $VM -- /bin/bash -c "echo -n > /var/lib/dbus/machine-id"
qm guest exec $VM -- /bin/bash -c "sync"
qm guest exec $VM -- /bin/bash -c "history -c"
qm guest exec $VM -- /bin/bash -c "history -w"
qm guest exec $VM -- /bin/bash -c "fstrim -av"
done

for VM in 600{0..2}
do
qm shutdown $VM &
done
wait

for VM in 600{0..2}
do
qm set $VM --template 1 &
done
wait