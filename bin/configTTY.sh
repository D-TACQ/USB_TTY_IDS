#!/bin/bash
#configTTY.sh

read -p "Specify Carrier board. 2006, 2106, 1001, cpsc, cpsc2 or rtm-t : " carrier
if [ "$carrier" != "2006" ] && [ "$carrier" != "1001" ] && [ "$carrier" != "2106" ] && [ "$carrier" != "cpsc" ] && [ "$carrier" != "rtm-t" ] && [ "$carrier" != "cpsc2" ]; then
	echo -e "\e[31mError! Carrier board invalid. Valid entries : 1001,2006,2106,cpsc,rtm-t.\n"; tput sgr0
	#exit 0
fi

if [[ $carrier =~ ^[12][0-2]0[16]$ ]]; then
	carrier=acq$carrier
fi

serial_num=$(tail -12 /var/log/messages | grep "SerialNumber:" | tail -c 9)

if [ "$serial_num" != "" ]; then
	echo -e "\e[32mSerial Number = $serial_num\n"; tput sgr0
	read -p "Enter Number of Carrier (format XXX) e.g. \"001\" : " board_num
	
	if [[ $board_num =~ ^[0-9][0-9][0-9]$ ]]; then

		echo "SUBSYSTEMS==\"usb\", ATTRS{serial}==\"${serial_num}\", SYMLINK+=\"tty_${carrier}_${board_num}\" RUN+=\"/usr/local/bin/make-tty-symlink\"" \
		>> /etc/udev/rules.d/90-${carrier}.rules
		
		udevadm trigger
                udevadm control --reload

		#ln -s /usr/local/bin/kermit-ttySx-115200 /usr/local/bin/tty_acq${carrier}_${board_num}
		#ls -l /dev/tty_acq${carrier}_???
   		#cd /etc
		#git commit -a -m \'Adding acq${carrier}_${board_num}\'
		#git push USB_TTY master

	else
		echo -e "\e[31mIncorrect format entered! Board Number should be in the form \"001\"\n"; tput sgr0
		exit 0
	fi
	
	echo -e "\e[34mCOMPLETE! Line appended to udev rules file\n"; tput sgr0
	
else
	echo "No serial number found!"
fi
