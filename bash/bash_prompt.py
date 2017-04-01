#!/usr/bin/env python3
"""Script to generate bash prompt"""
import os
import re
import sys

from subprocess import run, PIPE

#RESET = '\\[\x1b[0m\\]'
RESET = '\\[(B[m\\]'

CWD_BG1 = '\\[\x1b[48;5;18m\\]'
CWD_BG2 = '\\[\x1b[48;5;19m\\]'
CWD_FG = '\\[\x1b[37m\\]'
GIT_CMD = ["git", "status", "-z", "--branch"]

GIT_BRANCH_MARK = chr(9282)
GIT_BRANCH_BG = '\\[\x1b[40m\\]'
GIT_BRANCH_FG = '\\[\x1b[37m\\]'

GIT_AHEAD_CHR = chr(8673)
GIT_BEHIND_CHR = chr(8675)
GIT_AHEADBEHIND_BG = '\\[\x1b[44m\\]'
GIT_AHEADBEHIND_FG = '\\[\x1b[37m\\]'

GIT_STAGED_MARK = chr(9757)
GIT_UNSTAGED_MARK = chr(9998)
GIT_UNTRACKED_MARK = chr(10038)
GIT_FILES_BG = '\\[\x1b[48;5;52m\\]'
GIT_FILES_FG = '\\[\x1b[37m\\]'

OS_LOGOS_SUCCESS_BG = '\\[\x1b[42m\\]'
OS_LOGOS_FAIL_BG = '\\[\x1b[41m\\]'
OS_LOGOS_FG = '\\[\x1b[37m\\]'

OS_LOGOS_MARKS = {
    "linux" : "$",
    "darwin" : chr(63743),
    "default" : "%"
}

def get_os_segment(status):
    """Returns an icon showing which OS you're on.
    
    Also displays success/failure of last command using the background. """
    bg = OS_LOGOS_SUCCESS_BG if status == 0 else OS_LOGOS_FAIL_BG
    if sys.platform in OS_LOGOS_MARKS:
        return [RESET, bg, OS_LOGOS_FG, " ", OS_LOGOS_MARKS[sys.platform], " "]
    else:
        return [RESET, bg, OS_LOGOS_FG, " ", OS_LOGOS_MARKS["default"], " "]

def get_git_segment():
    """Returns a segment with some git status"""
    proc = run(GIT_CMD, encoding='utf8', stdout=PIPE, stderr=PIPE)

    if proc.returncode != 0:
        return []

    detached = r"## HEAD"
    branch = r"## (\S*?)(\.\.\.|$)"
    ahead = r".*ahead (\d+)"
    behind = r".*behind (\d+)"

    rows = proc.stdout.split("\0")

    result = []

    if rows[0].startswith(detached):
        # TODO: replace this with a thing describing the commit
        result.extend([RESET, GIT_BRANCH_BG, GIT_BRANCH_FG, " detached "])
    else: 
        match = re.match(branch, rows[0])
        if match:
            result += [RESET, GIT_BRANCH_BG, GIT_BRANCH_FG]
            result += [" ", GIT_BRANCH_MARK, " ", match.groups()[0], " "]

    ab = []

    ahead_match = re.match(ahead, rows[0])
    behind_match = re.match(behind, rows[0])

    if ahead_match:
        ab += [GIT_AHEAD_CHR, ahead_match.groups()[0]]

    if behind_match:
        if len(ab) > 0:
            ab.append(" ")

        ab += [GIT_BEHIND_CHR, behind_match.groups()[0]]

    if len(ab) > 0:
        result += [RESET, GIT_AHEADBEHIND_BG, GIT_AHEADBEHIND_FG]
        result.append(" ")
        result += ab
        result.append(" ")

    staged    = r"[MARC] "
    unstaged  = r" [MARC]"
    untracked = r"??"
    staged_count = 0
    unstaged_count = 0
    untracked_count = 0

    for row in rows[1:]:
        if row.startswith(untracked):
            untracked_count += 1
        elif re.match(staged, row):
            staged_count += 1
        elif re.match(unstaged, row):
            unstaged_count += 1

    show_files_segment = untracked_count + staged_count + unstaged_count > 0

    if show_files_segment:
        result += [RESET, GIT_FILES_BG, GIT_FILES_FG, " "]

    if staged_count > 0:
        result += [GIT_STAGED_MARK, " ", str(staged_count) if staged_count > 1 else "",  " "]

    if unstaged_count > 0:
        result += [GIT_UNSTAGED_MARK, " ", str(unstaged_count) if unstaged_count > 1 else "",  " "]

    if untracked_count > 0:
        result += [GIT_UNTRACKED_MARK, " ", str(untracked_count) if untracked_count > 1 else "",  " "]

    #result.append(RESET);

    return result

def get_path_segment(shorten = 80):
    """Gets the segment representing the current path"""
    parts = []

    # normpath probably not necessary, but it doesn't hurt
    cwd = os.path.normpath(os.environ['PWD'])

    if "HOME" in os.environ and cwd.startswith(os.environ["HOME"]):
        cwd = "~" + cwd[len(os.environ["HOME"]):]

    segments = []

    for segment in cwd.split("/"):
        segments.append(" " + segment + " ")

    ellipsis = " ... "
    removed = -1

    while len(segments) > 2 and sum(len(s) for s in segments) > shorten:
        removed = len(segments) // 2

        del segments[removed]

    if removed >= 0: 
        segments.insert(removed, ellipsis)

    
    parts = [RESET, CWD_FG]
    bg1 = CWD_BG1
    bg2 = CWD_BG2

    for segment in segments:
        parts.extend([bg1, segment])
        bg1, bg2 = bg2, bg1

    return parts

def ps1(status):
    """Get full prompt as a string"""
    
    line = get_path_segment(30) + get_git_segment() + get_os_segment(status) + [RESET, " ", RESET]

    return "".join(line)


if __name__ == "__main__":
    status_code = sys.argv[1] if len(sys.argv) > 1 else 0
    sys.stdout.write(ps1(int(status_code)))
