#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
xml2partdata.py — 把 ERP 匯出的料號 XML 轉成資訊點用的資料檔。

用途
    「自動建立資訊點」(&automakepart) 原本靠 camprobom.exe 查 SQL 取得料號資料。
    資料庫已不存在，改由本腳本把 ERP 匯出的 XML 轉成 LISP 可直接讀的純文字檔。

輸入
    ERP「XML」格式匯出（UTF-16LE + BOM），元素結構：
        <資訊點料號><資訊點料號_row><cod_item>..</cod_item>...</資訊點料號_row>...

輸出
    partdata.txt — cp950、CRLF、分號分隔，格式與原本的 database.txt 相容：
        料號;TAG3;TAG9;TAG10;TAG4;TAG8;TAG5      ← 第一行是欄位對應
        <料號>;<品名>;<英文品名>;<規格>;<材質>;<表面處理>;<料號>

    分隔符沿用分號而非 TAB，是為了不動到 PUB-LISP.lsp 的 get_word 與
    MANAPART.lsp / campro.lsp 裡兩份重複的 get_taglist（兩份都把 ";" 寫死）。
    本腳本保證輸出的欄位值裡不含分號，所以分隔是安全的。

用法
    python tools/xml2partdata.py <來源.xml> [輸出.txt]
    未指定輸出時，寫到 C:\\DESIGNER6_DS\\partdata.txt
"""

import collections
import os
import re
import sys

# ---------------------------------------------------------------- 欄位對應
# XML 欄位 -> 資訊點 TAG。順序即輸出欄位順序。
# TAG5（#圖號）在 ERP 沒有對應欄位，依現場慣例直接用料號填。
COLUMNS = [
    ('cod_item',      None),     # 料號，比對鍵（對應圖層名稱）
    ('nam_item',      'TAG3'),   # 品名
    ('nam_eng',       'TAG9'),   # 英文品名
    ('dsc_item',      'TAG10'),  # 規格
    ('material_item', 'TAG4'),   # 材質
    ('surface_item',  'TAG8'),   # 表面處理
    ('cod_item',      'TAG5'),   # #圖號 = 料號
]

# ------------------------------------------------------- cp950 無法表示的字
# DraftSight 的 read-line 只吃 cp950（2026-09-10 實機證實，見手冊 §3.1），
# 所以這些字必須換成 cp950 裡的等義字，而不是讓它變成問號。
REPLACE = {
    # --- 工程符號 ---
    'Ø': 'φ', '∅': 'φ', 'ø': 'φ', 'ɸ': 'φ',   # 直徑
    '²': '2', '˚': '°', 'ﾟ': '°', '−': '-',
    # --- 罕用字／異體字 ---
    '堃': '坤', '鈎': '鉤', '鉢': '缽', '綫': '線', '噐': '器', '釺': '纖',
    # --- 簡體 -> 繁體 ---
    '轴': '軸', '带': '帶', '盖': '蓋', '头': '頭', '钣': '鈑', '径': '徑',
    '内': '內', '库': '庫', '电': '電', '标': '標', '门': '門', '压': '壓',
    '线': '線', '编': '編', '码': '碼', '护': '護', '双': '雙', '铣': '銑',
    '侧': '側', '单': '單', '达': '達', '组': '組', '滤': '濾', '动': '動',
    '领': '領', '轮': '輪', '键': '鍵', '连': '連', '长': '長', '挡': '擋',
    '宝': '寶', '奥': '奧', '玛': '瑪', '劲': '勁', '欧': '歐', '龙': '龍',
    '冲': '沖', '过': '過', '块': '塊', '钵': '缽', '转': '轉', '阳': '陽',
    '软': '軟', '贴': '貼', '亚': '亞', '轨': '軌', '镀': '鍍', '锌': '鋅',
    '总': '總', '开': '開', '却': '卻', '锈': '鏽', '无': '無', '对': '對',
    '边': '邊', '础': '礎', '数': '數', '温': '溫', '传': '傳', '辅': '輔',
    '误': '誤', '综': '綜', '补': '補', '偿': '償', '统': '統', '滚': '滾',
    '链': '鏈', '刹': '剎', '纹': '紋', '圆': '圓', '销': '銷', '钉': '釘',
    '学': '學', '点': '點', '应': '應', '纸': '紙', '导': '導', '饰': '飾',
    '视': '視', '钩': '鉤', '暂': '暫', '关': '關', '脱': '脫', '垫': '墊',
    '顶': '頂', '渗': '滲', '铜': '銅', '档': '檔', '脚': '腳', '绅': '紳',
    '宽': '寬', '罗': '羅', '艺': '藝', '杨': '楊', '马': '馬', '缆': '纜',
    '卧': '臥', '换': '換', '变': '變', '号': '號', '红': '紅', '维': '維',
    '观': '觀', '图': '圖', '润': '潤', '药': '藥', '剂': '劑', '胀': '脹',
    '货': '貨',
}

ROW_TAG = '資訊點料號_row'
ILLEGAL_CTRL = re.compile(r'[\x00-\x08\x0B\x0C\x0E-\x1F]')
ENTITIES = [('&lt;', '<'), ('&gt;', '>'), ('&quot;', '"'),
            ('&apos;', "'"), ('&amp;', '&')]


def unescape(s):
    for a, b in ENTITIES:
        s = s.replace(a, b)
    return s


def sanitise(value, stats):
    """把一個欄位值整理成可安全寫進分號分隔 cp950 檔案的形式。"""
    # 換行與 TAB -> 空白（換行會拆斷記錄）
    if '\n' in value or '\r' in value:
        stats['newline'] += 1
        value = value.replace('\r', ' ').replace('\n', ' ')
    if '\t' in value:
        stats['tab'] += 1
        value = value.replace('\t', ' ')
    # 分號 -> 全形分號（分號是我們的分隔符）
    if ';' in value:
        stats['semicolon'] += 1
        value = value.replace(';', '；')
    # cp950 無法表示的字
    out = []
    for ch in value:
        try:
            ch.encode('cp950')
            out.append(ch)
        except UnicodeEncodeError:
            rep = REPLACE.get(ch)
            if rep is None:
                stats['unmapped'][ch] += 1
                out.append('?')
            else:
                stats['replaced'][ch] += 1
                out.append(rep)
    value = ''.join(out)
    return re.sub(r'\s+', ' ', value).strip()


def completeness(vals):
    """欄位齊全度。品名若等於料號視同沒填（ERP 裡有這種佔位列）。"""
    score = 0
    for i, v in enumerate(vals[1:], 1):
        v = v.strip()
        if not v:
            continue
        if i == 1 and v.upper() == vals[0].strip().upper():
            continue          # 品名 == 料號，不算
        if COLUMNS[i][1] == 'TAG5':
            continue          # TAG5 是複製料號，不列入計分
        score += 1
    return score


def check_replacements():
    """開工前先確認每個替換目標本身都能用 cp950 寫出來。"""
    bad = []
    for src, dst in REPLACE.items():
        try:
            dst.encode('cp950')
        except UnicodeEncodeError:
            bad.append((src, dst))
    if bad:
        sys.exit('替換表有問題，以下目標字元 cp950 也寫不出來: %s' % bad)


def convert(src, dst):
    check_replacements()

    raw = open(src, 'rb').read()
    text = raw.decode('utf-16')          # 吃掉 UTF-16LE BOM
    body = text.split('?>', 1)[1] if text.lstrip().startswith('<?xml') else text
    body, n_ctrl = ILLEGAL_CTRL.subn('', body)

    row_re = re.compile(r'<%s>(.*?)</%s>' % (ROW_TAG, ROW_TAG), re.S)
    fld_re = {name: re.compile(r'<%s>(.*?)</%s>' % (name, name), re.S)
              for name, _ in COLUMNS}

    stats = collections.Counter()
    stats['replaced'] = collections.Counter()
    stats['unmapped'] = collections.Counter()
    picked = {}          # 大寫料號 -> 目前選中的那筆
    order = []           # 保持輸出順序
    collisions = collections.defaultdict(list)

    for m in row_re.finditer(body):
        blk = m.group(1)
        vals = []
        for name, _ in COLUMNS:
            fm = fld_re[name].search(blk)
            vals.append(sanitise(unescape(fm.group(1)), stats) if fm else '')
        key = vals[0].upper()
        if not key:
            stats['nokey'] += 1
            continue
        collisions[key].append(vals)
        if key not in picked:
            picked[key] = vals
            order.append(key)
        else:
            # 料號只差大小寫時，get_database&subst 用 strcase 比對會撞在一起，
            # 只能留一筆。留欄位比較齊全的那一筆，而不是先讀到的那一筆——
            # 實測資料裡有「品名直接填料號」的佔位列，先到先得會選到它。
            stats['dup'] += 1
            if completeness(vals) > completeness(picked[key]):
                picked[key] = vals

    rows = [picked[k] for k in order]
    stats['collision_keys'] = sum(1 for v in collisions.values() if len(v) > 1)
    ambiguous = [(k, v) for k, v in collisions.items()
                 if len(v) > 1 and len(set(x[1] for x in v if x[1].strip())) > 1]

    header = ';'.join(['料號'] + [tag for _, tag in COLUMNS[1:]])
    with open(dst, 'wb') as f:
        f.write((header + '\r\n').encode('cp950'))
        for r in rows:
            f.write((';'.join(r) + '\r\n').encode('cp950'))

    # ------------------------------------------------------------ 處理報告
    print('來源  : %s (%.1f MB)' % (src, len(raw) / 1048576))
    print('輸出  : %s (%.1f MB)' % (dst, os.path.getsize(dst) / 1048576))
    print('表頭  : %s' % header)
    print()
    print('寫出筆數        : %s' % format(len(rows), ','))
    print('清掉非法控制字元: %d' % n_ctrl)
    print('料號為空而跳過  : %d' % stats['nokey'])
    print('料號大小寫碰撞  : %d 組、捨棄 %d 列（留欄位較齊的一筆）'
          % (stats['collision_keys'], stats['dup']))
    print('欄位含換行已改空白: %d' % stats['newline'])
    print('欄位含 TAB 已改空白: %d' % stats['tab'])
    print('欄位含分號已改全形: %d' % stats['semicolon'])
    print()
    rep = stats['replaced']
    print('字元替換: %d 種、共 %d 次' % (len(rep), sum(rep.values())))
    for ch, n in rep.most_common(12):
        print('    %s -> %s  (%d)' % (ch, REPLACE[ch], n))
    if len(rep) > 12:
        print('    ...另有 %d 種' % (len(rep) - 12))
    un = stats['unmapped']
    if un:
        print()
        print('!! 替換表沒收錄、已變成問號: %d 種' % len(un))
        for ch, n in un.most_common():
            print('    %s U+%04X (%d)' % (ch, ord(ch), n))
        print('   請把這些字加進 REPLACE 後重跑。')
    else:
        print()
        print('沒有任何字元變成問號。')

    if ambiguous:
        print()
        print('!! 以下料號只差大小寫、但品名不同，請人工確認留對了沒:')
        for k, lst in ambiguous:
            print('    %s' % k)
            for v in lst:
                mark = ' <- 已採用' if v is picked[k] else ''
                print('        [%s] %s%s' % (v[0], v[1], mark))


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    source = sys.argv[1]
    target = sys.argv[2] if len(sys.argv) > 2 else r'C:\DESIGNER6_DS\partdata.txt'
    convert(source, target)
