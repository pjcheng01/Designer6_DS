# -*- coding: utf-8 -*-
r"""
verify_original.py  —  比對本機的 AutoCAD 原版是否與交接文件所依據的版本相同

用法:
    python verify_original.py 原版雜湊清單.txt

為什麼需要:
    交接文件裡的所有行號（CONFIG.lsp:188、AUX-QURY.lsp:553 …）都以來源機器
    RD-DPC07 於 2026-10-06 的版本為準。若本機的 C:\DESIGNER6 是另一個
    vintage 的安裝，行號會對不上，照著改會改錯地方。
"""
import hashlib
import os
import sys


def load_manifest(path):
    trees, cur = {}, None
    with open(path, encoding='utf-8') as f:
        for line in f:
            line = line.rstrip('\n')
            if line.startswith('=== '):
                cur = line[4:].split('  ')[0].strip()
                trees[cur] = {}
            elif line and not line.startswith('#') and cur:
                parts = line.split(None, 2)
                if len(parts) == 3:
                    trees[cur][parts[2]] = (parts[0], int(parts[1]))
    return trees


def main():
    if len(sys.argv) < 2:
        print('用法: python verify_original.py 原版雜湊清單.txt')
        return 2
    trees = load_manifest(sys.argv[1])
    bad = 0
    for root, expect in trees.items():
        print('===== ' + root + ' =====')
        if not os.path.isdir(root):
            print('  目錄不存在，跳過')
            bad += 1
            continue
        same = diff = miss = extra = 0
        seen = set()
        for dirpath, _dirs, files in os.walk(root):
            for fn in files:
                fp = os.path.join(dirpath, fn)
                rel = os.path.relpath(fp, root).replace(os.sep, '/')
                if rel not in expect:
                    continue
                seen.add(rel)
                try:
                    h = hashlib.sha256(open(fp, 'rb').read()).hexdigest()[:16]
                except Exception:
                    continue
                if h == expect[rel][0]:
                    same += 1
                else:
                    diff += 1
                    print('  [內容不同] ' + rel)
        for rel in expect:
            if rel not in seen:
                miss += 1
                print('  [本機缺少] ' + rel)
        print('  相同 %d / 不同 %d / 缺少 %d' % (same, diff, miss))
        if diff or miss:
            bad += 1
        print('')
    if bad:
        print('*** 有差異：本機版本與交接文件的依據不同，行號可能對不上。***')
        return 1
    print('全部相同——交接文件的行號可以直接使用。')
    return 0


if __name__ == '__main__':
    sys.exit(main())
