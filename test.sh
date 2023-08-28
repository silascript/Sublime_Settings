


s1="https://github.com/rexdf/ChineseLocalization"

# 将/替换为空格，并按空格切割成数组
arr1=(${s1//\// })

# 取最后一个个元素
# 取数组长度
arr_count=${#arr1[@]}
#echo $arr_count
echo ${arr1[$arr_count-1]}

