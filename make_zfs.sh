mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
sudo -i
yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_8.noarch.rpm
          #import gpg key 
          rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
          #install DKMS style packages for correct work ZFS
          yum install -y epel-release kernel-devel zfs
          #change ZFS repo
          yum-config-manager --disable zfs
          yum-config-manager --enable zfs-kmod
          yum install -y zfs
          #Add kernel module zfs
          modprobe zfs
          #install wget
          yum install -y wget
          
          lsblk
          zpool create otus1 mirror /dev/sdb /dev/sdc
          zpool create otus2 mirror /dev/sdd /dev/sde
          zpool create otus3 mirror /dev/sdf /dev/sdg
          zpool create otus4 mirror /dev/sdh /dev/sdi
          
          zpool list  #Смотрим информацию о пулах:
          zpool status
          
              zfs set compression=lzjb otus1 # • Алгоритм lzjb:
              zfs set compression=lz4 otus2 #• Алгоритм lz4:
              zfs set compression=gzip-9 otus3 # • Алгоритм gzip:
              zfs set compression=zle otus4 # • Алгоритм zle:
              
              zfs get all | grep compression #методы сжатия:
              
              
              for i in {1..4}; do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done
              
              ls -l /otus*
              zfs list
              
              zfs get all | grep compressratio | grep -v ref
              
              
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg" -O archive.tar.gz && rm -rf /tmp/cookies.txt
  
  
  
  tar -xzvf archive.tar.gz
  
  zpool import -d zpoolexport/
  
  zpool import -d zpoolexport/ otus
  
  zpool get all otus
  
   #Работа со снапшотом, поиск сообщения от преподавателя
  
 sudo wget -O otus_task2.file --no-check-certificate "https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download"
   sudo  zfs receive otus/test@today < otus_task2.file
   sudo  find /otus/test -name "secret_message" /otus/test/task1/file_mess/secret_message   
           
    sudo  cat /otus/test/task1/file_mess/secret_message        

