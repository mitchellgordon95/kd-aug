from parse import parse
from subprocess import check_output
import os

TRAIN_SCORE_TEMPLATE = """{score}
"""

def parse_file(fname, template):
    try:
        with open(fname, 'r') as f:
            return parse(template, f.read())
    except FileNotFoundError:
        # print(f"Missing {fname}")
        return None

def train_loss(task, lang, domain, student_size):
    parts = [
         f'Domain.{domain}' if domain else '',
         f'Lang.{lang}' if lang else '',
         f'StudentSize.{student_size}' if student_size else '',
         f'TestMode.no',
    ]

    train_score_fname = f'out/{task}_score_train/{"+".join([part for part in parts if part])}/avgscore'
    parsed = parse_file(train_score_fname, TRAIN_SCORE_TEMPLATE)
    if parsed:
        return parsed['score']
    else:
        return 'inf'

def row(task, domain, student_size, pretty_name):
    return f"{pretty_name:40} & " + " & ".join([train_loss(task, lang, domain, student_size) for lang in ['deen', 'ruen']]) + "\\\\"

print(row('gd_teacher', None, None, 'Teacher'))
print(row('gd_student', None, 'half', 'Half Student'))
print(row('gd_baseline_student', None, 'half', 'Half Sized Baseline'))
print(row('gd_student', None, 'quarter', 'Quarter Student'))
print(row('gd_baseline_student', None, 'quarter', 'Quarter Sized Baseline'))

for domain in ['ted', 'wipo']:
    print()
    print('TED & & \\\\' if domain == 'ted' else "WIPO & & \\\\")
    print(row('adapted_teacher', domain, None, 'Adapted Teacher'))
    print(row('id_baseline_teacher', domain, None, 'Baseline Teacher'))

    print(row('adapted_gd_student', domain, 'half', 'Adapted Half GD Student'))
    print(row('adapted_gd_student_baseline', domain, 'half', 'Adapted GD Half Baseline'))
    print(row('id_student', domain, 'half', 'ID Half Student'))
    print(row('id_baseline_student', domain, 'half', 'ID Half Baseline Student'))
    print(row('id_small_baseline', domain, 'half', 'ID Half Baseline'))

    print(row('adapted_gd_student', domain, 'quarter', 'Adapted Quarter GD Student'))
    print(row('adapted_gd_student_baseline', domain, 'quarter', 'Adapted GD Quarter Baseline'))
    print(row('id_student', domain, 'quarter', 'ID Quarter Student'))
    print(row('id_baseline_student', domain, 'quarter', 'ID Quarter Baseline Student'))
    print(row('id_small_baseline', domain, 'quarter', 'ID Quarter Baseline'))
