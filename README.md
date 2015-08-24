# About this project
This is a package that contains the open source projects Apache Mesos, Marathon and Chronos and provides those services as a Cloudera Manager Parcel that can be deployed and run on a Cloudera Hadoop Cluster. 
The parcel takes care of the resource management and scheduling of different distributed applications which run in the same cluster. 
The applications are containerized with Docker.

We also provide ready-to-use Parcels for EL6 and Ubuntu 14.04 (Trusty), see the [Alternative section](#alternative-link-to-existing-premade-parcels).

# Steps
* Build a Cloudera parcel containing Apache Mesos, Marathon and Chronos 
* Build a Cloudera parcel containing Docker

#changelog v1.0 -> v1.1

##Docker Parcel

- '-g,  --graph' flag can now be set through Cloudera Manager. This sets the path to use as the root of the Docker runtime.
- 'Registry ip and port' can now be set without URI validation warning.

##Mesos Parcel

- Renamed from MMC to MESOS.

###General

- More configuration options are now available on deployment.
- Tested on CDH 5.4.5

##Chronos

- Removed Chronos from the parcel, this can be run on Mesos via Marathon instead.

##Marathon

- Moved up to version 0.9 (in the pre-build parcels and tests).

##Mesos DNS

Mesos-DNS supports service discovery in Apache Mesos clusters. 

- [added Mesos DNS](https://mesosphere.github.io/mesos-dns/) to the parcel.


## 0 Prerequisites

- Zookeeper
- Cgroups

## 1. Build Apache Mesos - Marathon - Chronos from open source

This part explains the steps to build Apache Mesos - Marathon - Chronos from source with `CentOS 6.5`.

*You can skip this part if you want to use our pre-built versions and go to step 2.*

### 1.1 Apache Mesos

* Create a new file called `wandisco-svn.repo` in `/etc/yum.repos.d/`
```
        cd /etc/yum.repos.d/
        cat > wandisco-svn.repo
```

* Place the following content in your created file `wandisco-svn.repo`

```
        [WandiscoSVN]
        name=Wandisco SVN Repo
        baseurl=http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/$basearch/
        enabled=1
        gpgcheck=0
```

* Install the dependent packages for the build. This is very important because all the libraries are necessary for a successful build.

```
        sudo yum groupinstall -y "Development Tools"
        sudo yum install -y python-devel java-1.7.0-openjdk-devel zlib-devel libcurl-devel openssl-devel cyrus-sasl-devel cyrus-sasl-md5 apr-devel subversion-devel apr-utils-devel
        wget http://mirror.nexcess.net/apache/maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz
        sudo tar -zxf apache-maven-3.0.5-bin.tar.gz -C /opt/
        sudo ln -s /opt/apache-maven-3.0.5/bin/mvn /usr/bin/mvn

        # Because we are building from the Git repository, we will also need the following packages
        sudo yum install autoconf
        sudo yum install libtool
```

#####1.1.2 Build Mesos

* We used mesos version 0.22.0

```
		# download mesos-0.22.0 tarball
        wget http://archive.apache.org/dist/mesos/0.22.0/mesos-0.22.0.tar.gz
		
		# extract tarball
		tar xvf mesos-0.22.0.tar.gz
		# Change the working directory to `mesos`
		cd mesos-0.22.0
				
		# configure and build
		mkdir build
        cd build
        ../configure --enable-static --prefix=/usr/lib/mesos
        make
		
		# put the installation folders in the prefix directory
		make install
		
		# run test (optional)
		make check
		
		# add all depending libraries to the lib folder
		# can differ from system to system
		# use the command ldd /usr/lib/mesos/lib/libmesos.so
		# copy all the libraries to the lib folder
		cp /usr/lib64/libsasl2.so.2 /usr/lib/mesos/lib/ 
		cp /usr/lib64/libsvn_delta-1.so.0 /usr/lib/mesos/lib/ 
		cp /usr/lib64/libsvn_subr-1.so.0 /usr/lib/mesos/lib/ 
		cp /usr/lib64/libaprutil-1.so.0 /usr/lib/mesos/lib/ 
		cp /lib64/libcrypt.so.1 /usr/lib/mesos/lib/ 
		cp /lib64/libdb-4.7.so /usr/lib/mesos/lib/ 
		cp /lib64/libexpat.so.1 /usr/lib/mesos/lib/ 
		cp /lib64/libdl.so.2 /usr/lib/mesos/lib/ 
		cp /usr/lib64/libapr-1.so.0 /usr/lib/mesos/lib/ 
		cp /lib64/libpthread.so.0 /usr/lib/mesos/lib/ 
		cp /usr/lib64/libcurl.so.4 /usr/lib/mesos/lib/ 
		cp /lib64/libz.so.1 /usr/lib/mesos/lib/ 
		cp /lib64/librt.so.1 /usr/lib/mesos/lib/ 
		cp /usr/lib64/libstdc++.so.6 /usr/lib/mesos/lib/ 
		cp /lib64/libm.so.6 /usr/lib/mesos/lib/ 
		cp /lib64/libc.so.6 /usr/lib/mesos/lib/ 
		cp /lib64/libgcc_s.so.1 /usr/lib/mesos/lib/ 
		cp /lib64/libresolv.so.2 /usr/lib/mesos/lib/ 
		cp /lib64/libuuid.so.1 /usr/lib/mesos/lib/ 
		cp /lib64/libfreebl3.so /usr/lib/mesos/lib/ 
		cp /lib64/libidn.so.11 /usr/lib/mesos/lib/ 
		cp /lib64/libldap-2.4.so.2 /usr/lib/mesos/lib/ 
		cp /lib64/libgssapi_krb5.so.2 /usr/lib/mesos/lib/ 
		cp /lib64/libkrb5.so.3 /usr/lib/mesos/lib/ 
		cp /lib64/libk5crypto.so.3 /usr/lib/mesos/lib/ 
		cp /lib64/libcom_err.so.2 /usr/lib/mesos/lib/ 
		cp /usr/lib64/libssl3.so /usr/lib/mesos/lib/ 
		cp /usr/lib64/libsmime3.so /usr/lib/mesos/lib/ 
		cp /usr/lib64/libnss3.so /usr/lib/mesos/lib/ 
		cp /usr/lib64/libnssutil3.so /usr/lib/mesos/lib/ 
		cp /lib64/libplds4.so /usr/lib/mesos/lib/ 
		cp /lib64/libplc4.so /usr/lib/mesos/lib/ 
		cp /lib64/libnspr4.so /usr/lib/mesos/lib/ 
		cp /usr/lib64/libssh2.so.1 /usr/lib/mesos/lib/ 
		cp /lib64/liblber-2.4.so.2 /usr/lib/mesos/lib/ 
		cp /lib64/libkrb5support.so.0 /usr/lib/mesos/lib/ 
		cp /lib64/libkeyutils.so.1 /usr/lib/mesos/lib/ 
		cp /usr/lib64/libssl.so.10 /usr/lib/mesos/lib/ 
		cp /usr/lib64/libcrypto.so.10 /usr/lib/mesos/lib/

```

For the full documentation on Apache Mesos please refer to [this](http://mesos.apache.org/gettingstarted/) link.

####1.2 Marathon

```
		# get repo
        curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
		
		# install sbt
		sudo yum install sbt
		
		# download marathon-0.9 tarball 
		# marathon version 0.9 was used for this project
		wget http://downloads.mesosphere.com/marathon/v0.9.0/marathon-0.9.0.tgz
		
		# extract the tar file
		tar xvf marathon-0.9.0.tgz
		
		# change the working directory
		cd marathon-0.9.0
		
		# build
		sbt assembly
```
For the full documentation on Marathon please refer to [this](https://mesosphere.github.io/marathon/docs/) link.

####1.3 Chronos

These are the requirements to build and run Chronos. Please install nodeJS first.

* Apache Mesos 0.20.0+
* Apache ZooKeeper
* JDK 1.6+
* Maven 3+

```
		# install NodeJs
		sudo curl -sL https://rpm.nodesource.com/setup | bash -
		sudo yum install -y nodejs
		
		# start up Zookeeper, Mesos master, and Mesos slave(s). Then try
		export MESOS_NATIVE_LIBRARY=/usr/local/lib/libmesos.so
		git clone https://github.com/mesos/chronos.git
		cd chronos
		mvn package
		java -cp target/chronos*.jar org.apache.mesos.chronos.scheduler.Main --master zk://localhost:2181/mesos --zk_hosts localhost:2181
```

For the full documentation on Chronos please refer to [this](http://mesos.github.io/chronos/docs/)link.

## 2 Package parcel containing Apache Mesos - Marathon - Chronos

In this part we are going to package a parcel containing Apache Mesos - Marathon - Chronos.  

####2.1 pull and create parcel directory

```
		# clone repository from Git.
        git clone https://github.com/BigIndustries/cm_mesos_ext.git
		
		# change directory
		cd cm_mesos_ext/MMC_PARCEL-1.1
		
		# create the folders for the build files from step 1 in `mesos-integration/MMC_PARCEL-1.1/`
		mkdir fat_mesos
        cd fat_mesos
        mkdir mesos
        mkdir chronos
        mkdir marathon
		
		#create an extra work dir
		mkdir work_dir
		
		The directory `MMC_PARCEL-1.1` should now have a folder `fat_mesos` with 3 subfolders `mesos`, `marathon`, `chronos` and `work_dir`.

        MMC_PARCEL-1.1
            └── fat_mesos
                ├── mesos
                ├── marathon
                └── chronos
				
Please place the built files from step 1 in the corresponding folders.

```

#### 2.2 Package Mesos parcel

To package the parcels correctly `Python 2.7` and `Maven` must be installed. To know how to install `Python 2.7` on CentOS 6.5 refer to this [link](https://github.com/h2oai/h2o/wiki/Installing-python-2.7-on-centos-6.3.-Follow-this-sequence-exactly-for-centos-machine-only#how-to-install-python-276-on-centos-63-62-and-64-okay-too-probably-others).

Make sure you are in the `mesos-integration/MMC_PARCEL-1.1/` directory.

```
		# package with Maven
        mvn package
```

You will find the result of the packaging in the `MMC_PARCEL-1.1/target` directory. The files needed are:

* manifest.json
* MESOS-1.1-el6.parcel
* MESOS-1.1.jar

#### 3 Package Docker parcel

To package the parcels correctly `Python 2.7` and `Maven` must be installed. To know how to install `Python 2.7` on CentOS 6.5 refer to this [link](https://github.com/h2oai/h2o/wiki/Installing-python-2.7-on-centos-6.3.-Follow-this-sequence-exactly-for-centos-machine-only#how-to-install-python-276-on-centos-63-62-and-64-okay-too-probably-others).
Make sure you are in the `mesos-integration/DOCKER_PARCEL-1.1/` directory.

#### 3.1 Enter directory and package parcel

```		

	    # package with Maven
        mvn package
```

You will find the result of the packaging in the `DOCKER_PARCEL-1.1/target` directory. The files needed are:

* manifest.json
* DOCKER-1.1-el6.parcel
* DOCKER-1.1.jar

#### 4 Make the parcel available to Cloudera Manager

Cloudera allows for third party parcels to be added to Cloudera Manager. More information on parcels can be found  [here](http://www.cloudera.com/content/cloudera/en/documentation/core/latest/topics/cm_ig_parcels.html).

We will make our parcels available to Cloudera Manager by adding our `.parcel` and .`manifest` file to a web host. (i.e. Apache). Provide the URL to the parcels to  Cloudera Manager and the parcels will show up in the list.

Download, distribute and activate the parcels we just made available.

Now, one last step remains.

The `<PARCEL>-<VERSION>.jar` file in the target directory of the parcels we've just build, contains the Service Descriptor (csd). This allows for services to be added to Cloudera Manager.

These jar file(s) need to be added to the CSD directory on the CM host machine. By default, this directory is located at `/opt/cloudera/csd`.

For CM to pick up these files, the Cloudera Manager service needs to be restarted.

```
       sudo service cloudera-scm-server restart
```

Now you will be able to add the services to your cluster, just like you would I.e. HDFS, Hive, ...

#### Alternative: Link to existing, premade parcels

* In Cloudera Manager, point the parcel URL to http://bigindustries.be/parcels/
* Download - distrubute and activate the parcel
* Download the [Docker CSD file](http://bigindustries.be/parcels/DOCKER-1.1.jar)
* Download the [Mesos CSD file](http://bigindustries.be/parcels/MESOS-1.1.jar)

These jar file(s) need to be added to the CSD directory on the CM host machine. By default this directory is located at `/opt/cloudera/csd`.

For CM to pick up these files, the Cloudera Manager service needs to be restarted.

```
       sudo service cloudera-scm-server restart
```
