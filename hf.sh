#!/bin/bash

# 帮助信息函数
show_help() {
cat << EOF
用法: ${0##*/} 参数1 参数2 参数3

    NAME=${1}
    TYPE=${2:-"model"}
    OUTPUT_DIR=${3:-"/data/yanghq/${TYPE}s/${NAME}/"}

EOF
}

prompt_continue() {
    while true; do
        read -p "Do you want to continue? [y/n]: " input
        case $input in
            [Yy]* ) break;;
            [Nn]* ) echo "Exiting program."; exit;;
            * ) echo "Invalid input. Please enter y or n.";;
        esac
    done
}

for arg in "$@"; do
    if [[ "$arg" == "--help" ]]; then
        show_help
        exit 1
    fi
done

NAME=${1}
TYPE=${2:-"model"}
OUTPUT_DIR=${3:-"/data/yanghq/${TYPE}s/${NAME}/"}
if [ $# -lt 1 ] || [ $# -gt 3 ]; then
    echo "传递给脚本的参数个数：$#"
    show_help
    exit 1
fi

if [ "$TYPE" = "model" ]; then
    echo "huggingface-cli download --local-dir-use-symlinks False --resume-download $NAME --local-dir $OUTPUT_DIR"
    prompt_continue
    huggingface-cli download --local-dir-use-symlinks False --resume-download $NAME --local-dir $OUTPUT_DIR --token "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"
elif [ "$TYPE" = "dataset" ]; then
    echo "huggingface-cli download --local-dir-use-symlinks False --repo-type dataset --resume-download $NAME --local-dir $OUTPUT_DIR"
    prompt_continue
    huggingface-cli download --local-dir-use-symlinks False --repo-type dataset --resume-download $NAME --local-dir $OUTPUT_DIR --token "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"
else
    echo "下载类型错误：$#"
    show_help
    exit 1
fi

echo ""
echo "Done, ${NAME}, ${TYPE}, ${OUTPUT_DIR}"