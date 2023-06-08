# homework004

 ####   Домашнее задание по работе с файловой системой zfs

mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh

  sudo -i # меняем пользователя на root

            # устанавливаем утилиты и модули ядра для работы с zfs filesystem
         yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_8.noarch.rpm
            #import gpg key 
          rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
            # install DKMS style packages for correct work ZFS
          yum install -y epel-release kernel-devel zfs
            # change ZFS repo
          yum-config-manager --disable zfs
          yum-config-manager --enable zfs-kmod
          yum install -y zfs
          modprobe zfs
                    
            # устанавливаем утилиту wget
          yum install -y wget
          
          lsblk # смотрим наличие блочных устройств для создания пула
          
             # Создаём 4 пула из двух дисков в режиме RAID 1:
          zpool create otus1 mirror /dev/sdb /dev/sdc
          zpool create otus2 mirror /dev/sdd /dev/sde
          zpool create otus3 mirror /dev/sdf /dev/sdg
          zpool create otus4 mirror /dev/sdh /dev/sdi
          
          
            #Смотрим информацию о пулах и о их состоянии
          zpool list # информацию о размере пула, количеству занятого и свободного места, дедупликации...
          zpool status # информацию о каждом диске, состоянии сканирования и об ошибках чтения, записи и совпадения хэш-сумм
          
          # Добавим разные алгоритмы сжатия в каждую файловую систему
          
              zfs set compression=lzjb otus1 #  Алгоритм lzjb
              zfs set compression=lz4 otus2 # Алгоритм lz4
              zfs set compression=gzip-9 otus3 #  Алгоритм gzip
              zfs set compression=zle otus4 #  Алгоритм zle
              
              # посмотрим алгоритмы и методы сжатия:
              
              zfs get all | grep compression 
              
              
              # Скачаем один и тот же текстовый файл во все пулы для проверки степени сжатия
              
              for i in {1..4}; do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done
               # Дождемся окончания процесса,
               # и посмотрим результат, размеры файлов и степень сжатия в каждом из пулов:
               
              ls -l /otus*
              zfs list
              zfs get all | grep compressratio | grep -v ref
              
              # импорт пула
               # скачиваем файл (архив)
              
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg" -O archive.tar.gz && rm -rf /tmp/cookies.txt
  
  
       # ...и распаковываем его
  tar -xzvf archive.tar.gz
  
       # Проверим, возможность  импортирования данного каталога в пул
       #... вывод должен показать нам имя пула, тип raid и его состав:
  
  zpool import -d zpoolexport/
  
       # Сделаем импорт данного пула к нам в ОС
  
  zpool import -d zpoolexport/ otus
  
        # Посмотрим результат:
        zpool status
        
        # Запрос сразу всех параметром файловой системы zfs:
         
         zpool get all otus
  
  #Работа со снапшотом, поиск сообщения от преподавателя
  # Скачиваем файл....
    wget -O otus_task2.file --no-check-certificate "https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download"
    
   # Восстановливаем файловую систему из снапшота
    
   sudo zfs receive otus/test@today < otus_task2.file
   
   # Далее, ищем в каталоге /otus/test файл с именем “secret_message”
   
   sudo  find /otus/test -name "secret_message" /otus/test/task1/file_mess/secret_message 
     
    # Смотрим содержимое найденного файла
          
    sudo  cat /otus/test/task1/file_mess/secret_message
    # В содержимом файла мы видим ссылку на гитхаб, копируем и открываем в браузере... 
