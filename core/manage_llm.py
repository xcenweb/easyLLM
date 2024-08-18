import json
import argparse
# from modelscope import snapshot_download

parser = argparse.ArgumentParser(
    prog="easyLLM_manageLLM",
    description="管理LLM",
    epilog="Github仓库: https://github.com/xcenweb/easyLLM"
)
parser.add_argument('--get', default="", type=str, choices=['installed', 'packages'], help="获取列表")
parser.add_argument('--remove', default="", type=str, help="删除指定LLM")
parser.add_argument('--download', default="", type=str, help="下载指定LLM")
args = parser.parse_args()

print(args)

def get_package():
    """
    获取受支持的LLM列表
    """
    pass


def get_installed():
    """
    获取所有已下载的LLM并输出列表
    """
    pass


def download_model():
    """
    下载LLM模型
    """
    # snapshot_download('IndexTeam/Index-1.9B-Chat', './model/')
    pass


def remove_model():
    """
    删除LLM模型
    """
    pass

