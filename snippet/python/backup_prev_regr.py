#!/semifive/tools/python/python/3.7.1/bin/python3
import argparse, os, subprocess, json, pathlib, re, shutil

'''
Backup prev regression repo.
Default repo number is 5.
'''

THIS_DIR = os.path.dirname(os.path.abspath(__file__))

def parser():
  parse = argparse.ArgumentParser(description="Backup prev regression repo")
  parse.add_argument("--project", type=str, default="RHEA_EVT1", help="Project name")
  parse.add_argument("--latest_path", type=valid_path_type, default="/user/jenkins/LOGIC_CI/PROJECT", help="Latest project path")
  parse.add_argument("--prev_path", type=valid_path_type, default="/user/jenkins/LOGIC_CI/PROJECT_BG", help="Backup project path")
  parse.add_argument("--num", type=int, default=5, help="Number of prev repo")
  return parse

def valid_path_type(path_check: str) -> pathlib.Path:
  """Custom argparse type for real path"""
  try:
    if os.path.isdir(path_check) is False:
      raise ValueError
    return pathlib.Path(path_check)
  except ValueError:
      raise argparse.ArgumentTypeError(f"This path ({path_check}) not valid! ")

def check_project(path_check: pathlib.Path, project: str):
  t_path = path_check / project
  if os.path.isdir( t_path ) is False:
    try:
      print(f"Make dir :: {t_path}")
      t_path.mkdir()
    except:
      raise argparse.ArgumentTypeError(f"Is this path ({path_check}) yours? ")
  return t_path

def remove_directory(directory):
    for item in directory.iterdir():
        if item.is_dir():
            remove_directory(item)
        else:
            item.unlink()
    directory.rmdir()

def main(args : dict):

  latest_dir = check_project( args.get('latest_path'), args.get('project') )
  prev_dir = check_project( args.get('prev_path'), args.get('project') )

  prev_dirs = {}
  for file in prev_dir.glob("prev_regr_*"):
    tmp_num = str(file).split('_')[-1]
    if tmp_num.lstrip("-").isdigit():
      prev_dirs.update( {tmp_num : file} )

  for each in sorted(prev_dirs, key=lambda x:prev_dirs[x], reverse=True):
    if int(each) >= args.get('num') -1:
      remove_directory(prev_dirs.get(each))
      print(f"Delete prev_regr_{each}")
    else:
      prev_dirs.get(each).rename(prev_dir / f"prev_regr_{int(each)+1}")
      print(f"Change prev_regr_{each} --> prev_regr_{int(each)+1}")

  shutil.copytree(latest_dir, prev_dir / "prev_regr_0")
  print(f"Copy {args.get('project')} -> prev_regr_0")

if __name__ == "__main__":
  args = vars(parser().parse_args())
  main(args)