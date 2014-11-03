if service fit14apache status >/dev/null; then service fit14apache stop; fi; service fit14apache start > /dev/null
if service fit14phpfpm status >/dev/null; then service fit14phpfpm stop; fi; service fit14phpfpm start > /dev/null

echo
sudo /opt/sevenval/fit14/bin/fitadmin -v
echo
echo access your local FIT at
echo 
echo http://local14.sevenval-fit.com:8080/
echo https://local14.sevenval-fit.com:8443/
echo 
