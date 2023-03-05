#!/bin/bash

# 获取文件夹路径
read -p "请输入文件夹路径: " folder_path

# 定义函数：替换markdown文件中的网络图片链接
replace_image_links() {
  regex='https?://\S+\.(png|jpg|jpeg|bmp|gif|webp)'
  links=$(grep -rEoh "$regex" "$1" | sed -E 's/.*\(([^)]+)\)/\1/')
  # links=$(cat $1 | grep -oE "$regex" | sed 's/.*(\(.*\))/\1/')
  
  # echo links: "$links"
  dir_name=$(dirname "$1")
  # 创建 image 文件夹
  # 将每个链接替换为对应的本地图片链接
  local_path="$dir_name/image"
  mkdir -p "$local_path"
  echo local_path====== "$local_path"
  for link in $links; do
    echo link: "$link"
    image_path=$(basename "$link")
    local_link="./image/$image_path"
    # 下载图片
    curl -s "$link" --create-dirs -o "$local_path/$image_path"
    # 替换链接
    sed -i '' -e "s|$link|$local_link|g" "$1"
  done
}

# 遍历所有markdown文件
find "$folder_path" -name "*.md" | while read file_path; do
  replace_image_links "$file_path"
done
