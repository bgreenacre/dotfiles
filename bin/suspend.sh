#!/bin/sh
# sleep.sh test script for measuring power drain during suspend-to-ram with ACPI

# default settings, change if needed
LOG=/var/log/battery.log
BATTERY=BAT0
THRESHOLD=1000

if ! grep -q '^charging state:.*discharging' /proc/acpi/battery/$BATTERY/state; then
   echo 'Not running on battery power, did you forget to disconnect the charger?'
   exit 1
fi

# remove USB for external mouse before sleeping
if lsmod | grep '^usbhid' >/dev/null ; then
   /sbin/modprobe -r -s usbhid
fi
if lsmod | grep '^uhci_hcd' >/dev/null ; then
   /sbin/modprobe -r -s uhci_hcd
fi
if lsmod | grep '^ehci_hcd' >/dev/null ; then
   /sbin/modprobe -r -s ehci_hcd
fi

# save system time
hwclock --systohc

# get start values
date >> $LOG
DATE_BEFORE=`date +%s`
BAT_BEFORE=`grep 'remaining capacity' /proc/acpi/battery/$BATTERY/state | awk '{print $3}'`

# go to sleep
if [ -e /proc/acpi/sleep ]; then
    echo 3 > /proc/acpi/sleep
else
    echo -n mem > /sys/power/state
fi

# get end values
DATE_AFTER=`date +%s`
BAT_AFTER=`grep 'remaining capacity' /proc/acpi/battery/$BATTERY/state | awk '{print $3}'`

# do the calculations 
DIFF=`echo "$BAT_AFTER - $BAT_BEFORE" | bc`
SECONDS=`echo "$DATE_AFTER - $DATE_BEFORE" | bc`
USAGE=`echo "($DIFF * 60 * 60) / ($SECONDS)" | bc`

# output the results
echo "before: $BAT_BEFORE mWh" >> $LOG
echo "after: $BAT_AFTER mWh" >> $LOG
echo "diff: $DIFF mWh" >> $LOG
echo "seconds: $SECONDS sec" >> $LOG
echo "result: $USAGE mW" >> $LOG
if [ $USAGE -gt -$THRESHOLD ]
then
    echo "Congratulations, your model seems NOT to be affected." >> $LOG
else
    echo "Your model seems to be affected." >> $LOG
fi
if [ $SECONDS -lt 1200 ]
then
    echo "!!! The notebook was suspended less than 20 minutes." >> $LOG
    echo "!!! To get representative values please let the notebook sleep" >> $LOG
    echo "!!! for at least 20 minutes." >> $LOG
fi
echo "" >> $LOG

# restore USB support 
if !(lsmod | grep '^ehci_hcd') >/dev/null ; then
   /sbin/modprobe -s ehci_hcd
fi
if !(lsmod | grep '^uhci_hcd') >/dev/null ; then
   /sbin/modprobe -s uhci_hcd
fi
if !(lsmod | grep '^usbhid')   >/dev/null ; then
   /sbin/modprobe -s usbhid
fi

# restore system time
hwclock --hctosys
