#!/bin/bash

#Check the number of arguments and call argument_definition function
function main {

	if [ $ARGUMENTS_NUMBER != 1 ]; then
		echo "Print only one argument!"
		echo "Print argument '-h' to get information about arguments"
	else 
		argument_definition
	fi
}

#After checking the argument, calls the corresponding function
function argument_definition {

	if [ "$ARGUMENT" = "-l" ]; then
		print_Linux_information
	fi


	if [ "$ARGUMENT" = "-c" ]; then
                print_CPU_information
        fi


	if [ "$ARGUMENT" = "-g" ]; then
                print_GPU_information
        fi


	if [ "$ARGUMENT" = "-r" ]; then
                print_RAM_information
        fi


	if [ "$ARGUMENT" = "-d" ]; then
                print_HDD_information
        fi


	if [ "$ARGUMENT" = "-a" ]; then
                print_ALL_information
        fi


	if [ "$ARGUMENT" = "-h" ]; then
                print_Help_information
        fi
}

#Get and print information about OS
function print_Linux_information {

	hostname=$(uname -n)
	kernel_name=$(uname -s)
	kernel_release=$(uname -r)
	kernel_version=$(uname -v)
	proc_arch=$(uname -p)
	
	echo "OS information"
	echo "Hostname              : $hostname"	
        echo "Kernel name           : $kernel_name"
	echo "Kernel release        : $kernel_release"
	echo "Kernel version        : $kernel_version"
	echo "Proc. Architecture    : $proc_arch"	
}

#Get and print information about CPU
function print_CPU_information {
	
	model_name=$(cat /proc/cpuinfo | awk '/model name/{print $4,$5,$6,$7,$8,$9}')
	cpu_cores=$(cat /proc/cpuinfo | awk '/cpu cores/{print $4}')
	cache=$(cat /proc/cpuinfo | awk '/cache size/{print $4,$5}')
	cpu_frequency=$(cat /proc/cpuinfo | awk '/cpu MHz/{print $4}')

	echo "CPU information"		
	echo "Model name            : $model_name"
	echo "CPU cores             : $cpu_cores"
	echo "CPU frequency         : $cpu_frequency"
	echo "Cache                 : $cache"
}

#Get and print information about GPU
function print_GPU_information {

	model=$(glxinfo -B | awk '/Device/{print $2,$3,$4,$5,$6,$7,$8,$9}')
	memory=$(glxinfo -B | awk '/Video/{print $3}')
	version=$(glxinfo -B | awk '/Version/{print $2}')

	echo "GPU information"
	echo "Model                 : $model"
	echo "Version               : $version"
	echo "Memory                : $memory"
}

#Get and print information about Hard disks
function print_HDD_info1 {

        size=$(lsblk | grep $1 | awk '/disk/{print $4}')
        part_text=$(lsblk | grep $1 | grep -o "part" | wc -l)

        echo "Disk                  : $1"
        echo "Size                  : $size"
        echo "Partitions number     : $part_text"
}

#Get and print information about RAM
function print_RAM_information {

	mem_total=$(free -l -m | awk '/Mem:/{print $2}')
	mem_used=$(free -l -m | awk '/Mem:/{print $3}')
	mem_free=$(free -l -m | awk '/Mem:/{print $4}')
	mem_buffers=$(free -l -m | awk '/Mem:/{print $6}')
	mem_avaible=$(free -l -m | awk '/Mem:/{print $7}')  	

	echo "Ram information in megabytes"
	echo "MemTotal              : $mem_total"
	echo "MemUsed               : $mem_used"
	echo "MemFree               : $mem_free"
	echo "Buff/cache            : $mem_buffers"
	echo "MemAvaible            : $mem_avaible"
}

#Get disks names and call print_HDD_info1 function
function print_HDD_information {

	echo "Hard disks information"
	device_names=$(lsblk -d -o name | grep sd)
	HDD_number=0
        SSD_number=0

	for devv in $device_names
	do
		if [ $(cat /sys/block/$devv/queue/rotational) == 1 ]; then
			HDD_number=$(($HDD_number+1))
			print_HDD_info1 $devv	
		else
			SSD_number=$(($SSD_number+1))
			print_HDD_info1 $devv
		fi	
	done
	echo
	echo "HDD number            : $HDD_number"
	echo "SSD number            : $SSD_number"
}

#Call all functions
function print_ALL_information {
	
	print_Linux_information
	echo
	print_CPU_information
	echo
	print_GPU_information
	echo
	print_RAM_information
	echo
	print_HDD_information
}

#Print helpful information about arguments
function print_Help_information {

	echo "Print only one argument!"
	echo "Give scripte argument '-l' to get information about Linux" 
	echo "Give scripte argument '-c' to get information about CPU"
	echo "Give scripte argument '-g' to get information about GPU"
	echo "Give scripte argument '-r' to get information about RAM"
	echo "Give scripte argument '-d' to get information about Hard disks"
	echo "Give scripte argument '-a' to get all information"
	echo "Give scripte argument '-h' to get help information"
}

ARGUMENTS_NUMBER=$#
ARGUMENT=$1

main
