#!/bin/bash

usage() 
{
	echo "Usage :"
	echo "copyComponent2studio [options]... [component]..."
	echo "deploy a list of components to talend studio from source files"
	echo "-c clean osgi cache"
	echo "-s start the studio after deploy"
	echo "-h this message"
}

if [ $# -eq 0 ]; then 
	usage
	exit 1	
fi

[ -z "$tdi_compos_dir" ] 		&& tdi_compos_dir="/c/Users/akhabali/dev/github/tdi-studio-ee/main/plugins/org.talend.designer.components.tisprovider/components"
[ -z "$studio_dir" ] 			&& studio_dir="/c/Users/akhabali/dev/TalendStudio/6.5.0/Talend-Studio-20170929_2250-V6.5.0SNAPSHOT"
[ -z "$studio_tdi_compo_dir" ] 	&& studio_tdi_compo_dir=${studio_dir}"/plugins/org.talend.designer.components.tisprovider_6.5.0.20170929_2250-SNAPSHOT/components"  
[ -z "$studio_tdi_conf_dir" ] 	&& studio_tdi_conf_dir=${studio_dir}"/configuration"

studio_exe="Talend-Studio-win-x86_64.exe"
studio_options="-console"

REMOVE_CACHE=0
START_STUDIO=0
while getopts hsc option 
do
	case $option in
		c) REMOVE_CACHE=1 ;;
		s) START_STUDIO=1 ;;
		h) usage ;;  
	esac
done

shift $(($OPTIND - 1))

if [ $# -eq 0 ]; then 
	usage
	exit 1	
fi

# Copy component to the studio
for component in $@
do
	compo_dir=${tdi_compos_dir}/${component}
	cp ${compo_dir}/* ${studio_tdi_compo_dir}/${component}/
	echo "Component ${component} to ${studio_tdi_compo_dir} copied"
done

# Remove the eclipse cache of the studio
if [ $REMOVE_CACHE -eq 1 ]
then
	echo "Remove eclipse configuration cache..."
	cd $studio_tdi_conf_dir
	rm -rf org.eclipse*
fi

# Execute the studio
if [ $START_STUDIO -eq 1 ]
then
	echo "Execute : ${studio_dir}/${studio_exe} ${studio_options}"
	cd $studio_dir
	./${studio_exe} ${studio_options} &
fi
exit 0