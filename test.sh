


#s1="https://github.com/rexdf/ChineseLocalization"

# 将/替换为空格，并按空格切割成数组
#arr1=(${s1//\// })

# 取最后一个个元素
# 取数组长度
#arr_count=${#arr1[@]}
#echo $arr_count
#echo ${arr1[$arr_count-1]}

# ---------------------------------------------------------------


s1="https://github.com/rexdf/ChineseLocalization.git"
s2="https://github.com/rexdf/ChineseLocalization"

# 从左向右取第一个.后的字符串
# 即取到的是 com/rexdf/ChineseLocalization.git
echo "${s1#*.}"

# 从左向右取最后一个.后的字符串
# 即取到的是 git
echo "${s1##*.}"

# 从右向左取.后的第一个字符串
# 即取到的是 https://github.com/rexdf/ChineseLocalization
echo "${s1%.*}"

# 从右向左取最后一个.后的字符串
# 取到的是 http://github
echo "${s1%%.*}"






# ---------------------------------------------------------------
