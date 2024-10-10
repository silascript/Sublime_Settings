# ---------------------------------------------------------------
# 				测试
# ---------------------------------------------------------------

# 数组基础测试

# arr_t1=("a" "a1" "t1")
# arr_t2=("b" "b1")

# arr_t1+=(${arr_t2[@]})

# echo "${arr_t1[@]}"

# s1="https://github.com/rexdf/ChineseLocalization"
# s1=https://github.com/SublimeText/AFileIcon/releases/download/3.24.1/A.File.Icon.sublime-package
# s1=https://github.com/vuejs/vue-syntax-highlight/tree/st4-tests
# 将/替换为空格，并按空格切割成数组
# arr1=(${s1//\// })

# 取最后一个个元素
# 取数组长度
#arr_count=${#arr1[@]}
#echo $arr_count
#echo ${arr1[$arr_count-1]}

# echo ${arr1[1]}
# echo ${arr1[4]}

# 如果是github仓库分支
# 就取倒数第三个
# if [ ${arr1[-2]} == "tree" ];then
# echo ${arr1[-3]}
#
# else
# echo ${arr1[-1]}
# fi

# 取出tree之前的地址
# if [ ${arr1[-2]} == "tree" ];then
# echo ${s1%/tree*}
#
# else
# echo $s1
# fi

# ---------------------------------------------------------------

#s1="https://github.com/rexdf/ChineseLocalization.git"
#s2="https://github.com/rexdf/ChineseLocalization"

# 从左向右取第一个.后的字符串
# 即取到的是 com/rexdf/ChineseLocalization.git
#echo "${s1#*.}"

# 从左向右取最后一个.后的字符串
# 即取到的是 git
#echo "${s1##*.}"

# 从右向左取.后的第一个字符串
# 即取到的是 https://github.com/rexdf/ChineseLocalization
#echo "${s1%.*}"

# 从右向左取最后一个.后的字符串
# 取到的是 http://github
#echo "${s1%%.*}"

# ---------------------------------------------------------------

# 读取文件

# ---------------------------------------------------------------
