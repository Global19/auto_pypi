# 
# *********************************************************
# * Author        : LEI Sen
# * Email         : sen.lei@outlook.com
# * Create time   : 2018-11-21 18:29
# * Last modified : 2018-11-21 22:08
# * Filename      : setup.sh
# * Description   : 
# *********************************************************


## Check on package name input
if [ "$1" == "" ]; then
    echo "parameter 1 missing: package name needed! "
    exit
fi

## Check on version number input
#if [ "$2" == "" ]; then
#    echo "parameter 2 missing: package version number needed! "
#    exit
#fi



#echo """
#Now setting up new version package [$1 (v $2)] and uploading to PyPi ... 
#"""
echo """
Now setting up new version package [$1] and uploading to PyPi ... 
"""


dist_folder="dist/"
build_folder="build/"
egg_info_folder="$1.egg-info/"

if [ -d $dist_folder ]; then
    echo "  removing old dist folder ... "
    rm -r $dist_folder
else
    echo "  dist folder not found. "
fi

if [ -d $build_folder ]; then
    echo "  removing old build folder ... "
    rm -r $build_folder
else
    echo "  build folder not found. "
fi

if [ -d $egg_info_folder ]; then
    echo "  removing old egg info folder ... "
    rm -r $egg_info_folder
else
    echo "  egg info folder not found. "
fi



## Update the version number in setup.py



## Prepare for uploading
python3 -m pip install --user --upgrade setuptools wheel
echo """
"""
python3 setup.py sdist bdist_wheel
#python3 setup.py sdist bdist_wheel --long-description | rst2html.py --no-raw > output.html
echo """
"""

## Upload
python3 -m pip install --user --upgrade twine

echo """

Checking on the sdist and wheel ... (also check README rendering problem)
"""
twine check dist/*

echo """
"""
while true; do
    read -p 'Use Test PyPi? [Y/n]: ' check_test
    case $check_test in
	[Yy]* ) twine upload --repository-url https://test.pypi.org/legacy/ dist/*; break;;
	[Nn]* ) twine upload --repository-url https://upload.pypi.org/legacy/ dist/*; break;;
	* ) echo "Please answer yes or no.";;
    esac
done
