if service fit14apache status >/dev/null; then service fit14apache stop; fi; service fit14apache start > /dev/null
if service fit14phpfpm status >/dev/null; then service fit14phpfpm stop; fi; service fit14phpfpm start > /dev/null

sudo /opt/sevenval/fit14/bin/fitadmin -v

cat <<EOF

access your local FIT at

http://local14.sevenval-fit.com/
https://local14.sevenval-fit.com/

or

http://yourproject.local14.sevenval-fit.com/
https://yourproject.local14.sevenval-fit.com/

more info at https://developer.sevenval.com/

EOF
