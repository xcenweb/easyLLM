import json
import argparse
# from modelscope import snapshot_download

parser = argparse.ArgumentParser(
    prog="easyLLM_manageLLM",
    description="管理LLM",
    epilog="Github仓库: https://github.com/xcenweb/easyLLM"
)
parser.add_argument('--hub', default="", type=str, help="模型仓库")
parser.add_argument('--download', default="", type=str, help="指定LLM")
parser.add_argument('--dir', default="", type=str, help="指定下载到目录")
args = parser.parse_args()

print(args)

def download_model():
    """
    下载LLM模型
    """
    # snapshot_download('IndexTeam/Index-1.9B-Chat', './model/')
    pass