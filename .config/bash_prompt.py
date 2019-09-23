#!/usr/bin/env python3
"""Script to generate bash prompt"""
import os
import re
import sys
import threading

from subprocess import run, PIPE

#RESET = '\\[\x1b[0m\\]'
RESET = '\\[[m\\]'

CWD_BG1 = '\\[\x1b[44;1m\\]'
CWD_BG2 = '\\[\x1b[46;1m\\]'
CWD_FG = '\\[\x1b[37m\\]'
GIT_STATUS = ["git", "status", "-z", "--branch"]
GIT_DESCRIBE = ["git", "describe", "--always"]

GIT_BRANCH_MARK = '\u16b3'
GIT_NO_BRANCH_MARK = '\u16be'
GIT_BRANCH_BG = '\\[\x1b[40m\\]'
GIT_BRANCH_FG = '\\[\x1b[37m\\]'

GIT_AHEAD_CHR = chr(8673)
GIT_BEHIND_CHR = chr(8675)
GIT_AHEADBEHIND_BG = '\\[\x1b[44m\\]'
GIT_AHEADBEHIND_FG = '\\[\x1b[37m\\]'

GIT_STAGED_MARK = chr(9757)
GIT_UNSTAGED_MARK = chr(9998)
GIT_UNTRACKED_MARK = "\u2729"
GIT_FILES_BG = '\\[\x1b[48;5;52m\\]'
GIT_FILES_FG = '\\[\x1b[37m\\]'

OS_LOGOS_SUCCESS_BG = '\[\x1b[42m\\]'
OS_LOGOS_FAIL_BG = '\[\x1b[41m\\]'
OS_LOGOS_SUCCESS_FG = '\[\x1b[37m\\]'
OS_LOGOS_FAIL_FG = '\[\x1b[31m\\]'

OS_LOGOS_MARKS = {
    "darwin" : chr(63743),
    "default" : "#"
}

def get_os_segment(status):
    """Returns an icon showing which OS you're on.

    Also displays success/failure of last command using the background. """
    bg = OS_LOGOS_SUCCESS_BG if status == 0 else OS_LOGOS_FAIL_BG
    fg = OS_LOGOS_SUCCESS_FG if status == 0 else OS_LOGOS_FAIL_FG

    if sys.platform in OS_LOGOS_MARKS:
        return [fg, " ", OS_LOGOS_MARKS[sys.platform], " ", RESET, "$"]
        #return [RESET, bg, OS_LOGOS_FG, " ", OS_LOGOS_MARKS[sys.platform], " "]
    else:
        return [fg, " ", OS_LOGOS_MARKS["default"], " ", RESET, "$"]
        #return [RESET, bg, OS_LOGOS_FG, " ", OS_LOGOS_MARKS["default"], " "]

def get_git_segment():
    """Returns a segment with some git status"""
    proc = run(GIT_STATUS, encoding='utf8', stdout=PIPE, stderr=PIPE)

    if proc.returncode != 0:
        return []

    detached = r"## HEAD"
    branch = r"## (\S*?)(\.\.\.|$)"
    ahead = r".*ahead (\d+)"
    behind = r".*behind (\d+)"

    rows = proc.stdout.split("\0")

    result = []

    if rows[0].startswith(detached):
        desc_proc = run(GIT_DESCRIBE, encoding='utf8', stdout=PIPE, stderr=PIPE)
        desc = desc_proc.stdout.strip()
        # TODO: replace this with a thing describing the commit
        result.extend([RESET, GIT_BRANCH_BG, GIT_BRANCH_FG])
        result.extend([" ", GIT_NO_BRANCH_MARK, " ", desc, " "])
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

    staged    = r"[MARCD][ MARCD]"
    unstaged  = r"[MARCD ][MARCD]"
    untracked = r"??"
    staged_count = 0
    unstaged_count = 0
    untracked_count = 0

    for row in rows[1:]:
        if row.startswith(untracked):
            untracked_count += 1
        else:
            if re.match(staged, row):
                staged_count += 1
            if re.match(unstaged, row):
                unstaged_count += 1

    show_files_segment = untracked_count + staged_count + unstaged_count > 0

    if show_files_segment:
        result += [RESET, GIT_FILES_BG, GIT_FILES_FG, " "]

    if staged_count > 0:
        result += [GIT_STAGED_MARK, " " + str(staged_count) if staged_count > 0 else "",  " "]

    if unstaged_count > 0:
        result += [GIT_UNSTAGED_MARK, " " + str(unstaged_count) if unstaged_count > 0 else "",  " "]

    if untracked_count > 0:
        result += [GIT_UNTRACKED_MARK, " " + str(untracked_count) if untracked_count > 0 else "",  " "]

    #result.append(RESET);

    return result

def get_path_segment(shorten = 80):
    """Gets the segment representing the current path"""
    parts = []

    # normpath probably not necessary, but it doesn't hurt
    cwd = os.path.normpath(os.environ['PWD'])

    segments = []

    if "HOME" in os.environ and cwd.startswith(os.environ["HOME"]):
        cwd = "~" + cwd[len(os.environ["HOME"]):]
    else:
        segments.append(" / ")


    for segment in cwd.split("/"):
        stripped = segment.strip()
        if stripped != "":
            segments.append(" " + stripped + " ")

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

    line = []

    git_segment = []

    git_thread = threading.Thread(target = lambda: git_segment.extend(get_git_segment()))

    git_thread.start()

    path_segment = get_path_segment(60)
    os_segment = get_os_segment(status)

    git_thread.join(0.25)

    line.extend("\n")
    line.extend(path_segment)

    if git_thread.isAlive():
        line.extend([GIT_BRANCH_BG, GIT_BRANCH_FG, " ... ", RESET])
    else:
        line.extend(git_segment)

    line.extend([RESET, "\n", RESET])
    line.extend(os_segment)
    line.extend([RESET, " ", RESET])

    return "".join(line)


if __name__ == "__main__":
    status_code = sys.argv[1] if len(sys.argv) > 1 else 0
    sys.stdout.write(ps1(int(status_code)))
